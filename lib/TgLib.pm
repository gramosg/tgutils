package TgLib;

use TgLib::Env qw<$CONFIG_HOME>;

use parent qw<Exporter>;
our @EXPORT = qw<fetch_token>;

sub fetch_token {
    my $token = $ENV{'TGUTILS_TOKEN'};
    unless ($token) {
        open(my $cfg, "<", "$CONFIG_HOME/tgutils_token") or return;
        $token = <$cfg>;
        chomp $token;
        close $cfg;
    }
    $token =~ /^[0-9]+:[a-zA-Z0-9_-]+$/ or die "Invalid bot token ($token)";
    return $token;
}

1;
