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
    bait file    : ${params.target_file}
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
 * Outputs in folder called ___
 */
process TRIMMOMATIC {
    label 'process_low'

    when: params.run_trimmomatic

    input:
    tuple val(name), path(reads)
    
    output:
    tuple val(name), path(r1p), path(r2p), path(ru)

    script: 
    def args = task.ext.args
    r1p = "${name}_R1_paired.fastq"
    r1u = "${name}_R1_unpaired.fastq"
    r2p = "${name}_R2_paired.fastq"
    r2u = "${name}_R2_unpaired.fastq"
    ru  = "${name}_unpaired.fastq"
    
    """  
    trimmomatic PE \
        -threads $task.cpus \
        ${reads[0]} ${reads[1]} \
        $r1p $r1u $r2p $r2u \
        ILLUMINACLIP:$params.trimmomatic_adapter:2:30:10 \
        $args 

    cat $r1u $r2u > $ru
    rm $r1u $r2u
    """
}



/* 
 * STEP 1.1 Run FASTQC 
 * Run FastQC on all samples to generate report on trimmomatic outputs for quality control
 * Outputs in folder called ___
 */

process FASTQC{
    label 'process_low'
    
    when: run_qc_reports

    input:
    tuple val(name), path(r1p), path(r2p), path(ru)

    output:
    path("*.html"), emit: html
    path("*.zip"),  emit: zip
    
    script:
    """
    fastqc ${r1p} ${r2p} ${ru}
    """
}


/* 
 * Step 1.2 Run multiQC
 * Collects the FastQC output from each sample and put them into a single report
 * Outputs in ____ folder
 */

process MULTIQC{
    label 'process_low'

    when: run_qc_reports

    input:
    path '*'

    output:
    path 'multiqc_report.html'

    script:
    """
    multiqc .
    """
}


process ASSEMBLE {
    label 'process_high'

    input:
    tuple val(name), path(r1p), path(r2p), path(ru)
    path(target_file)
     
    output:
    path(name)

    script:
    def args = task.ext.args
    """
    hybpiper assemble -t_dna $target_file -r $r1p $r2p --unpaired $ru --prefix $name --cpu $task.cpus $args
    """
}


/* 
 * DEFINE WORKFLOW
 */
workflow {
    /*
     * Input channel of read pairs
     */
    Channel 
        .fromFilePairs("${params.reads}/*_{R1,R2}.*", checkIfExists: true)
        .set { ch_read_pairs }

    //Channel
    //    .of(params.target_file)
    //    .set { ch_target_file }

        
    /*
     * Run trimmomatic on read_pairs_ch
     */
    TRIMMOMATIC(
        ch_read_pairs
    )
    .set { ch_trimmed_reads }


    /*
     * Run FastQC and then MultiQC on all trimmomatic outputs
     */
    FASTQC(
        ch_trimmed_reads
    )
    .set { ch_fastqc }

    MULTIQC(
        ch_fastqc.zip.collect()
    )


    /*
     * Use HybPiper to assemble raw reads to target file
     */
    ASSEMBLE(
        //ch_trimmed_reads.concat(ch_target_file)
        ch_trimmed_reads, params.target_file
    ).set { ch_assemblies }
    //ch_trimmed_reads.concat(ch_target_file).view()
}


