#begin that pipeline, install bismark, and use bismark_genome_preparation for index preparation
#pay attention: --ambiguous only use for static, remove in final version and the temp file , rm command
begin_time=$(date "+%s")  #record the program start time
mkdir reads1
mythread=5  #change the thread each bowtie2 used
inputdir=. #input dictionary
input=CF3_S2_L002_R1_001_val_1.fq  #input file, change as your input, fastq format
index=/public/home/lchen/v3.29_index/b2_index/ #change to your bismark index
outputdir=./reads1 #output dictionary
longest=130 #longest reads length in the input fastq file minus ${stepsize}
stepsize=10
binpath=/public/home/lchen/sc_new/new_test/bin
flag=120 #longest reads length in the input fastq file minus 20
bismark --bowtie2 -p ${mythread} --non_directional --score_min L,0,-0.3 --ambiguous -un -N 1 ${index} ${inputdir}/${input} -o ${outputdir} #first map for origin reads
#unmap reads used for down stream analysis
gunzip ${outputdir}/${input}_unmapped_reads.fq.gz
mv ${outputdir}/${input}_unmapped_reads.fq ${outputdir}/${input}.forsplit
perl $binpath/first_split.pl ${outputdir}/${input}.forsplit
perl $binpath/first_endsplit.pl ${outputdir}/${input}.forsplit
bismark --bowtie2 -p ${mythread} --non_directional --score_min L,0,-0.3 --ambiguous -N 1 ${index} ${outputdir}/${input}.forsplit.first50 -o ${outputdir} #donot delete --ambiguous
bismark --bowtie2 -p ${mythread} --non_directional --score_min L,0,-0.3 --ambiguous -N 1 ${index} ${outputdir}/${input}.forsplit.firstend50 -o ${outputdir} #donot delete --ambiguous
perl $binpath/map_reads.pl ${outputdir}/${input}.forsplit.first50
perl $binpath/map_endreads.pl ${outputdir}/${input}.forsplit.first 50
perl $binpath/gain_50map.pl ${outputdir}/${input}.forsplit 50 ${longest}
#rm ${outputdir}/${input}.forsplit.first50_bismark_bt2_SE_report.txt ${outputdir}/${input}.forsplit.first50_bismark_bt2.bam ${outputdir}/${input}.forsplit.first50_ambiguous_reads.fq ${outputdir}/${input}.forsplit.first50_bismark_bt2.list ${outputdir}/${input}.forsplit.first50 ${outputdir}/${input}.forsplit.first.less50
bismark --bowtie2 -p ${mythread} --non_directional --score_min L,0,-0.3 --ambiguous -un -N 1 --ambiguous ${index} ${outputdir}/${input}.forsplit.${longest} -o ${outputdir}
for((i=${longest};i>50;i=i-${stepsize}));
do
j=`expr $i - ${stepsize}`
perl $binpath/second_splite.pl ${outputdir}/${input}.forsplit $i $j #135 ${longest}
bismark --bowtie2 -p ${mythread} --non_directional --score_min L,0,-0.3 --ambiguous -un -N 1 --ambiguous ${index} ${outputdir}/${input}.forsplit.$j -o ${outputdir}
#rm ${outputdir}/${input}.forsplit.less$i ${outputdir}/${input}.forsplit.${i}_unmapped_reads.fq ${outputdir}/${input}.forsplit.$i
done

perl $binpath/endmap.pl ${outputdir}/${input}.forsplit ${flag} ${stepsize} $j #$longest-${stepsize} $stepsize
#rm ${outputdir}/${input}.forsplit.50map ${outputdir}/${input}.forsplit.50 ${outputdir}/${input}.forsplit.50_unmapped_reads.fq.gz ${outputdir}/${input}.forsplit.less50
bismark --bowtie2 -p ${mythread} --non_directional --score_min L,0,-0.3 -N 1 ${index} ${outputdir}/${input}.forsplit.mapend.fq -o ${outputdir}

