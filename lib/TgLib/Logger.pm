package TgLib::Logger;

use parent qw<Exporter>;
our @EXPORT = qw<new debug info>;

my %level = (info => 1, debug => 2);

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

1;
