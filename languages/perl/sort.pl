#!perl
use warnings;
use strict;
use Getopt::Long;
use Data::Dumper;

my %Config = 
(
    Implementation  => 1,
    Help            => 0,
    ThisScript      => $0,
);

sub Usage
{
    printf("Usage: %s [--help] [--impl <0,1,2>]$/",$Config{ThisScript});
    printf(" --help   display this help message$/");
    printf(" --impl   specifcy the implementation to use$/");
    return 1;
}

sub main
{
    Usage() and return 1 if not GetOptions(
                "help" => \$Config{Help},
                "impl" => \$Config{Implementation} );
    Usage() and return 0 if $Config{Help};
          
    doStuff();
}

sub doStuff
{
    printf("I'm here$/");
    my $in = *STDIN;
    
    printf("%s$/",Dumper(\%::));
    my $foo = 'foobar';
    *FOO = $foo;
    printf("%s$/",Dumper(\%::));
    
    printf("*FOO typeglob is [%s]$/",*FOO);
    printf("*FOO typeglob is [%s]$/",$foo);    
    
    
    
}

main();

