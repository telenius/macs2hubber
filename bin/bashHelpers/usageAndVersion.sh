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

version(){
    nameOfScript="VERSION 01 "
    pipesiteAddress="http://userweb.molbiol.ox.ac.uk/public/telenius/macshubber/index.html"
    
    versionInfo="\n${nameOfScript} macs2hubber.sh\nHelp and updates (bug fixes etc) listed in : ${pipesiteAddress}\n"
    echo -e "${versionInfo}" > versionInfo.txt
    echo "<p>${nameOfScript} macsHubber.sh </p>" > versionInfoHTML.txt
    echo "<p> User help and Updates (bug fixes etc) in : <a href=\"${pipesiteAddress}\" >${pipesiteAddress}</a></p>" >> versionInfoHTML.txt
}

usage(){
    
    version
    echo -e ${versionInfo}
    rm -f versionInfoHTML.txt
    rm -f versionInfo.txt

echo "----------------------------------------------------------------------------------"
echo "To run your peak call 'just like you would run MACS2' (with or without input)."
echo "Auto-generates a data hub, along with MIG-loadable GFF file."
echo "----------------------------------------------------------------------------------"
echo "Give your hub-location-to-be in parameter file PIPE_hubbing.txt ( or PIPE_hubbingSymbolic.txt )"
echo
echo "Make it like this :"
echo "http://sara.molbiol.ox.ac.uk/public/telenius/macshubber/PIPEhubbing.pdf"
echo
echo "An existing hub is allowed."
echo 
echo "----------------------------------------------------------------------------------"
echo "Tool accepts any MACS2 input parameters"
echo
echo "Full list of parameters :"
echo
echo "module load macs2"
echo "macs2 callpeak -h "
echo
echo "----------------------------------------------------------------------------------"
echo "Non-macs parameters :"
echo
echo "--macsVersion macs2/2.0.10 (check with command 'module avail' which versions are available)"
echo "(by default loads 'module load macs2' - i.e. system default version)"
echo "--hubGenome ( visualisation genome - see below)"
echo
echo "----------------------------------------------------------------------------------"
echo "Default behavior :"
echo
echo "macs2 callpeaks --SPRM --bdg --call-summits --verbose 100"
echo 
echo "If you don't want peak summits, call with flag --no-summits , to get behavior :"
echo "macs2 callpeaks --SPRM --bdg --verbose 100"
echo
echo "----------------------------------------------------------------------------------"
echo "Run via queue system, like this :"
echo "qsub -cwd -o qsub.out -e qsub.err -N macsHubber < ./run.sh"
echo
echo "Run the script in an empty folder"
echo
echo "Minimum run.sh :"
echo "$0 -g hs -f BAMPE --hubGenome mm9"
echo
echo "-g is the MACS2 genome name (mm hs dm ce)"
echo "-f is the input file type (BAMPE for paired end samples, BAM for single end samples)."
echo "--hubGenome is the visualisation genome (mm9 mm10 hg18 hg19 hg38 danRer7 danRer10 galGal4 dm3)"
echo
echo "----------------------------------------------------------------------------------"
echo "Running many samples (with same macs2 run parameters) can be done "
echo "with parameter files PIPE_sampleBamPaths.txt and PIPE_controlBamPaths.txt."
echo
echo "All samples will be added to the same UCSC hub."
echo
echo "Example :"
echo
echo "PIPE_sampleBamPaths.txt"
echo
echo "DNase1   /path/to/file.bam,/path/to/file2.bam"
echo "RAD21    /path/to/file.bam,/path/to/file2.bam"
echo
echo "PIPE_controlBamPaths.txt ( if you have control bams available )"
echo
echo "DNaseControl   /path/to/file.bam,/path/to/file2.bam"
echo "RAD21control    /path/to/file.bam,/path/to/file2.bam"
echo

exit 0

}



