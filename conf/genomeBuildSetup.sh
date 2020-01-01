#!/bin/bash

##########################################################################
# Copyright 2017, Jelena Telenius (jelena.telenius@imm.ox.ac.uk)         #
#                                                                        #
# This file is part of macs2hubber .                                      #
#                                                                        #
# macs2hubber is free software: you can redistribute it and/or modify     #
# it under the terms of the MIT license.
#
#
#                                                                        #
# macs2hubber is distributed in the hope that it will be useful,          #
# but WITHOUT ANY WARRANTY; without even the implied warranty of         #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the          #
# MIT license for more details.
#                                                                        #
# You should have received a copy of the MIT license
# along with macs2hubber.  
##########################################################################

setGenomeLocations(){

# #############################################################################

# This is the CONFIGURATION FILE to set up your BOWTIE GENOME INDICES ( conf/genomeBuildSetup.sh )

# Fill the locations of :

# - ucsc chromosome size files (genomes mm9,mm10,hg18,hg19,hg38,danRer7,danRer10,galGal4,dm3 already supported)

# As given in below examples

# #############################################################################
# SUPPORTED GENOMES 
# #############################################################################

# Add and remove genomes via this list.
# If user tries to use another genome (not listed here), the run is aborted with "genome not supported" message.

supportedGenomes[0]="mm9"
supportedGenomes[1]="mm10"
supportedGenomes[2]="hg18"
supportedGenomes[3]="hg19"
supportedGenomes[4]="hg38"
supportedGenomes[5]="danRer7"
supportedGenomes[6]="danRer10"
supportedGenomes[7]="galGal4"
supportedGenomes[8]="dm3"

# The above genomes should have :
# 3) UCSC genome sizes

# Fill these below !


# #############################################################################
# UCSC GENOME SIZES
# #############################################################################

# The UCSC genome sizes, for ucsctools .
# By default these are located in the 'conf/UCSCgenomeSizes' folder (relative to location of NGseqBasic.sh main script) .
# All these are already there - they come with the NGseqBasic codes.

# Change the files / paths below, if you want to use your own versions of these files. 

# These can be fetched with ucsctools :
# module load ucsctools
# fetchChromSizes mm9 > mm9.chrom.sizes

UCSC[0]="${confFolder}/UCSCgenomeSizes/mm9.chrom.sizes"
UCSC[1]="${confFolder}/UCSCgenomeSizes/mm10.chrom.sizes"
UCSC[2]="${confFolder}/UCSCgenomeSizes/hg18.chrom.sizes"
UCSC[3]="${confFolder}/UCSCgenomeSizes/hg19.chrom.sizes"
UCSC[4]="${confFolder}/UCSCgenomeSizes/hg38.chrom.sizes"
UCSC[5]="${confFolder}/UCSCgenomeSizes/danRer7.chrom.sizes"
UCSC[6]="${confFolder}/UCSCgenomeSizes/danRer10.chrom.sizes"
UCSC[7]="${confFolder}/UCSCgenomeSizes/galGal4.chrom.sizes"
UCSC[8]="${confFolder}/UCSCgenomeSizes/dm3.chrom.sizes"

# The indices in the UCSC array refer to genome names in supportedGenomes array (top of page).

# Not all of them need to exist : only the ones you will be using.
# The pipeline checks that at least one index file exists, before proceeding with the analysis

# When adding new genomes : remember to update the "supportedGenomes" list above (top of this file) as well !


}

