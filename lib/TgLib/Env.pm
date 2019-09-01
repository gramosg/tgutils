package TgLib::Env;

use strict;
use warnings;

use parent qw<Exporter>;
our @EXPORT = qw<$HOME $CONFIG_HOME $CACHE_HOME $TOKEN>;

our $HOME = $ENV{'HOME'};
our $CONFIG_HOME = $ENV{'XDG_CONFIG_HOME'} || "$HOME/.config";
our $CACHE_HOME = $ENV{'XDG_CACHE_HOME'} || "$HOME/.cache";
our $TOKEN = $ENV{'TGUTILS_TOKEN'};

1;
