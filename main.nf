#!/usr/bin/env nextflow 

/*
 * Nextflow file to pipeline phylogenomics workflow. Read README.md for 
 * more details
 */


/*
 * Required pipeline inputs and log introduction
 */
params.reads = ""
params.baits_file = ""
params.outdir = "results"

log.info """\
    ==========================
    - PHYLOGENOMICS WORKFLOW -
    ==========================
    """
    .stripIndent()


/* 
 * STEP 1.0: TRIMMOMATIC 
 * Takes paired raw read files as input, runs trimmomatic on them, and 
 * outputs four files. Each of the original raw read files are quality 
 * filtered and then split into two files, one where reads have their pair
 * found (*_paired.fastq) and one where reads lack their pair
 * (*_unpaired.fastq).  
 */
process TRIMMOMATIC {
    publishDir ${params.outdir} + "trimmomatic"
    

    input:
    tuple val(name), path(reads)
    
    output:
    path "" 

    script:
    """
    
    """
}



/* 
 * STEP 1.1: COMBINED UNPAIRED FILES
 * HybPiper can utilize unpaired reads but requires them to be combined
 * into one file.
 */


/*
 * DEFINE WORKFLOW
 */
workflow {
    //reads_pairs_ch = Channel.fromFilePairs(params.reads, checkIfExists: true)
    println ${params.outdir} + "trimmomatic"
}
}






