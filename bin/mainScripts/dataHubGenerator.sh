#!/bin/bash

# This is a trial to organize this script to 4 modules :
#
#########################################################
# MODULE 1) hub f1
#########################################################
# MODULE 2) hub f2 folder generation
#########################################################
# MODULE 3) hub f2 "other content" than bws - and their links to description.html
#########################################################
# MODULE 4) bigwigs - symbolic or not - and their links to tracks.txt 
#########################################################
# MODULE 5) listing the folders and hub address etc. 
#########################################################

doTrackExist(){
    # NEEDS THESE TO BE SET BEFORE CALL :
    #trackName=""
     
    if [ -s "${hubFolderDiskPath}/tracks.txt" ]; then
    
    echo -e "grep -c \"track ${trackName}\$\" ${hubFolderDiskPath}/tracks.txt" > temp.command
    chmod u=rwx temp.command
    trackExists=$(( $(./temp.command) ))
    rm -f temp.command
    
    else
    trackExists=0
    
    fi

}

writeBeginOfHtml(){
    
    echo "<!DOCTYPE HTML PUBLIC -//W3C//DTD HTML 4.01//EN" > begin.html
    echo "http://www.w3.org/TR/html4/strict.dtd" >> begin.html
    echo ">" >> begin.html
    echo " <html lang=en>" >> begin.html
    echo " <head>" >> begin.html
    echo " <title> ${hubName} data hub in ${genomeName} </title>" >> begin.html
    echo " </head>" >> begin.html
    echo " <body>" >> begin.html
    
}

doMultiWigParentPeaks(){
    
    # NEEDS THESE TO BE SET BEFORE CALL :
    #longLabel=""
    #trackName=""
    #overlayType=""
    #windowingFunction=""
    #visibility=""
    
    doTrackExist
    if [ "${trackExists}" -eq 0 ] ; then
 
    
    echo ""                                        >> TEMP_tracks.txt
    echo "#--------------------------------------" >> TEMP_tracks.txt
    echo ""                                        >> TEMP_tracks.txt
    
    echo "track ${trackName}"                      >> TEMP_tracks.txt
    echo "container multiWig"                      >> TEMP_tracks.txt
    echo "shortLabel ${trackName} ${shortlabel}"   >> TEMP_tracks.txt
    echo "longLabel ${longLabel} "                 >> TEMP_tracks.txt
    echo "type bigWig"                             >> TEMP_tracks.txt
    echo "visibility ${visibility}"                >> TEMP_tracks.txt
    #echo "aggregate transparentOverlay"           >> TEMP_tracks.txt
    #echo "aggregate solidOverlay"                 >> TEMP_tracks.txt
    echo "aggregate ${overlayType}"                >> TEMP_tracks.txt
    echo "showSubtrackColorOnUi on"                >> TEMP_tracks.txt
    #echo "windowingFunction maximum"              >> TEMP_tracks.txt
    #echo "windowingFunction mean"                 >> TEMP_tracks.txt
    echo "windowingFunction ${windowingFunction}"  >> TEMP_tracks.txt
    echo "configurable on"                         >> TEMP_tracks.txt
    echo "autoScale on"                            >> TEMP_tracks.txt
    echo "alwaysZero on"                           >> TEMP_tracks.txt
    echo "dragAndDrop subtracks"                   >> TEMP_tracks.txt
    echo "maxHeightPixels 10:20:30"                >> TEMP_tracks.txt
    echo "viewLimits 0:1"                          >> TEMP_tracks.txt
    echo "html ${folderName}/description"          >> TEMP_tracks.txt
    echo ""                                        >> TEMP_tracks.txt
    
    fi

}

doMultiWigParent(){
    
    # NEEDS THESE TO BE SET BEFORE CALL :
    #longLabel=""
    #trackName=""
    #overlayType=""
    #windowingFunction=""
    #visibility=""
    
    doTrackExist
    if [ "${trackExists}" -eq 0 ] ; then
    
    echo ""                                        >> TEMP_tracks.txt
    echo "#--------------------------------------" >> TEMP_tracks.txt
    echo ""                                        >> TEMP_tracks.txt
    
    echo "track ${trackName}"                      >> TEMP_tracks.txt
    echo "container multiWig"                      >> TEMP_tracks.txt
    echo "shortLabel ${trackName} ${shortlabel}"   >> TEMP_tracks.txt
    echo "longLabel ${longLabel} "                 >> TEMP_tracks.txt
    echo "type bigWig"                             >> TEMP_tracks.txt
    echo "visibility ${visibility}"                >> TEMP_tracks.txt
    #echo "aggregate transparentOverlay"           >> TEMP_tracks.txt
    #echo "aggregate solidOverlay"                 >> TEMP_tracks.txt
    echo "aggregate ${overlayType}"                >> TEMP_tracks.txt
    echo "showSubtrackColorOnUi on"                >> TEMP_tracks.txt
    #echo "windowingFunction maximum"              >> TEMP_tracks.txt
    #echo "windowingFunction mean"                 >> TEMP_tracks.txt
    echo "windowingFunction ${windowingFunction}"  >> TEMP_tracks.txt
    echo "configurable on"                         >> TEMP_tracks.txt
    echo "autoScale on"                            >> TEMP_tracks.txt
    echo "alwaysZero on"                           >> TEMP_tracks.txt
    echo "dragAndDrop subtracks"                   >> TEMP_tracks.txt
    echo "html ${folderName}/description"          >> TEMP_tracks.txt
    echo ""                                        >> TEMP_tracks.txt
    
    fi
}

