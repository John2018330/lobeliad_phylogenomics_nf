#!/usr/bin/env nextflow 

/*
 * Nextflow file to pipeline phylogenomics workflow. Read README.md for 
 * more details
 */


/*
 * Required pipeline inputs and log introduction
 */
params.reads = "$projectDir/data/luk_006_11_{R1,R2}.fastq"
params.adapter = "$projectDir/TruSeq3-PE.fa"
//params.baits_file = ""
params.outdir = "$projectDir/results"


log.info """\
    ==========================
    - PHYLOGENOMICS WORKFLOW -
    ==========================
    reads        : ${params.reads}
    outdir       : ${params.outdir}
    """
    .stripIndent()


/* 
 * STEP 1.0: TRIMMOMATIC 
 * Takes paired raw read files as input, runs trimmomatic on them, and 
 * outputs four files. Each of the original raw read files are quality 
 * filtered and then split into two files, one where reads have their pair
 * found (*_paired.fastq) and one where reads lack their pair
 * (*_unpaired.fastq). HybPiper requires the unpaired reads to be 
 * concatenated into one file. 
 */
process TRIMMOMATIC {
    publishDir "${params.outdir}/trimmed"

    input:
    tuple val(name), path(reads)
    
    output:
    tuple val(name), path(r1p), path(r2p), path(ru)

    script: 
    r1p = "${name}_R1_paired.fastq"
    r1u = "${name}_R1_unpaired.fastq"
    r2p = "${name}_R2_paired.fastq"
    r2u = "${name}_R2_unpaired.fastq"
    ru  = "${name}_unpaired.fastq"
    
    """  
    trimmomatic PE -phred33 \
    ${reads[0]} ${reads[1]} \
    $r1p $r1u $r2p $r2u \
    ILLUMINACLIP:$params.adapter:2:30:10 \
    LEADING:3 TRAILING:3 \
    SLIDINGWINDOW:5:20 MINLEN:36

    cat $r1u $r2u > $ru
    rm $r1u $r2u
    """
}



/* 
 * STEP 1.1 Run FASTQC 
 * Run FastQC on all samples to generate report on trimmomatic outputs for quality control
 */
process CAT_UNPAIRED {
    publishDir "${params.outdir}/fast_multi_qc/fastqc"

    input:
    // I think this should be flattened and just fed as one file at a time 
    tuple val(name), path(r1p), path(r2p), path(r2u)

    output:
    path "${name}"
    
    script:
    """
    
    """


}



/*
 * DEFINE WORKFLOW
 */
workflow {
    //reads_pairs_ch = Channel.fromFilePairs(params.reads, checkIfExists: true)
    
    // Input channel of read pairs
    Channel 
        .fromFilePairs(params.reads, checkIfExists: true)
        .set { ch_read_pairs }


    // Run trimmomatic on read_pairs_ch
    // trimmed_ch = TRIMMOMATIC(reads_pairs_ch)
    TRIMMOMATIC(
        ch_read_pairs
    )
    .set { ch_trimmed_reads }

}







