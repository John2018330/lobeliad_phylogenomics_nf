FROM mambaorg/micromamba

RUN \
    micromamba install -y -n base -c defaults -c bioconda -c conda-forge \
        trimmomatic=0.39 \
        fastqc=0.12.1 \
        hybpiper \
        trimal=1.4.1 \ 
        iqtree=2.2.6 \
        scipy=1.11.4 \
        multiqc=1.17 \
        typing_extensions=4.9.0 \
    && micromamba clean -a -y