doMultiWigChild(){
    
    # NEEDS THESE TO BE SET BEFORE CALL
    # parentTrack=""
    # trackName=""
    # fileName=".bw"
    # trackColor=""
    # trackPriority=""
    
    # Is this track already written to the tracks.txt file?
    doTrackExist
    if [ "${trackExists}" -eq 0 ] ; then
    
    # Does this track have data file which has non-zero size?
    if [ -s "${bigWigDiskPath}/${fileName}" ]; then
    
    echo "track ${trackName}"                       >> TEMP_tracks.txt
    echo "parent ${parentTrack}"                    >> TEMP_tracks.txt
    echo "bigDataUrl ${folderName}/${fileName}"     >> TEMP_tracks.txt
    echo "shortLabel ${trackName} ${shortlabel}"    >> TEMP_tracks.txt
    echo "longLabel ${longLabel} "                  >> TEMP_tracks.txt
    echo "type bigWig"                              >> TEMP_tracks.txt
    echo "color ${trackColor}"                      >> TEMP_tracks.txt
    echo "html ${folderName}/description"           >> TEMP_tracks.txt
    echo "priority ${trackPriority}"                >> TEMP_tracks.txt
    echo ""                                         >> TEMP_tracks.txt
    
    fi
    fi
}

doRegularTrack(){
    
    # NEEDS THESE TO BE SET BEFORE CALL
    # trackName=""
    # longLabel=""
    # fileName=".bw"
    # trackColor=""
    # trackPriority=""
    # visibility=""
    
    # Is this track already written to the tracks.txt file?
    doTrackExist
    if [ "${trackExists}" -eq 0 ] ; then
        
    # Does this track have data file which has non-zero size?
    if [ -s "${bigWigDiskPath}/${fileName}" ] ; then

    echo ""                                          >> TEMP_tracks.txt
    echo "#--------------------------------------"   >> TEMP_tracks.txt
    echo ""                                          >> TEMP_tracks.txt
    
    echo "track ${trackName}"                        >> TEMP_tracks.txt
    echo "bigDataUrl ${folderName}/${fileName}"      >> TEMP_tracks.txt
    echo "shortLabel ${trackName} ${shortlabel}"     >> TEMP_tracks.txt
    echo "longLabel ${longLabel}"                    >> TEMP_tracks.txt
    echo "autoScale on"                              >> TEMP_tracks.txt
    echo "alwaysZero on"                             >> TEMP_tracks.txt
    echo "type bigWig"                               >> TEMP_tracks.txt
    echo "color ${trackColor}"                       >> TEMP_tracks.txt
    echo "visibility ${visibility}"                  >> TEMP_tracks.txt
    echo "html ${folderName}/description"            >> TEMP_tracks.txt
    echo "priority ${trackPriority}"                 >> TEMP_tracks.txt
    echo ""                                          >> TEMP_tracks.txt
    
    fi
    fi
    
}

doPeakCallTrack(){
    
    # Like regular track - but draws only region from {0-1}, and in FULL visibility mode takes only 20pixels
    
    # NEEDS THESE TO BE SET BEFORE CALL
    # trackName=""
    # longLabel=""
    # fileName=".bw"
    # trackColor=""
    # trackPriority=""
    # visibility=""
    
    # Is this track already written to the tracks.txt file?
    doTrackExist
    if [ "${trackExists}" -eq 0 ] ; then
    
    # Does this track have data file which has non-zero size?
    if [ -s "${bigWigDiskPath}/${fileName}" ]; then
        
    echo ""                                          >> TEMP_tracks.txt
    echo "#--------------------------------------"   >> TEMP_tracks.txt
    echo ""                                          >> TEMP_tracks.txt
    
    echo "track ${trackName}"                        >> TEMP_tracks.txt
    echo "bigDataUrl ${folderName}/${fileName}"      >> TEMP_tracks.txt
    echo "shortLabel ${trackName} ${shortlabel}"     >> TEMP_tracks.txt
    echo "longLabel ${longLabel} "                   >> TEMP_tracks.txt
    #echo "autoScale on"                             >> TEMP_tracks.txt
    #echo "alwaysZero on"                            >> TEMP_tracks.txt
    echo "type bigWig"                               >> TEMP_tracks.txt
    echo "color ${trackColor}"                       >> TEMP_tracks.txt
    echo "visibility ${visibility}"                  >> TEMP_tracks.txt
    echo "maxHeightPixels 10:20:30"                  >> TEMP_tracks.txt
    echo "viewLimits 0:1"                            >> TEMP_tracks.txt
    echo "html ${folderName}/description"            >> TEMP_tracks.txt
    echo "priority ${trackPriority}"                 >> TEMP_tracks.txt
    echo ""                                          >> TEMP_tracks.txt
    
    fi
    fi
}

