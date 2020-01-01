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

doBigBedding(){
    
    # NEEDS THIS TO BE SET BEFORE CALL :
    # thisBEDfile=""
    # thisBEDtype='bed12+3'
    
    if [ -r "${thisBEDfile}" ] ; then
    if [ -s "${thisBEDfile}" ] ; then
    bigbedName=$(echo ${thisBEDfile} | sed 's/\..*//')

    bedToBigBed -type=${thisBEDtype} ${thisBEDfile} ${genomeBuild} "${bigbedName}.bb"
    
    else
    echo "File ${thisBEDfile} empty file, no bigbed generated !"  >&2
    fi
    else
    echo "File ${thisBEDfile} missing, no bigbed generated !"    >&2 
    fi
}

doBigWigging(){
    
    # NEEDS THIS TO BE SET BEFORE CALL :
    # thisBDGfile=""
    # DoRounding="" (0 or 1)
    
    if [ -r "${thisBDGfile}" ] ; then
    if [ -s "${thisBDGfile}" ] ; then
    bigwigName=$(echo ${thisBDGfile} | sed 's/\..*//')
    
    if [ "${DoRounding}" -eq 0 ]; then
    
    bedGraphToBigWig ${thisBDGfile} ${genomeBuild} "${bigwigName}.bw"
    
    #Temporary file to be bigwigged - the awk command here drops the resolution of the bigwig to be 2 digits..
    else
    
    #cut -f 4 ${thisBDGfile} | grep -Pv "^$" | awk '{printf("%.2f",$1);  printf("\n");}' > tempCol4.txt
    cut -f 4 ${thisBDGfile} | awk '{printf("%.2f",$1);  printf("\n");}' > tempCol4.txt
    
    #tail tempCol4.txt
    
    cut -f 1,2,3 ${thisBDGfile} | paste - tempCol4.txt > toBigWig.bdg
    rm -f tempCol4.txt
    
    #head toBigWig.bdg
    #tail toBigWig.bdg
    
    bedGraphToBigWig toBigWig.bdg ${genomeBuild} "${bigwigName}.bw"
    
    fi
    
    #ls -lhs| grep ${bigwigName} >&2
    
    else
    echo "File ${thisBDGfile} empty file, no bigwig generated !"  >&2
    fi
    else
    echo "File ${thisBDGfile} missing, no bigwig generated !"    >&2 
    fi
}

runMacsNoParamFile(){
    
# 1) MACS2 run

printThis="Starting run for ${samplename}"
printNewChapterToLogFile
date
printThis="Generated run folder  ${foldername} \n ( sample run dir full path : $( pwd ) )"
printToLogFile

# Restoring the parameter list START..
runParams=$( echo ${runParams} | sed 's/^PARAMETERS\s*//' )

printThis="Starting macs run with command : \n macs2 callpeak -n ${samplename} --outdir ${foldername} ${runParams} "
printToLogFile

printThis="You can follow the run progress in file :\n $( pwd )/${samplename}_macs.log "
printToLogFile

macs2 callpeak -n ${samplename} --outdir ${foldername} ${runParams} &> ${samplename}_macs.log

cat ${samplename}_macs.log | sed 's/^.*#/#/' | grep -v ^INFO  | grep -v ^DEBUG | grep -v '^\s*$' > ${samplename}_macs_short.log
cat ${samplename}_macs_short.log >&2

mv ${samplename}_macs.log ${foldername}/.
mv ${samplename}_macs_short.log ${foldername}/.

echo "Done!" >&2
    
    
}