perl $binpath/gain_50endmap.pl ${outputdir}/${input}.forsplit 50 ${longest}
#rm ${outputdir}/${input}.forsplit.firstend50_bismark_bt2_SE_report.txt ${outputdir}/${input}.forsplit.firstend50_bismark_bt2.bam ${outputdir}/${input}.forsplit.firstend50_ambiguous_reads.fq ${outputdir}/${input}.forsplit.firstend50_bismark_bt2.list ${outputdir}/${input}.forsplit.firstend50
bismark --bowtie2 -p ${mythread} --non_directional --score_min L,0,-0.3 --ambiguous -un -N 1 ${index} ${outputdir}/${input}.forsplit.end${longest} -o ${outputdir}
for((i=${longest};i>50;i=i-${stepsize}));
do
j=`expr $i - ${stepsize}`
perl $binpath/second_splite_2.pl ${outputdir}/${input}.forsplit $i $j 
bismark --bowtie2 -p ${mythread} --non_directional --score_min L,0,-0.3 --ambiguous -un -N 1 ${index} ${outputdir}/${input}.forsplit.end$j -o ${outputdir}
#rm ${outputdir}/${input}.forsplit.lessend$i ${outputdir}/${input}.forsplit.end${i}_unmapped_reads.fq ${outputdir}/${input}.forsplit.end$i
done

perl $binpath/startmap.pl ${outputdir}/${input}.forsplit ${flag} ${stepsize} $j #$longest-${stepsize} $stepsize
#rm ${outputdir}/${input}.forsplit.50map ${outputdir}/${input}.forsplit.50 ${outputdir}/${input}.forsplit.50_unmapped_reads.fq.gz ${outputdir}/${input}.forsplit.less50
bismark --bowtie2 -p ${mythread} --non_directional --score_min L,0,-0.3 -N 1 ${index} ${outputdir}/${input}.forsplit.mapfirst.fq -o ${outputdir}

for((i=${longest};i>=${j};i=i-${stepsize}));
do
gunzip ${outputdir}/${input}.forsplit.${i}_ambiguous_reads.fq.gz
gunzip ${outputdir}/${input}.forsplit.end${i}_ambiguous_reads.fq.gz
done

perl $binpath/ambi.pl ${outputdir}/${input}.forsplit ${longest} ${stepsize} ${j}
perl $binpath/ambi_2.pl ${outputdir}/${input}.forsplit ${longest} ${stepsize} ${j}

for((i=${longest};i>=${j};i=i-${stepsize}));
do
bismark --bowtie2 -p ${mythread} --non_directional --score_min L,0,-0.3 --ambiguous -un -N 1 ${index} ${outputdir}/${input}.forsplit.${i}_ambinew.fq -o ${outputdir}
bismark --bowtie2 -p ${mythread} --non_directional --score_min L,0,-0.3 --ambiguous -un -N 1 ${index} ${outputdir}/${input}.forsplit.end${i}_ambinew.fq -o ${outputdir}
done

for((i=${longest};i>=${j};i=i-${stepsize}));
do
a=${a}`echo -n "${outputdir}/${input}.forsplit.${i}_bismark_bt2.bam " `
a=${a}`echo -n "${outputdir}/${input}.forsplit.end${i}_bismark_bt2.bam " `
a=${a}`echo -n "${outputdir}/${input}.forsplit.${i}_ambinew.fq_bismark_bt2.bam " `
a=${a}`echo -n "${outputdir}/${input}.forsplit.end${i}_ambinew.fq_bismark_bt2.bam " `
done
echo "${a}"
samtools merge -f ${outputdir}/${input}.final.bam ${outputdir}/${input}_bismark_bt2.bam ${outputdir}/${input}.forsplit.mapend.fq_bismark_bt2.bam ${outputdir}/${input}.forsplit.mapfirst.fq_bismark_bt2.bam $a

#rm ${outputdir}/${input}.forsplit.mapend.fq_bismark_bt2.bam ${outputdir}/${input}.forsplit.first.less50_bismark_bt2.bam $a ${outputdir}/${input}.forsplit.mapend.fq *.txt
#deduplicate_bismark -s ${outputdir}/${input}.forsplit.final.bam --bam
#samtools sort ${outputdir}/${input}.forsplit.final.deduplicated.bam ${outputdir}/${input}.forsplit.final.deduplicated.sort
#samtools depth ${outputdir}/${input}.forsplit.final.deduplicated.sort.bam >${outputdir}/${input}.forsplit.final.deduplicated.sort.depth
#bismark_methylation_extractor ${outputdir}/${input}.forsplit.final.deduplicated.sort.bam --bedGraph

end_time=$(date "+%s") #record the program end time
#use the humanized way to display the running time
time_distance=$(($end_time - $begin_time));  
hour_distance=$(expr ${time_distance} / 3600)    
hour_remainder=$(expr ${time_distance} % 3600)    
min_distance=$(expr ${hour_remainder} / 60)    
min_remainder=$(expr ${hour_remainder} % 60)   
echo -e "spend time is ${hour_distance}:${min_distance}:${min_remainder}" >${outputdir}/time.log #output the program running time to time.log
