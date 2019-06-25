package TgLib::Logger;

use parent qw<Exporter>;
our @EXPORT = qw<new debug info warn>;

my %level = (warn => 0, info => 1, debug => 2);

sub log_level {
    my ($self, $msg, $level) = @_;
    print STDERR "[$level] $msg" if $level{$level} <= $self->{'level'};
}

################################################################################
# Public

sub new {
    my ($class, $verbose) = @_;
    return bless { level => $verbose }, $class;
}

sub debug { log_level(@_, 'debug'); }
sub info { log_level(@_, 'info'); }
sub warn { log_level(@_, 'warn'); }

1;
