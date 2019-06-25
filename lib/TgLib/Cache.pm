package TgLib::Cache;

use Storable qw<store retrieve>;
use File::Basename qw<dirname>;
use File::Path qw<make_path>;
use Data::Dumper;

use TgLib::Env qw<$CACHE_HOME>;

use parent qw<Exporter>;
our @EXPORT = qw<new>;

my $CACHE_FILE = "$CACHE_HOME/tgutils/cache";

sub new {
    my ($class, $logger) = @_;
    my $cache = -f $CACHE_FILE
        ? retrieve($CACHE_FILE)
        : { version => 1 };
    $logger->debug("Using cache: " . Dumper($cache));

    # Fetch cache
    return bless { cache => $cache, logger => $logger }, $class;
}

sub offset {
    my $self = shift;
    if (@_) {
        $self->{'cache'}{'offset'} = shift;
        $self->save;
    }
    return $self->{'cache'}{'offset'};
}

# Not needed to be called explicitly; every cache modification calls this
sub save {
    my $self = shift;
    make_path dirname $CACHE_FILE;
    store($self->{'cache'}, $CACHE_FILE);
    $self->{'logger'}->debug(sprintf "Saved cache: %s\n", Dumper($self->{'cache'}));
}

1;
