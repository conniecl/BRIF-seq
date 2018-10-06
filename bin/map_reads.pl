#!usr/bin/perl -w
open AM,"<$ARGV[0]_ambiguous_reads.fq" or die "$!";
open OUT,">$ARGV[0]_bismark_bt2.list" or die "$!";
while(<AM>)
{
    if($.%4==1)
    {
        s/^@//g;
        print OUT "$_";
    }
}
close AM;
open UN,"samtools view $ARGV[0]_bismark_bt2.bam|" or die "$!";
while(<UN>)
{
    @tmp=split("\t",$_,2);
    print OUT "$tmp[0]\n";
}
close UN;
close OUT;