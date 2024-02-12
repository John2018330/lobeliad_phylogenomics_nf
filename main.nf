#!/usr/bin/env nextflow 

/*
 * Nextflow file to pipeline phylogenomics workflow. Read README.md for 
 * more details
 */


/*
 * Log introduction
 */
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
    label 'process_low'

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
    trimmomatic PE \
        -threads $task.cpus \
        -phred33 \
        ${reads[0]} ${reads[1]} \
        $r1p $r1u $r2p $r2u \
        ILLUMINACLIP:$params.trimmomatic_adapter:2:30:10 \
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

process FASTQC{
    label 'process_low'

    input:
    path(fastq)

    output:
    path("*.html"), emit: html
    path("*.zip"),  emit: zip
    
    script:
    """
    
    """


}



/*
 * DEFINE WORKFLOW
 */
workflow {
    //
    // Input channel of read pairs
    //
    Channel 
        .fromFilePairs("${params.reads}/*_{R1,R2}.*", checkIfExists: true)
        .set { ch_read_pairs }


    //
    // Run trimmomatic on read_pairs_ch
    //
    TRIMMOMATIC(
        ch_read_pairs
    )
    .set { ch_trimmed_reads }


    // Run FastQC on all trimmomatic outputs
    //ch_trimmed_reads.flatten().view()


}







