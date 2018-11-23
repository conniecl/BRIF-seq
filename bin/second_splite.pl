#!usr/bin/perl -w
open LI1,"<$ARGV[0].$ARGV[1]_ambiguous_reads.fq" or die "$!";
%hash=();
while(<LI1>)
{
    if($.%4==1)
    {
        chomp;
        $hash{$_}=1;
    }
}
close LI1;
open LI2,"samtools view $ARGV[0].$ARGV[1]_bismark_bt2.bam|" or die "$!";
while(<LI2>)
{
    chomp;
    @tmp=split("\t",$_,2);
    $id=join("","@",$tmp[0]);
    $hash{$id}=1;
}
close LI2;
open FA,"<$ARGV[0].50map" or die "$!";
open OUT,">$ARGV[0].$ARGV[2]" or die "$!";
while(<FA>)
{
    chomp;
    $line1=$_;
    $line2=<FA>;
    chomp($line2);
    $line3=<FA>;
    $line4=<FA>;
    $len=length($line2);
    if(!exists $hash{$line1} && $len>=$ARGV[2])
    {
        $seq=substr($line2,0,$ARGV[2]);
        $qual=substr($line4,0,$ARGV[2]);
        print OUT "$line1\n$seq\n$line3$qual\n";
    }
}
close FA;
close OUT;
