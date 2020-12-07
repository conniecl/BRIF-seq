# BRIF-MAP
Analysis tool for bisulfite-converted randomly integrated fragments sequencing method


## Requirements
- bismark
- samtools
- bowtie2

Installation
To run the BRIF-MAP, run the following commands from your teminal:
```
git clone git@github.com:conniecl/BRIF-seq.git
```
## Usage
Change the input file, bin path, reads length, thread in r1.sh and r2.sh, and run:
```
sh r1.sh
sh r2.sh
```

After finished the above process, then run the following commands to gain the finally bam file and methylation rate(change the input file as yours):
```
samtools merge CF3.bam reads1/CF3_S2_L002_R1_001_val_1.fq.final.bam reads2/CF3_S2_L002_R2_001_val_2.fq.final.bam
deduplicate_bismark -s CF3.bam --bam
samtools sort CF3.deduplicated.bam CF3.deduplicated.sort
bismark_methylation_extractor CF3.deduplicated.sort.bam --cytosine_report --genome_folder /public/home/lchen/v3.29_index/b2_index/ --CX
```
