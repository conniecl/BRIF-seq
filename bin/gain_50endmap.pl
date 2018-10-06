#!usr/bin/perl -w
open LI1,"<$ARGV[0].firstend$ARGV[1]_bismark_bt2.list" or die "$!";
%hash=();
while(<LI1>)
{
    chomp;
    $id=join("","@",$_);
    $hash{$id}=1;
}
close LI1;
open FA,"<$ARGV[0]" or die "$!";
open OUT,">$ARGV[0].end$ARGV[2]" or die "$!";
open OUT1,">$ARGV[0].end$ARGV[1]map" or die "$!";
while(<FA>)
{
    chomp;
    $line1=$_;
    $line2=<FA>;
    chomp($line2);
    $line3=<FA>;
    $line4=<FA>;
    chomp($line4);
    $len=length($line2);
    if($len>=$ARGV[2] && exists $hash{$line1})
    {
        $seq=substr($line2,$len-$ARGV[2],$ARGV[2]);
        $qual=substr($line4,$len-$ARGV[2],$ARGV[2]);
        print OUT "$line1\n$seq\n$line3$qual\n";
    }
    if(exists $hash{$line1})
    {
	print OUT1 "$line1\n$line2\n$line3$line4\n";
    }
}
close FA;
close OUT;
close OUT1;