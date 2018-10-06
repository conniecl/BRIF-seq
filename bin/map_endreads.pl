#!usr/bin/perl -w
open LI,"<$ARGV[0]$ARGV[1]_bismark_bt2.list" or die "$!";
%hash=();
while(<LI>)
{
    chomp;
    $hash{$_}=1;
}
close LI;
open AM,"<$ARGV[0]end$ARGV[1]_ambiguous_reads.fq" or die "$!";
open OUT,">$ARGV[0]end$ARGV[1]_bismark_bt2.list" or die "$!";
while(<AM>)
{
    if($.%4==1)
    {
        s/^@//g;
        chomp;
        if(!exists $hash{$_})
        {
            print OUT "$_\n";
        }
    }
}
close AM;
open UN,"samtools view $ARGV[0]end$ARGV[1]_bismark_bt2.bam|" or die "$!";
while(<UN>)
{
    @tmp=split("\t",$_,2);
    if(!exists $hash{$tmp[0]})
    {
        print OUT "$tmp[0]\n";
    }
}
close UN;
close OUT;