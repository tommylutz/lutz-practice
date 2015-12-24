use warnings;
use strict;
use Data::Dumper;
use Devel::Peek;

{
	package globtut;
	
	our $someVar = 'foo';
	our @someArr = qw(4 3 2);
}

print Dumper(\%globtut::);
Dump(\%globtut::);

