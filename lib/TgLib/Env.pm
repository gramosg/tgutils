package TgLib::Env;

use parent qw<Exporter>;
our @EXPORT = qw<$HOME $CONFIG_HOME $CACHE_HOME>;

our $HOME = $ENV{'HOME'};
our $CONFIG_HOME = $ENV{'XDG_CONFIG_HOME'} || "$HOME/.config";
our $CACHE_HOME = $ENV{'XDG_CACHE_HOME'} || "$HOME/.cache";

1;