doControlTrack(){
    
    # Like regular track - but as PATH takes the FULL PATH
    
    # NEEDS THESE TO BE SET BEFORE CALL
    # trackName=""
    # longLabel=""
    # fileName="path/to/control/file.bw"
    # trackColor=""
    # trackPriority=""
    # visibility=""
    # windowingFunction=""
    
    # Is this track already written to the tracks.txt file?
    doTrackExist
    if [ "${trackExists}" -eq 0 ] ; then
    
    # Does this track have data file which has non-zero size?
    if [ -s "${fileName}" ] ; then

    echo ""                                          >> TEMP_tracks.txt
    echo "#--------------------------------------"   >> TEMP_tracks.txt
    echo ""                                          >> TEMP_tracks.txt
    
    echo "track ${trackName}"                        >> TEMP_tracks.txt
    echo "bigDataUrl ${folderName}/${fileName}"      >> TEMP_tracks.txt
    echo "shortLabel ${trackName} ${shortlabel}"     >> TEMP_tracks.txt
    echo "longLabel ${longLabel} "                   >> TEMP_tracks.txt
    
    echo "autoScale off"                             >> TEMP_tracks.txt
    echo "viewLimits 0:9"                            >> TEMP_tracks.txt
    echo "windowingFunction ${windowingFunction}"    >> TEMP_tracks.txt
    
    echo "alwaysZero on"                             >> TEMP_tracks.txt
    echo "type bigWig"                               >> TEMP_tracks.txt
    echo "color ${trackColor}"                       >> TEMP_tracks.txt
    echo "visibility ${visibility}"                  >> TEMP_tracks.txt
    echo "html ${folderName}/description"            >> TEMP_tracks.txt
    echo "priority ${trackPriority}"                 >> TEMP_tracks.txt
    echo ""                                          >> TEMP_tracks.txt
    
    fi
    fi
}

doBigBedTrack(){
    
    echo ""                                          >> TEMP_tracks.txt
    echo "#--------------------------------------"   >> TEMP_tracks.txt
    echo ""                                          >> TEMP_tracks.txt
    
    echo "track ${trackName}"                        >> TEMP_tracks.txt
    echo "bigDataUrl ${folderName}/${fileName}"      >> TEMP_tracks.txt
    echo "shortLabel ${trackName} ${shortlabel}"     >> TEMP_tracks.txt
    echo "longLabel ${longLabel} "                   >> TEMP_tracks.txt
    
    echo "type bigBed 12+"                           >> TEMP_tracks.txt
    echo "visibility ${visibility}"                  >> TEMP_tracks.txt
    echo exonArrows on                               >> TEMP_tracks.txt
    # echo itemRgb on                                  >> TEMP_tracks.txt
    # echo "#spectrum on"                            >> TEMP_tracks.txt
    echo thickDrawItem on                            >> TEMP_tracks.txt
    echo exonArrowsDense on                          >> TEMP_tracks.txt
    # echo "#bedNameLabel MyCustomName"              >> TEMP_tracks.txt

    echo "html ${folderName}/description"            >> TEMP_tracks.txt
    echo "priority ${trackPriority}"                 >> TEMP_tracks.txt
    echo ""                                          >> TEMP_tracks.txt
 

    
}

##################################################################################
#                                                                                #
# ABOVE = the FUNCTION DEFINITIONS (in bash they have to be first in the code)   #
# BELOW = the USAGE information (how to use the code)                            #
# IN THE END = the MAIN CODE itself.                                             #
#                                                                                #
##################################################################################


#------------------------------------------

# Printing the script name to output logs.
echo "--------------------------"
echo "$0"
which $0
echo
echo "--------------------------" >&2
echo "$0" >&2
which $0 >&2
echo >&2

# Loading subroutines in ..

echo "Loading subroutines in .."

