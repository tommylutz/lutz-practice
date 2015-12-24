#!perl

use strict;
use warnings;

my @vals = (3,5,78,2,4,154,46,3,12,4,6);

sub calcTreeDepth
{
    my $levels = 0;
    my $nodes = shift;
    my $nodesToChop = 1;
    while($nodes > 0)
    {
        $levels++;
        $nodes -= $nodesToChop;
        $nodesToChop *= 2;
    }
    return $levels;
}

sub getPaddingAtDepth
{
    my ($depth,$maxdepth) = shift;
    return 0 if $depth = $maxdepth;
    
}

sub printTree
{
    my @tree = @_;
    my $depth = calcTreeDepth(scalar @tree);
    printf("Tree of %d items has %d levels\n",scalar @tree, $depth);
    
    my $currentLevel = 0;
    my $nodesInThisLevel = 1;
    for(my $i=0; $i < scalar @tree; ++$i)
    {
        printf("%3d  ",$tree[$i]);
      
        --$nodesInThisLevel;
        
        if ( $nodesInThisLevel == 0 )
        {
            $currentLevel++;
            $nodesInThisLevel = 2**$currentLevel;
            printf("\n");
        }
    }
    
}

printTree(@vals);