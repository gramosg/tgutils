package TgLib::Cache;

use Storable qw<store retrieve>;
use File::Basename qw<dirname>;
use File::Path qw<make_path>;

use TgLib::Env qw<$CACHE_HOME>;

use parent qw<Exporter>;
our @EXPORT = qw<new>;

my $CACHE_FILE = "$CACHE_HOME/tgutils/cache";

sub new {
    my $class = shift;

    # Fetch cache
    return bless((-f $CACHE_FILE
                  ? retrieve($CACHE_FILE)
                  : {'version' => $main::VERSION}), $class);
}

sub offset {
    my $cache = shift;
    $cache->{'offset'} = shift if @_;
    return $cache->{'offset'};
}

sub save {
    my $cache = shift;
    make_path dirname $CACHE_FILE;
    store($cache, $CACHE_FILE);
}

1;
