#!/usr/bin/env perl

use strict;
use warnings;

use Pod::Man;

Pod::Man->new(release => 1, section => 1)->parse_from_file(@ARGV[0 .. 1]);
