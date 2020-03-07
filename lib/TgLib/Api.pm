package TgLib::Api;

use strict;
use warnings;

use JSON qw<encode_json decode_json>;
use HTTP::Request;
use HTTP::Request::Common qw<POST>;
use LWP::UserAgent;
use Data::Dumper;

use parent 'Exporter';
our @EXPORT = qw<new>;

sub new {
    my ($class, $token, $logger) = @_;
    return bless { uri => "https://api.telegram.org/bot$token",
                   file_uri => "https://api.telegram.org/file/bot$token",
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
        # TODO why does `decode_json` not do this work?
        map { utf8::encode($_->{'message'}{'text'}) if exists $_->{'message'} && exists $_->{'message'}{'text'} } @$updates;
        $logger->debug(sprintf "Received %d updates\n", scalar(@$updates)) if @$updates;
        return $updates;
    }
}

sub send_message {
    my ($self, $chat_id, $text) = @_;
    my $logger = $self->{'logger'};
    my $uri = "$self->{'uri'}/sendMessage";

    utf8::decode($text) unless utf8::is_utf8($text);
    my $content = encode_json {'chat_id' => $chat_id, 'text' => $text};
    my $req = HTTP::Request->new("POST", $uri,
                               ["Content-Type", "application/json"], $content);
    $logger->debug(sprintf "Request:\n%s\n", Dumper($req));

    my $resp = $self->{'ua'}->request($req);
    $logger->debug(sprintf "Response:\n%s\n", Dumper($resp));
    if ($resp->is_error()) {
        die $resp->message;
    }
}

sub send_document {
    my ($self, $chat_id, $photo, $caption) = @_;
    my $logger = $self->{'logger'};
    my $uri = "$self->{'uri'}/sendDocument";
    my $content = {'chat_id' => $chat_id,
                       'caption' => $caption,
                       'document' => [undef, 'cosa.png', Content => $photo]};

    my $req = POST $uri, 'Content-Type' => "multipart/form-data", 'Content' => $content;
    $logger->debug(sprintf "Request:\n%s\n", Dumper($req)); # DEBUG

    my $resp = $self->{'ua'}->request($req);
    $logger->debug(sprintf "Response:\n%s\n", Dumper($resp));
    if ($resp->is_error()) {
        print decode_json($resp->content)->{'description'};
        die $resp->message;
    }
}

sub get_file {
    my ($self, $file_id) = @_;
    my $logger = $self->{'logger'};
    my $uri = "$self->{'uri'}/getFile";
    my $content = encode_json {'file_id' => $file_id};

    my $req = HTTP::Request->new("POST", $uri,
                               ["Content-Type", "application/json"], $content);
    $logger->debug(sprintf "Request:\n%s\n", Dumper($req));

    my $resp = $self->{'ua'}->request($req);
    $logger->debug(sprintf "Response:\n%s\n", Dumper($resp));
    if ($resp->is_error()) {
        die $resp->message;
    } else {
        my $file_path = decode_json($resp->content)->{'result'}{'file_path'};

        my $uri = "$self->{'file_uri'}/$file_path";
        my $req = HTTP::Request->new("GET", $uri);
        $logger->debug(sprintf "Request:\n%s\n", Dumper($req));

        my $resp = $self->{'ua'}->request($req);
        $logger->debug(sprintf "Response:\n%s\n", Dumper($resp));

        if ($resp->is_error()) {
            die $resp->content;
        } else {
            return $resp->content;
        }
    }
}

1;
