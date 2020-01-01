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

testSampleNameCharacters(){
    
    # PIPE_sampleBamPaths.txt
    # PIPE_controlBamPaths.txt
    # BAMtype="sample"
    # BAMtype="control"
    
    bamsFine=1
    printThis="Checking ${BAMtype} BAM names .."
    printToLogFile

    cut -f 1 PIPE_${BAMtype}BamPaths.txt | sed 's/[a-zA-Z0-9_]*//g' | sed 's/t1-data//g' | sed 's/\s\s*/\t/' | grep -v "^\s*$" > TESTERfile.txt
    cut -f 1 PIPE_${BAMtype}BamPaths.txt | sed 's/[a-zA-Z0-9_]*//g' | sed 's/t1-data//g' | sed 's/\s\s*/\t/' | grep -v "^\s*$" | cat -A | sed 's/\^I//g' | sed 's/\$//' | tr "\n" " " | sed 's/\s\s*//' > TESTERfileAll.txt
    
    if [ -s TESTERfileAll.txt ]
    then
        echo >> FOLDERNAMES.err ;
        echo "Forbidden characters (other than a-z A-Z 0-9 _ ) in file PIPE_${BAMtype}BamPaths.txt :" >> FOLDERNAMES.err ;
        cat TESTERfile.txt >> FOLDERNAMES.err ;
        echo "Same printout with also WHITESPACE characters (check your line endings etc) :" >> FOLDERNAMES.err ;
        echo "  ^I = tab , $ = line ending ( if you have anything else weird - get rid of it ) :" >> FOLDERNAMES.err ;
        cat -A TESTERfile.txt >> FOLDERNAMES.err ;
        bamsFine=0;
    fi   

    rm -f TESTER*
}

bamExistenceParamFile(){
    # PIPE_sampleBamPaths.txt
    # PIPE_controlBamPaths.txt
    # BAMtype="sample"
    # BAMtype="control"
    
    bamsFine=1
    printThis="Checking ${BAMtype} bam file paths .."
    printToLogFile
        
    for file in $( cut -f 2 PIPE_${BAMtype}BamPaths.txt | tr ',' ' ' )
    do
        echo $file
        testedFile=$file
        doInputBamTesting
    done
    # Above sets
    # bamsFine=0;
    # If the file is not there or not readable.
    
    
}

bamExistence(){
    # BAMtype="sample"
    # BAMtype="control"
    
    macsflag="UNDEFINED"
    if [ "${BAMtype}" == "sample" ]; then
        macsflag='-t'
    fi
    if [ "${BAMtype}" == "control" ]; then
        macsflag='-c'
    fi
    
    bamsFine=1
    printThis="Checking ${BAMtype} bam file paths .."
    printToLogFile
    
    macsParam
    macsParamListFromValue
    # sets macslist array
    
    for f in $( seq 0 $((${#macslist[@]}-1)) )
    do
        echo ${macslist[$f]}
        testedFile=${macslist[$f]}
        doInputBamTesting
    done
    # Above sets
    # bamsFine=0;
    # If the file is not there or not readable.  
    
}

doTempFileTesting(){
    
    # NEEDS THIS TO BE SET BEFORE CALL :
    # testedFile=""    
    
    if [ ! -r "${testedFile}" ] || [ ! -e "${testedFile}" ] || [ ! -f "${testedFile}" ] || [ ! -s "${testedFile}" ]; then
      echo "Temporary file not found or empty file : ${testedFile}" >&2
      echo "EXITING!!" >&2
      exit 1
    fi
}

doTempFileInfo(){
    
    # NEEDS THIS TO BE SET BEFORE CALL :
    # testedFile=""    
    
    if [ ! -r "${testedFile}" ] || [ ! -e "${testedFile}" ] || [ ! -f "${testedFile}" ] || [ ! -s "${testedFile}" ]; then
      echo "Temporary file not found or empty file : ${testedFile}" >&2
      echo "Continuing, but may create some NONSENSE data.." >&2
      #echo "EXITING!!" >&2
      #exit 1
    fi
}

doTempFileFYI(){
    
    # NEEDS THIS TO BE SET BEFORE CALL :
    # testedFile=""    
    
    if [ ! -r "${testedFile}" ] || [ ! -e "${testedFile}" ] || [ ! -f "${testedFile}" ] || [ ! -s "${testedFile}" ]; then
      echo "Probably harmless : file not found or empty file : ${testedFile}" >&2
      
      #echo "EXITING!!" >&2
      #exit 1
    fi
}

doInputBamTesting(){
    
    # NEEDS THIS TO BE SET BEFORE CALL :
    # testedFile=""
    # BAMtype="sample"
    # BAMtype="control"
    
    if [ ! -r "${testedFile}" ] || [ ! -e "${testedFile}" ] || [ ! -f "${testedFile}" ]  || [ ! -s "${testedFile}" ]; then
      echo "Input BAM file not found or empty file or no reading permissions : ${testedFile}" >&2
      bamsFine=0;
    fi
}
