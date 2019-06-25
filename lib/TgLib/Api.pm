package TgLib::Api;

use JSON qw<encode_json decode_json>;
use HTTP::Request;
use LWP::UserAgent;
use Data::Dumper;

use parent 'Exporter';
our @EXPORT = qw<new>;

sub new {
    my ($class, $token, $logger) = @_;
    return bless { uri => "https://api.telegram.org/bot$token",
                   ua => LWP::UserAgent->new,
                   logger => $logger }, $class;
}

sub get_updates {
    my ($self, $timeout, $offset) = @_;
    my $logger = $self->{'logger'};
    my $uri = "$self->{'uri'}/getUpdates?timeout=$timeout";
    $uri = $uri . "&offset=$offset" if $offset;

    my $req = HTTP::Request->new("GET", $uri);
    $logger->debug("Request: " . Dumper($req));

    my $resp = $self->{'ua'}->request($req);
    $logger->debug("Response: " . Dumper($resp));

    if ($resp->is_error()) {
        die $resp->message;
    } else {
        my $updates = decode_json($resp->content)->{'result'};
        $logger->info(sprintf "Received %d updates from chats %s\n",
                     scalar(@$updates),
                     join(", ", map { $_->{'message'}{'chat'}{'id'} } @$updates));
        return $updates;
    }
}

sub send_message {
    my ($self, $chat_id, $text) = @_;
    my $logger = $self->{'logger'};
    my $uri = "$self->{'uri'}/sendMessage";
    my $content = encode_json {'chat_id' => $chat_id, 'text' => $text};

    my $req = HTTP::Request->new("POST", $uri,
                               ["Content-Type", "application/json"], $content);
    $logger->info("Sending to $chat_id: '$text'\n");
    $logger->debug(sprintf "Request:\n%s\n", Dumper($req));

    my $resp = $self->{'ua'}->request($req);
    $logger->debug(sprintf "Response:\n%s\n", Dumper($resp));
    if ($resp->is_error()) {
        die $resp->message;
    }
}

1;
