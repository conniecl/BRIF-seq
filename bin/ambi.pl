#!usr/bin/perl -w
open FA,"<$ARGV[0].50map" or die "$!";
while(<FA>)
{
    if($_=~/^@/)
    {
        $id=$_;
    }
    else
    {
        $hash{$id}.=$_;
    }
}
close FA;
for($i=$ARGV[1];$i>=$ARGV[3];$i-=$ARGV[2])
{
    open IN,"<$ARGV[0].${i}_ambiguous_reads.fq" or die "$!";
    open OUT,">$ARGV[0].${i}_ambinew.fq" or die "$!";
    while(<IN>)
    {
        $line1=$_;
        if($line1=~/^@/)
        {
            @array=split("\n",$hash{$line1});
            $len=length($array[0]);
            $flag=$i+5;
            if($len>=$flag)
            {
                $seq=substr($array[0],0,$flag);
                $qual=substr($array[2],0,$flag);
                print OUT "$line1$seq\n$array[1]\n$qual\n";
            }
        }
    }
    close IN;
    close OUT;
}
