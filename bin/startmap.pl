#!usr/bin/perl -w
for($i=$ARGV[3];$i<=$ARGV[1];$i+=$ARGV[2])
{
    open IN,"samtools view $ARGV[0].end${i}_bismark_bt2.bam|" or die "$!";
    while(<IN>)
    {
        chomp;
        @tmp=split("\t",$_,2);
        $tmp[0]=join("","@",$tmp[0]);
        $hash{$tmp[0]}=$i;
    }
    close IN;
}
open FA,"<$ARGV[0].end50map" or die "$!";
open OUT,">$ARGV[0].mapfirst.fq" or die "$!";
while(<FA>)
{
    chomp;
    $line1=$_;
    $line2=<FA>;
    chomp($line2);
    $line3=<FA>;
    $line4=<FA>;
    chomp($line4);
    if(exists $hash{$line1})
    {
        $len=length($line2)-$hash{$line1};
        if($len>=20)
        {
            $seq=substr($line2,0,$len);
            $qual=substr($line4,0,$len);
            print OUT "$line1.e\n$seq\n$line3$qual\n";
        }
    }
}
close FA;
close OUT;