runMacsParamFile(){
    
# 1) MACS2 run

printThis="Starting run for ${samplename}"
printNewChapterToLogFile
date
printThis="Generated run folder  ${foldername} \n ( sample run dir full path : $( pwd ) )"
printToLogFile

# Restoring the parameter list START..
runParams=$( echo ${runParams} | sed 's/^PARAMETERS\s*//' )

printThis="Starting macs run with command : \n macs2 callpeak -n ${samplename} --outdir ${foldername} ${runParams} "
printToLogFile

printThis="You can follow the run progress in file :\n $( pwd )/${samplename}_macs.log "
printToLogFile

macs2 callpeak -n ${samplename} ${runParams} &> ${samplename}_macs.log

cat ${samplename}_macs.log | sed 's/^.*#/#/' | grep -v ^INFO  | grep -v ^DEBUG | grep -v '^\s*$' > ${samplename}_macs_short.log
cat ${samplename}_macs_short.log >&2
echo "Done!" >&2
    
    
}

macs2runner(){
    
# 1) MACS2 run
# 2) Excel --> MIG
# 3) R --> PDF
# 4) Bedgraphs
# 5) Bigwigs
# 6) Hubbing

printThis="After-MACS2 analysis .. "
printNewChapterToLogFile


# 2) Excel --> MIG

if [ -s "${samplename}_peaks.xls" ]; then

printThis="Generating MIG-loadable gff file with biopivot (acknowledges Steve Taylor) "
printToLogFile

printThis="macs2gff3.pl ${samplename}_peaks.xls > ${samplename}_peaks.gff"
printToLogFile

macs2gff3.pl ${samplename}_peaks.xls > ${samplename}_peaks.gff

fi

# 3) R --> PDF

if [ -s "${samplename}_model.r" ]; then
    
printThis="Generating PDF figure from the single-ended data mapping model MACS2 generated .."
printToLogFile

printThis="R --vanilla --slave < ${samplename}_model.r"
printToLogFile

R --vanilla --slave < ${samplename}_model.r
    
fi

# Bedgraphs, bigwigs

printThis="Visualisation generation .. "
printNewChapterToLogFile


peakfile="UNDEFINED"
peaktype="narrow"
if [ -s "${samplename}_peaks.narrowPeak" ]; then
    peakfile="peaks.narrowPeak"
elif [ -s "${samplename}_peaks.broadPeak" ]; then
    # NAME_peaks.broadPeak is in BED6+3 format which is similar to narrowPeak file, except for missing the 10th column for annotating peak summits.
    peakfile="peaks.broadPeak"
    peaktype="broad"
else
    printThis="Cannot find ${samplename}_peaks.narrowPeak or ${samplename}_peaks.broadPeak output file !"
    printToLogFile
fi

# 4) Bedgraphs

if [ "${peakfile}" != "UNDEFINED" ]; then

printThis="Found ${peaktype}-peaks file (broad or narrow)"
printNewChapterToLogFile

printThis="Bedgraphs .."
printToLogFile

# So, we can just use the narrow peaks file to make these.

# We use summit coords in the fold files, if we can. If we can't, then wide peaks !
if [ "${peaktype}" == "narrow" ]; then
cut -f 1-2,10 ${samplename}_${peakfile} | awk '{print $1"\t"$2+$3"\t"$2+$3+1}' > TEMP_coords.txt
else
cut -f 1-3 ${samplename}_${peakfile} > TEMP_coords.txt    
fi

# cut -f 1-3,7 ${samplename}_${peakfile} | sort -k1,1 -k2,2n > ${samplename}_foldEnrichment.bdg
# cut -f 1-3,8 ${samplename}_${peakfile} | sort -k1,1 -k2,2n > ${samplename}_minusLog10pvalue.bdg
# cut -f 1-3,9 ${samplename}_${peakfile} | sort -k1,1 -k2,2n > ${samplename}_minusLog10qvalue.bdg

cut -f 7 ${samplename}_${peakfile} | paste TEMP_coords.txt - > ${samplename}_foldEnrichment.bdg
cut -f 8 ${samplename}_${peakfile} | paste TEMP_coords.txt - > ${samplename}_minusLog10pvalue.bdg
cut -f 9 ${samplename}_${peakfile} | paste TEMP_coords.txt - > ${samplename}_minusLog10qvalue.bdg

# And then we have the overlay graph made from these 2 :

# cut -f 1-3 ${samplename}_${peakfile} | awk '{print $0"\t1"}' | sort -k1,1 -k2,2n > ${samplename}_peakLocations.bdg
# cut -f 1-3 ${samplename}_${peakfile} | awk '{print $0"\t1"}' | sort -k1,1 -k2,2n > ${samplename}_summitLocations.bdg

cut -f 1-3 ${samplename}_${peakfile} | uniq | awk '{print $0"\t1"}' > ${samplename}_peakLocations.bdg
if [ "${peaktype}" == "narrow" ]; then
cut -f 1-3 TEMP_coords.txt                  | awk '{print $0"\t1"}' > ${samplename}_summitLocations.bdg
fi
rm -f TEMP_coords.txt

# And then we have the overlay graph made from these 2 (normalised to sample depth) :

# ${samplename}_control_lambda.bdg
# ${samplename}_treat_pileup.bdg

# 5) Bigwigs

printThis="Bigwigs .."
printToLogFile

DoRounding=1

thisBDGfile="${samplename}_foldEnrichment.bdg"
doBigWigging

thisBDGfile="${samplename}_minusLog10pvalue.bdg"
doBigWigging

thisBDGfile="${samplename}_minusLog10qvalue.bdg"
doBigWigging

DoRounding=0

thisBDGfile="${samplename}_peakLocations.bdg"
doBigWigging

thisBDGfile="${samplename}_summitLocations.bdg"
doBigWigging

# ${samplename}_control_lambda.bdg
# ${samplename}_treat_pileup.bdg

# cat ${samplename}_control_lambda.bdg | sort -k1,1 -k2,2n > ${samplename}_control_lambda.sorted.bdg
thisBDGfile="${samplename}_control_lambda.bdg"
# thisBDGfile="${samplename}_control_lambda.sorted.bdg"
doBigWigging
# rm -f ${samplename}_control_lambda.sorted.bdg

# cat ${samplename}_treat_pileup.bdg | sort -k1,1 -k2,2n > ${samplename}_treat_pileup.sorted.bdg
thisBDGfile="${samplename}_treat_pileup.bdg"
# thisBDGfile="${samplename}_treat_pileup.sorted.bdg"
doBigWigging
# rm -f ${samplename}_treat_pileup.sorted.bdg

if [ "${peaktype}" == "broad" ]; then

printThis="Bigbeds .."
printToLogFile

rm -f ${samplename}_gappedPeak.bed
cp ${samplename}_peaks.gappedPeak ${samplename}_gappedPeak.bed
thisBEDfile="${samplename}_gappedPeak.bed"
thisBEDtype='bed12+3'
doBigBedding
rm -f ${samplename}_gappedPeak.bed

fi

fi

# 6) Hubbing ..

if [ $(($( ls -1 | grep -c ".bw$" ))) -gt 0 ]; then

printThis="Creating / updating data hub .."
printToLogFile

echo ${longlabel} > TEMP_longlabel.txt
echo ${shortlabel} > TEMP_shortlabel.txt

printThis="${MainScriptsPath}/dataHubGenerator.sh -g "${HUBGENOME}" -n "${MagicNumber}" -p "${MainScriptsPath}" --symbolic "${SYMBOLIC}" --folder ${foldername} --sample ${samplename}"
printToLogFile

${MainScriptsPath}/dataHubGenerator.sh -g "${HUBGENOME}" -n "${MagicNumber}" -p "${MainScriptsPath}" --symbolic "${SYMBOLIC}" --folder ${foldername} --sample ${samplename}

rm -f TEMP_longlabel.txt TEMP_shortlabel.txt

else
    
echo "Data hub not generated (MACS2 did not give any output) - probably MACS2 crash ?" > hub_error.txt

echo
cat hub_error.txt    
echo

fi

}