PipeTopPath="$( which $0 | sed 's/\/bin\/mainScripts\/dataHubGenerator.sh$//' )"

BashHelpersPath="${PipeTopPath}/bin/bashHelpers"

# PRINTING TO LOG AND ERROR FILES
. ${BashHelpersPath}/logFilePrinter.sh

#------------------------------------------

# From where to call the CONFIGURATION script..

confFolder="${PipeTopPath}/conf"

#------------------------------------------

echo
echo "PipeTopPath ${PipeTopPath}"
echo "confFolder ${confFolder}"
echo "BashHelpersPath ${BashHelpersPath}"
echo

#------------------------------------------

# Calling in the CONFIGURATION script and its default setup :


echo "Calling in the conf/serverAddressAndPublicDiskSetup.sh script and its default setup .."

SERVERTYPE="UNDEFINED"
SERVERADDRESS="UNDEFINED"
REMOVEfromPUBLICFILEPATH="NOTHING"
ADDtoPUBLICFILEPATH="NOTHING"
tobeREPLACEDinPUBLICFILEPATH="NOTHING"
REPLACEwithThisInPUBLICFILEPATH="NOTHING"

. ${confFolder}/serverAddressAndPublicDiskSetup.sh

setPublicLocations

echo
echo "SERVERTYPE ${SERVERTYPE}"
echo "SERVERADDRESS ${SERVERADDRESS}"
echo "ADDtoPUBLICFILEPATH ${ADDtoPUBLICFILEPATH}"
echo "REMOVEfromPUBLICFILEPATH ${REMOVEfromPUBLICFILEPATH}"
echo "tobeREPLACEDinPUBLICFILEPATH ${tobeREPLACEDinPUBLICFILEPATH}"
echo "REPLACEwithThisInPUBLICFILEPATH ${REPLACEwithThisInPUBLICFILEPATH}"
echo

#------------------------------------------


genomeName=""
magicNumber="RUN"
windowSize=3
pipePath="/t1-home/molhaem2/telenius/Jelena_DNase_pipe"
SINGLEEND=0
SYMBOLICLINKS=0
OUTFILENAME="qsub.out"
ERRFILENAME="qsub.err"
shortlabel=""
longlabel=""
folderName="UNDEFINED"
samplename="UNDEFINED"

OPTS=`getopt -o o:,e:,g:,n:,w:,p:,W: --long rerun:,onlyhub:,singleEnd:,symbolic:,folder:,sample: -- "$@"`
if [ $? != 0 ]
then
    exit 1
fi

eval set -- "$OPTS"

while true ; do
    case "$1" in
        -g) genomeName=$2 ; shift 2;;
        -e) ERRFILENAME=$2 ; shift 2;;
        -o) OUTFILENAME=$2 ; shift 2;;
        -n) magicNumber=$2 ; shift 2;;
        -w) windowSize=$2 ; shift 2;;
        -W) windowTrackSize=$2 ; shift 2;;
        -p) pipePath=$2 ; shift 2;;
        --singleEnd) SINGLEEND=$2 ; shift 2;;
        --symbolic) SYMBOLICLINKS=$2 ; shift 2;;
        --folder) folderName=$2 ; shift 2;;
        --sample) samplename=$2 ; shift 2;;
        --) shift; break;;
    esac
done

longlabel=$( cat TEMP_longlabel.txt )
shortlabel=$( cat TEMP_shortlabel.txt )

echo "Starting run with parameters :"
echo "OUTFILENAME ${OUTFILENAME}"
echo "ERRFILENAME ${ERRFILENAME}"
echo "folderName ${folderName}"
echo "samplename ${samplename}"
echo "genomeName ${genomeName}"
echo "magicNumber ${magicNumber}"
echo "windowSize ${windowSize}"
echo "pipePath ${pipePath}"
echo "SINGLEEND ${SINGLEEND}"
echo "SYMBOLICLINKS ${SYMBOLICLINKS}"
echo "longlabel ${longlabel}"
echo "shortlabel ${shortlabel}"
echo

# Setting track colors : 

# Peak CYAN, summit BLUE
widepeakcolor="0,255,255"
summitcolor="0,0,255"

# Sample CYAN, control YELLOW, overlap GREEN
controlcolor="255,255,0"
samplecolor="0,255,255"


#########################################################
# MODULE 0.1) setting paths , setting timestamp
#########################################################


#----------UCSC-data-generation-starts--------------------

hublocationFile="../PIPE_hubbing.txt"
if [ "${SYMBOLICLINKS}" -eq 1 ] ; then
    hublocationFile="../PIPE_hubbingSymbolic.txt"
fi
    

