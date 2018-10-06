#!usr/bin/perl -w
open IN,"<$ARGV[0]" or die "$!";
open OUT,">$ARGV[0].firstend50" or die "$!";
while(<IN>)
{
    chomp;
    $line2=<IN>;
    $line3=<IN>;
    $line4=<IN>;
    chomp($line2);
    chomp($line4);
    $len=length($line2);
    if($len>=50)
    {
        $seq=substr($line2,$len-50,50);
        $qual=substr($line4,$len-50,50);
        print OUT "$_\n$seq\n$line3$qual\n";
    }
}
close IN;
close OUT;