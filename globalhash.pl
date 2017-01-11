use strict;
use warnings;
use 5.024;
use WebService::Slack::WebApi;
use List::Util qw( first );

my $api = WebService::Slack::WebApi->new(
  token => "..."
);

my($channel) = grep { $_->{name} eq 'globalhash' } $api->channels->list->{channels}->@*;

my $id = $channel->{id};

$ARGV[0]//='';

if($ARGV[0] eq 'get')
{
  my $key = $ARGV[1];
  my $res = $api->channels->history( channel => $id );
  my @messages =   $res->{messages}->@*;
  my $message = first { $_->{text} =~ /^$key=/ } reverse @messages;
  exit 2 unless $message;
  my($value) = $message->{text} =~ /^$key=(.*)$/;
  say $value;
}
elsif($ARGV[0] eq 'set')
{
  my($key, $value) = ($ARGV[1], $ARGV[2]);
  my $res = $api->chat->post_message(channel => $id, username => "globalhash", text => "$key=$value");
  die "error!" unless $res->{ok};
}
else
{
  die "unknown command $ARGV[0]";
}