if [ -r "${hublocationFile}" ] ; then
    
    # Format of the dnase_pipe_2_param.txt
    #
    # MyHubName /public/telenius/MyNewDataHub  /public/telenius/MyfolderForBigWigs
    #
    
    # Generating lists for parameters. Of course we have only ONE parameter for both variables,
    # but we need to index it out with index [0] , as this construct generates list.

    hubNameList=($( cut -f 1 "${hublocationFile}" ))
    hubName=${hubNameList[0]}
    
    hubFolderList=($( cut -f 2 "${hublocationFile}" ))
    hubFolder=${hubFolderList[0]}
    
    # Here, parsing the data area location, to reach the public are address..
    
    diskFolder=${hubFolder}
    serverFolder=""
    
    echo
    parsePublicLocations
    echo
    
    # Setting the paths for the rest of the script ..
    
    hubFolderDiskPath="${diskFolder}/${hubName}"
    bigWigDiskPath="${diskFolder}/${hubName}/${folderName}"
    
    hubServerPath="${serverFolder}/${hubName}"
    bigWigServerPath="${serverFolder}/${hubName}/${folderName}"
    
    
    if [ "${SYMBOLICLINKS}" -eq 1 ] ; then
    
    # Save the symbolic link location
    symbolicStorageList=($( cut -f 3 "${hublocationFile}" ))  
    realBigwigsForSymbolicPath="${symbolicStorageList[0]}/${hubName}/${folderName}"
    
    fi
    
    echo "hubServerPath ${hubServerPath}"
    echo "hubFolderDiskPath ${hubFolderDiskPath}"
    echo "bigWigServerPath ${bigWigServerPath}"
    echo "bigWigDiskPath ${bigWigDiskPath}"
    
    if [ "${SYMBOLICLINKS}" -eq 1 ] ; then
      
    echo "realBigwigsForSymbolicPath ${realBigwigsForSymbolicPath}"
        
    fi
    
#----- Generating TimeStamp - if files need backupping------------------

    TimeStamp=($( date | tr ':' ' ' | tr ' ' '_' ))
    DateTime="$(date)"
    
    
#########################################################
# MODULE 0.2) checking file existence - and non-zero bigwig size 
#########################################################

#-----------------------------------------------------------------

    # Checking for files with zero size..
    
    for file in *.bw
    do
        if [ ! -s "${file}" ]
        then
            rm -f "${file}"
        fi
    done


#########################################################
# MODULE 1) hub f1
#########################################################

    # If the Hub itself is not created already, we create it now..
    if [ ! -d "${hubFolderDiskPath}" ]; then
        
      printThis="Generating HUB folder ${hubFolderDiskPath}"
      printToLogFile   
      
      mkdir -p "${hubFolderDiskPath}"
      
    fi
    
    if [ ! -s "${hubFolderDiskPath}"/hub.txt ]; then
      
      echo "hub ${hubName}" > TEMP_hub.txt
      echo "shortLabel ${hubName}" >> TEMP_hub.txt
      echo "longLabel ${hubName}" >> TEMP_hub.txt
      echo "genomesFile genomes.txt" >> TEMP_hub.txt
      echo "email jelena.telenius@gmail.com" >> TEMP_hub.txt
      mv TEMP_hub.txt "${hubFolderDiskPath}"/hub.txt
      
    fi
    
    if [ ! -s "${hubFolderDiskPath}"/genomes.txt ]; then  
      
      echo "genome ${genomeName}" > TEMP_genomes.txt
      echo "trackDb tracks.txt" >> TEMP_genomes.txt
      echo "" >> TEMP_genomes.txt
      cat TEMP_genomes.txt >> "${hubFolderDiskPath}"/genomes.txt
      rm -f TEMP_genomes.txt

    fi
    



#########################################################
# MODULE 2) hub f2 folder generation - and symbolic link folder generation (if requested)
#########################################################

   
    if [ ! -d "${bigWigDiskPath}" ]; then
      
        printThis="Generating public storage folder ${bigWigDiskPath}"
        printToLogFile
        mkdir -p "${bigWigDiskPath}"
      
    fi   
    
    
    if [ "${SYMBOLICLINKS}" -eq 1 ] ; then
        
    # If the symbolic links folder does not exist, creating it ..
    if [ ! -d "${realBigwigsForSymbolicPath}" ] ; then
        printThis="Generating BigWig storage folder ${realBigwigsForSymbolicPath}"
        printToLogFile
        mkdir -p "${realBigwigsForSymbolicPath}"
    fi

    fi

#########################################################
# MODULE 3) hub f2 "other content" than bws - and their links to description.html
#########################################################

    # HTML file generation - the BEGINNING OF THE FILE
        
    echo "Beginning to create html file ${bigWigDiskPath}/description.html (on the side of copying files).."
    
    writeBeginOfHtml

    echo "" > temp_description.html
    
    echo "<p>Data produced ${DateTime} </p>" >> temp_description.html
    cat ../versionInfoHTML.txt >> temp_description.html
 
    echo "<p><h4>Data files produced by the script :</h4>" >> temp_description.html

    echo "<li><em>peakLocations.bw</em> + <em>summitLocations.bw</em> : Wide peaks (cyan), and peak summits (blue)</li>" >> temp_description.html
    echo "<li><em>control_lambda.bw</em> + <em>treat_pileup.bw</em> : Sample (cyan), and control / local lambda (yellow), overlap green</li>" >> temp_description.html
    echo "<li><em>foldEnrichment.bw</em> : Fold-enrichment at summit</li>" >> temp_description.html
    echo "<li><em>minusLog10pvalue.bw</em> : -log10 p-value at summit</li>" >> temp_description.html
    echo "<li><em>minusLog10qvalue.bw</em> : -log10 q-value at summit</li>" >> temp_description.html
    
    echo "</p>" >> temp_description.html
    echo "<hr />" >> temp_description.html
        
    printThis="Copying (non-bigwig) files to folder ${bigWigDiskPath} - OVERWRITES if existing files in storage location have same names"
    printToLogFile 
   
    rm -rf TEMPdirectory
    mkdir TEMPdirectory
    
    cp ${samplename}*_macs*.log TEMPdirectory/.  2> /dev/null
    cp ${samplename}_model.pdf TEMPdirectory/.  2> /dev/null
    cp ../${OUTFILENAME} TEMPdirectory/qsub.out 
    cp ../${ERRFILENAME} TEMPdirectory/qsub.err   
    
    mv -f TEMPdirectory/* ${bigWigDiskPath}/. 2> /dev/null
    
    rmdir TEMPdirectory
    rm -rf TEMPdirectory  
    
   
    # The HTML file generation        

    echo "" >> temp_description.html    
    echo "<h3>Sample : ${folderName}</h3>" >> temp_description.html
    
    echo "<p>" >> temp_description.html
    echo "Data located in : $(pwd)" >> temp_description.html
    echo "</p>" >> temp_description.html
    echo "<hr />" >> temp_description.html

    echo "<h4>Macs2 statistics here : </h4>" >> temp_description.html
    
    echo "<p>" >> temp_description.html
    for file in ${bigWigServerPath}/${samplename}*_macs*.log
    do
        if [ -s ${file} ] ; then
        TEMPname=$( echo $file | sed 's/.*\///' )    
        echo "<li><a target="_blank" href=\"${SERVERTYPE}://${SERVERADDRESS}/${file}\" >${TEMPname}</a>  </li>" >> temp_description.html
        fi            
    done
    echo "</p>" >> temp_description.html
    
    
    if [ -s ${bigWigServerPath}/${samplename}_model.pdf ] ; then
    echo "<h4>Macs2 single end fitting model here : </h4>" >> temp_description.html
    echo "<p>" >> temp_description.html
        echo "<li><a target="_blank" href=\"${SERVERTYPE}://${SERVERADDRESS}/${bigWigServerPath}/${samplename}_model.pdf\" >${samplename}_model.pdf</a>  </li>" >> temp_description.html
    echo "</p>" >> temp_description.html
    fi
    
    
    if [ -s ${bigWigServerPath}/qsub.out ] || [ -s ${bigWigServerPath}/qsub.err ]; then
    
    echo "<h4>Full run log files here : </h4>" >> temp_description.html
    
    echo "<p>" >> temp_description.html
    for file in ${bigWigServerPath}/qsub*
    do
        if [ -s ${file} ] ; then
        TEMPname=$( echo $file | sed 's/.*\///' )
        echo "<li><a target="_blank" href=\"${SERVERTYPE}://${SERVERADDRESS}/${file}\" >${TEMPname}</a>  </li>" >> temp_description.html
        fi            
    done
    echo "</p>" >> temp_description.html
    
    fi
    
    echo "<hr />" >> temp_description.html
    
    # The end of  HTML file 
    echo "</body>" > end.html
    echo "</html>"  >> end.html
    
    
    # Printing the files - depending on the situation (rerun, not rerun, overwrite, not overwrite etc)
    
    # If the html file already exists, saving the old as copy (mv to a file name html_file_timestamp.html) 
    if [ -e "${bigWigDiskPath}/description.html" ]
    then
        mv "${bigWigDiskPath}/description.html" "${bigWigDiskPath}/description.html_${TimeStamp}"
        echo "Generated backup for previously-stored html file : ${bigWigDiskPath}/description.html_${TimeStamp}"
    fi
    
    cat begin.html temp_description.html end.html > "${bigWigDiskPath}/description.html"
    rm -f begin.html temp_description.html end.html
    


    
#########################################################
# MODULE 4) bigwigs - symbolic or not - tracks.txt update - and their links to description.html
#########################################################  
    
    
    #----------------------------------------------------
    # Storing and linking bigwig files..
    
    if [ "${SYMBOLICLINKS}" -eq 1 ] ; then
    
    # Storing files in EVER-LASTING-NON-PUBLIC-COLDER
    
    printThis="Copying files to folder ${realBigwigsForSymbolicPath} - OVERWRITES if existing files in storage location have same names"
    printToLogFile
    rm -rf TEMPdirectory
    mkdir TEMPdirectory
    cp *.bw TEMPdirectory/. 2> /dev/null
    cp *.bb TEMPdirectory/. 2> /dev/null
    mv -f TEMPdirectory/* ${realBigwigsForSymbolicPath}/.  2> /dev/null
    rmdir TEMPdirectory
    rm -rf TEMPdirectory

    #echo "Bigwig files - now located in their permanent storage folder.. :"
    #ls -l ${realBigwigsForSymbolicPath}/${folderName}/*.bw
    
    
    # Generating symbolic links
    
    printThis="Making symbolic links to folder ${bigWigDiskPath} - OVERWRITES if existing files in public folder have same names"
    printToLogFile
    
    thisDir=$( pwd )
    cd ${bigWigDiskPath}
    ln -fs ${realBigwigsForSymbolicPath}/*.bw . 2> /dev/null
    ln -fs ${realBigwigsForSymbolicPath}/*.bb . 2> /dev/null
    
    # If there weren't any (broken links) - bb gets generated only if BROAD peak run .. 
    rm -f \*.bb 2> /dev/null
    rm -f \*.bw 2> /dev/null

    #echo "Bigwig files - now symbolically linked to their public folder.. :"
    #ls -l ${bigWigDiskPath}/*.bw  

    cd ${thisDir}
    
    else
    
    # Storing files in public folder.. 
    
    printThis="Copying files to folder ${bigWigDiskPath} - OVERWRITES if existing files in storage location have same names"
    printToLogFile 
    
    rm -rf TEMPdirectory
    mkdir TEMPdirectory
    cp -f *.bw TEMPdirectory/. 2> /dev/null
    cp -f *.bb TEMPdirectory/. 2> /dev/null
    mv -f TEMPdirectory/*.bw ${bigWigDiskPath}/. 2> /dev/null
    mv -f TEMPdirectory/*.bb ${bigWigDiskPath}/. 2> /dev/null
    rmdir TEMPdirectory
    rm -rf TEMPdirectory
    
    #echo "Bigwig files - now located in their public folder.. :"
    #ls -l ${bigWigDiskPath}/*.bw
    
    fi
    
    # If there weren't any (broken links) .. 
    rm -f \*.bb 2> /dev/null
    rm -f \*.bw 2> /dev/null
    
    #----------------------------------------------------
    # Generating the track files
    
    printThis="Generating tracks.txt file.."
    printToLogFile   
    
    # If the TEMP_tracks.txt already exist, saving the old as copy (mv to a file name FileName_timestamp.txt)
    if [ -e "./TEMP_tracks.txt" ]
    then
        mv TEMP_tracks.txt "TEMP_tracks.txt_${TimeStamp}" 2> /dev/null
    fi
    
    # Creating the output file with an empty line
    echo "" > TEMP_tracks.txt

    #-----------------------------------------------------------------------------------------

    # Bigbed track for the broad gapped peaks (if exists)
    
    if [ -s "${bigWigDiskPath}/${samplename}_gappedPeak.bb" ] 
    then

    longLabel="${samplename} ${longlabel} gapped peaks "
    trackName="${samplename}_gappedPEAK"
    visibility="dense"
    fileName="${samplename}_gappedPeak.bb"
    trackPriority="100"

    doBigBedTrack

    fi

    #-----------------------------------------------------------------------------------------    
    
    # Overlay track for peak files ..
    
    if [ -s "${bigWigDiskPath}/${samplename}_peakLocations.bw" ] || [ -s "${bigWigDiskPath}/${samplename}_summitLocations.bw" ]
    then
    
    # windowTrackSize
    longLabel="${samplename} ${longlabel} peaks CYAN, summits BLUE"
    trackName="${samplename}_PEAK"
    overlayType="transparentOverlay"
    windowingFunction="maximum"
    visibility="full"
    doMultiWigParentPeaks
    
    parentTrack="${samplename}_PEAK"
    trackName="${samplename}_peak"
    fileName="${samplename}_peakLocations.bw"
    trackColor=${widepeakcolor}
    trackPriority="100"
    doMultiWigChild
    
    parentTrack="${samplename}_PEAK"
    trackName="${samplename}_summit"
    fileName="${samplename}_summitLocations.bw"
    trackColor=${summitcolor}
    trackPriority="110"
    doMultiWigChild
    
    fi
    
    #-----------------------------------------------------------------------------------------
    
    # Overlay track for signal track files ..
    
    if [ -s "${bigWigDiskPath}/${samplename}_treat_pileup.bw" ] || [ -s "${bigWigDiskPath}/${samplename}_control_lambda.bw" ]
    then
    
    # windowTrackSize
    longLabel="${samplename} ${longlabel} sample CYAN, control YELLOW, overlap GREEN, reads per million"
    trackName="${samplename}_RPM"
    overlayType="transparentOverlay"
    windowingFunction="maximum"
    visibility="full"
    doMultiWigParent
    
    parentTrack="${samplename}_RPM"
    trackName="${samplename}_sample"
    fileName="${samplename}_treat_pileup.bw"
    trackColor=${samplecolor}
    trackPriority="100"
    doMultiWigChild
    
    parentTrack="${samplename}_RPM"
    trackName="${samplename}_control_lambda"
    fileName="${samplename}_control_lambda.bw"
    trackColor=${controlcolor}
    trackPriority="110"
    doMultiWigChild
    
    fi
    
    #-----------------------------------------------------------------------------------------

    # Single hidden tracks for the statistics ..
 
    trackName="${samplename}_S_fold"
    longLabel="${samplename} ${longlabel} fold-enrichment (from MACS2)"
    fileName="${samplename}_foldEnrichment.bw"
    trackColor="150,150,150"
    trackPriority="100"
    visibility="hide"
    
    doRegularTrack
  
    trackName="${samplename}_S_log10p"
    longLabel="${samplename} ${longlabel} minus log 10 p value (from MACS2)"
    fileName="${samplename}_minusLog10pvalue.bw"
    trackColor="150,150,100"
    trackPriority="100"
    visibility="hide"
    
    doRegularTrack
    
    trackName="${samplename}_S_log10q"
    longLabel="${samplename} ${longlabel} minus log 10 q value (from MACS2)"
    fileName="${samplename}_minusLog10qvalue.bw"
    trackColor="100,150,150"
    trackPriority="100"
    visibility="hide"
    
    doRegularTrack
   
    #--------------------------------------------------------------------------------------------------------------------
    
    # If the TEMP_tracks.txt already exist IN THE HUB, saving the old as copy (mv to a file name FileName_fimestamp.html)
    # This is naturally only done if the file existed before launching this pipeline (remember that multiple samples can update same tracks file!)
    
    if [ -e "${hubFolderDiskPath}/tracks.txt" ]
    then
        
        # If we are not running yet (i.e. first time in this run we enter this directory) - we take safety copy - here magic number $$ is the shell id.
        if [ ! -r "${hubFolderDiskPath}/${magicNumber}.temp" ]
          then
          cp "${hubFolderDiskPath}/tracks.txt" "${hubFolderDiskPath}/tracks.txt_${TimeStamp}"
        fi
        
        # In any case - we catenate what we have, to the existing tracks.
        mv -f "${hubFolderDiskPath}/tracks.txt" previous_tracks.txt 2> /dev/null
        cat previous_tracks.txt TEMP_tracks.txt > "${hubFolderDiskPath}/tracks.txt"
        rm -f TEMP_tracks.txt previous_tracks.txt
    
    # If the target directory had no tracks.txt
    else
        mv TEMP_tracks.txt "${hubFolderDiskPath}/tracks.txt"
    fi

    # Setting the magic marker - after first safety copy there should be THIS FILE in the folder - taking safety copies during run is prevented !
    echo "running!" > ${hubFolderDiskPath}/${magicNumber}.temp
    # This file ${magicNumber}.temp is explicitly deleted in DnaseAndChip_pipe1.sh parent script, after the whole pipe has ran and finished.

    
#########################################################
# MODULE 5) listing the folders and hub address etc. 
#########################################################
    
   
    # Listing the produced files and data structures. Also giving the URL of the hub, and link to the "how to use a hub" pdf.
    
    echo
    echo "Data storage folder contents"
    echo "${bigWigDiskPath}"
    ls -lh "${bigWigDiskPath}" | cut -d "" -f 1,2,3,4 --complement 
    echo ""
    
    
echo
echo "Generated / updated data hub :"
echo
    tempPath=$(echo "${SERVERADDRESS}/${hubServerPath}/hub.txt" | sed 's/\/\/*/\//g')   
    echo "${SERVERTYPE}://${tempPath}" > hub_address.txt
cat hub_address.txt

else
    printThis="No parameter file ${hublocationFile} provided in the running folder.\n--> no data hub structures produced !"
    printToLogFile   
    
fi
