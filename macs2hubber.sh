#!/bin/bash

function finish {

# Your cleanup code here

cd ${weAreHere}

rm -f versionInfoHTML.txt
rm -f versionInfo.txt

}
trap finish EXIT

printRunStartArraysBam(){
  
    for k in $( seq 0 $((${#samplenames[@]} - 1)) ); do
        echo "samplenames[$k]  ${samplenames[$k]}"
    done    
    echo    

    for k in $( seq 0 $((${#foldernames[@]} - 1)) ); do
        echo "foldernames[$k]  ${foldernames[$k]}"
    done    
    echo
    
    for k in $( seq 0 $((${#samplefiles[@]} - 1)) ); do
        echo "samplefiles[$k]  ${samplefiles[$k]}"
    done    
    echo    

    if [ "${weHaveControl}" -eq 1 ]; then
    for k in $( seq 0 $((${#controlfiles[@]} - 1)) ); do
        echo "controlfiles[$k]  ${controlfiles[$k]}"
    done    
    echo
    fi    
    
}

# ------------------------------------------

GENOME="UNDEFINED"

timestamp=$( date +%d%b%Y_%H_%M )

MagicNumber=$$

#------------------------------------------

# For making sure we know where we are ..
weAreHere=$( pwd )

#------------------------------------------
# Help requests ..


if [ $# -eq 1 ];then
if [ $@ == "-h" ] || [ $@ == "--help" ];then
    
PipeTopPath="$( which $0 | sed 's/\/macs2hubber.sh$//' )"
BashHelpersPath="${PipeTopPath}/bin/bashHelpers"
. ${BashHelpersPath}/usageAndVersion.sh
    
usage

exit 0

fi
fi

#------------------------------------------

echo
echo "macs2hubber.sh - by Jelena Telenius, 14/02/2017"
echo
timepoint=$( date )
echo "run started : ${timepoint}"
echo
echo "Script located at"
which $0
echo

parameterList=$@

# MACS2 parameters state a parsing problem, because :
# 1) we don't want to read them in with GETOPTS (bash parameter reader), as supporting "all macs2 parameters" is easier if we don't specify all of them
# 2) parsing stuff with -- or - in the beginning and - in the middle of the name (--shift-control) are difficult, if the argument is the first in $@ list (there is no whitespace before the argument)
# 3) we still need to support the normal parameter rules : if same parameter is given multiple times accidentally, the last time the parameter is there, will be the one which "overwrites" the previous settings.

# We are using "echo" to parse these.
# Thus - the flags "echo" has are the problem.
# It has these :
#        -n     do not output the trailing newline
#        -e     enable interpretation of backslash escapes
#        -E     disable interpretation of backslash escapes (default)
#        --help display this help and exit
#        --version output version information and exit

# So, the first task is to see that the first parameter is not one of these (--help is already dealt with above)

# Macs2 does not have flag -e -E , but it has --version and -n
# And, of course, we are actually potentially using -n
# The only problem is if we have these as the FIRST parameter.
# So we SHIELD our parameter list by writing something to the start :

# We start by adding \s to the beginning of the list (to differentiate between - in the middle of flag (--shift-control) and in the beginning of it ..)

parameterList="PARAMETERS ${parameterList} END"

#------------------------------------------

# Loading subroutines in ..

PipeTopPath="$( which $0 | sed 's/\/macs2hubber.sh$//' )"

BashHelpersPath="${PipeTopPath}/bin/bashHelpers"
# PerlHelpersPath="${PipeTopPath}/perlHelpers"
# PythonHelpersPath="${PipeTopPath}/pythonHelpers"
# RHelpersPath="${PipeTopPath}/rHelpers"

# USAGE AND VERSION
. ${BashHelpersPath}/usageAndVersion.sh

# READ THE PARAMETER FILES IN 
. ${BashHelpersPath}/readParameters.sh
# TEST THE FILE EXISTENCE AND INTEGRITY
. ${BashHelpersPath}/fileTesters.sh
# PRINT TO LOG FILES
. ${BashHelpersPath}/logFilePrinter.sh

# RUNNING THE ACTUAL ANALYSIS
. ${BashHelpersPath}/runscript.sh

# PRINTING HELP AND VERSION MESSAGES
. ${BashHelpersPath}/usageAndVersion.sh

#------------------------------------------

version
echo -e ${versionInfo}

echo "RUNNING IN MACHINE : "
hostname --long
echo

echo "run called with parameters :"
echo "macs2hubber.sh" $@
echo

echo "running in folder :"
pwd
echo

#------------------------------------------

# From where to call the CONFIGURATION script..

confFolder="${PipeTopPath}/conf"

supportedGenomes=()
UCSC=()
genomeBuild=""

. ${confFolder}/loadNeededTools.sh
. ${confFolder}/genomeBuildSetup.sh
. ${confFolder}/serverAddressAndPublicDiskSetup.sh

setGenomeLocations

echo 
echo "Supported genomes : "
for g in $( seq 0 $((${#supportedGenomes[@]}-1)) ); do echo -n "${supportedGenomes[$g]} "; done
echo 
echo


#------------------------------------------

# From where to call the main scripts operating from the mainScripts folder..

MainScriptsPath="${PipeTopPath}/bin/mainScripts"

#------------------------------------------

echo
echo "PipeTopPath ${PipeTopPath}"
echo "BashHelpersPath ${BashHelpersPath}"
echo "MainScriptsPath ${MainScriptsPath}"
echo "confFolder ${confFolder}"
# echo "PerlHelpersPath ${PerlHelpersPath}"
# echo "PythonHelpersPath ${PythonHelpersPath}"
# echo "RHelpersPath ${RHelpersPath}"
echo

#---------------------------------------------

if [ ! -s PIPE_hubbing.txt ] && [ ! -s PIPE_hubbingSymbolic.txt ] ; then
  printThis="No parameter file PIPE_hubbing.txt or PIPE_hubbingSymbolic.txt provided - pipeline aborted"
  printToLogFile   
  printThis="Exiting !"
  printToLogFile
  printThis="Usage instructions available with :\nmacs2hubber.sh --help "
  printToLogFile

  exit 1
   
fi

if [ -s PIPE_hubbing.txt ] && [ -s PIPE_hubbingSymbolic.txt ] ; then
  printThis="Both parameter files PIPE_hubbing.txt and PIPE_hubbingSymbolic.txt provided (give ONLY ONE of these) - pipeline aborted"
  printToLogFile   
  printThis="Exiting !"
  printToLogFile
  printThis="Usage instructions available with :\nmacs2hubber.sh --help "
  printToLogFile

  exit 1
   
fi

SYMBOLIC=0
if [ -s PIPE_hubbingSymbolic.txt ] ; then
   SYMBOLIC=1 
fi

#---------------------------------------------

# Parsing param files ( we have at least hubbing parameters )

parseWhiteSpace
    
#---------------------------------------------


# Dividing to branches - running WITH or WITHOUT parameter files..

printThis="Dividing to branches - running WITH or WITHOUT parameter files .."
printNewChapterToLogFile

weHaveParamFiles=0

if [ -s PIPE_sampleBamPaths.txt ] || [ -s PIPE_controlBamPaths.txt ] ; then
    echo "Found PIPE_sampleBamPaths.txt - turning on PARAMETER-FILE dependent run !"
    weHaveParamFiles=1
    
else
    echo "Assuming all run parameters are given in the pipeline command !"  
    echo " ( didn't find PIPE_sampleBamPaths.txt / PIPE_controlBamPaths.txt )"
fi

#---------------------------------------------

# Setting and checking obligatory parameters (and other command-line parameters)..

printThis="Checking macs2 run parameters (and setting default ones) .."
printNewChapterToLogFile

# common defaults
shortlabel=""
longlabel=""
GENOME=""
FILETYPE=""
# non-parameter-file defaults
samplename="macs2"
foldername="macs2_output"

parametersOK=1
parseParameters

#---------------------------------------------

# Crashing, if command line parameters were given wrong ..

if [ "${parametersOK}" -eq 0 ];then
  printThis="Command line parameters given wrong, or conflict between command line params and PIPE_*BamPaths.txt param files ! \nSee error messages in the run error log file."
  printToLogFile
  echo "That is : see above (in this file)" >&2

  printThis="Exiting !"
  printToLogFile
  printThis="Usage instructions available with :\nmacs2hubber.sh --help "
  printToLogFile

  exit 1 
fi

#---------------------------------------------

# Checking INPUT existence ..

printThis="Checking if we have CONTROL samples .."
printNewChapterToLogFile

weHaveControl=0
if [ "${weHaveParamFiles}" -eq 1 ]; then
   
    if [ -s PIPE_controlBamPaths.txt ]; then
      weHaveControl=1;
      printThis="Yes we have !"
    else
     printThis="No control samples found !"
    fi
    printToLogFile
    
else
    
    # If we have control samples
    macsflag='-c'
    macsOnOff
    if [ "${macsHasThisFlag}" -eq 1 ];then
      weHaveControl=1;
      printThis="Yes we have !"
    else
      printThis="No control samples found !"
    fi
    printToLogFile
    
fi

# --------------------------------------------

# Setting and checking parameter-file-red obligatory parameters ..

# parameter-file defaults
samplenames=()
foldernames=()
samplefiles=()
controlfiles=()

parameterFilesOK=1
if [ "${weHaveParamFiles}" -eq 1 ]; then
    
    printThis="Checking parameter files (and setting parameters) .."
    printNewChapterToLogFile
    
    parseParameterFiles
    
fi


#---------------------------------------------

# Crashing, if parameter file parameters were given wrong ..

if [ "${parameterFilesOK}" -eq 0 ];then
  printThis="Parameter files had problems (empty columns, not unique sample names) ! \nSee error messages in the run error log file."
  printToLogFile
  echo "That is : see above (in this file)" >&2

  printThis="Exiting !"
  printToLogFile
  printThis="Usage instructions available with :\nmacs2hubber.sh --help "
  printToLogFile

  exit 1
fi


#---------------------------------------------

# Checking BAM files existence (whether or not we have parameter files) ..

printThis="Checking BAM files existence .."
printNewChapterToLogFile

bamsFine=1

if [ "${weHaveParamFiles}" -eq 1 ]; then
    
    BAMtype="sample"
    bamExistenceParamFile
    
    if [ "${weHaveControl}" -eq 1 ]; then
      BAMtype="control"
      bamExistenceParamFile
    fi
    
else
    
    BAMtype="sample"
    bamExistence
    
    if [ "${weHaveControl}" -eq 1 ]; then  
      BAMtype="control"
      bamExistence
    fi
    
fi

if [ "${bamsFine}" -eq 0 ] ; then
    printThis="Problems in finding or reading some of the BAM files !\n Check error messages from the run error file !"
    printToLogFile
    printThis="Exiting !"
    printToLogFile
    printThis="Usage instructions available with :\nmacs2hubber.sh --help "
    printToLogFile
    
    exit 1
fi

# --------------------------------------------

printThis="All parameters set ! "
printNewChapterToLogFile

echo
echo "Run with parameters :"
echo ""

echo "Command line parameters : "
echo "${parameterList}"
echo
echo "GENOME ${GENOME}"
echo "HUBGENOME ${HUBGENOME}"
echo "FILETYPE ${FILETYPE}"
echo
echo "weHaveParamFiles ${weHaveParamFiles}"
echo "weHaveControl ${weHaveControl}"
echo
echo "shortlabel ${shortlabel}"
echo "longlabel ${longlabel}"
echo "SYMBOLIC ${SYMBOLIC}"
echo

if [ "${weHaveParamFiles}" -eq 0 ]; then  
# non-parameter-file defaults
echo "samplename ${samplename}"
echo "foldername ${foldername}"
else
# parameter-file defaults
printRunStartArraysBam
fi

echo


#--------Setting-the-environment------------------------------------------------------------

printThis="LOADING RUNNING ENVIRONMENT"
printNewChapterToLogFile

# Call config file to load modules
setPathsForPipe

#---------------------------------------------

# Set ucsc genome sizes

printThis="Setting ucsc genome sizes .."
printNewChapterToLogFile

# Call config file
# Use config file
setUCSCgenomeSizes

# ##########################################################################################

# Starting the actual MACS2 run(s) ..

# First, re-parsing the parameter list ..

# Restoring the parameter list END ..
parameterList=$( echo ${parameterList} | sed 's/\s*END$//' )

if [ "${weHaveParamFiles}" -eq 0 ]; then  
# non-parameter-file run
    runParams=${parameterList}


    # rm -rf ${foldername}
    if [ ! -d ${foldername} ]; then 
    mkdir ${foldername}
    else
       printThis="Output folder ${foldername} already exists ! Cannot overwrite ! "
       printToLogFile

        printThis="Exiting !"
        printToLogFile
        printThis="Usage instructions available with :\nmacs2hubber.sh --help "
        printToLogFile
    
        exit 1   
    fi
    
    if [ ! -d ${foldername} ]; then 
       printThis="Couldn't generate output folder ${foldername} ! "
       printToLogFile

        printThis="Exiting !"
        printToLogFile
        printThis="Usage instructions available with :\nmacs2hubber.sh --help "
        printToLogFile
    
        exit 1   
    fi

    runMacsNoParamFile  
    
    cd ${foldername}
        macs2runner
    cd ..
else
# parameter-file run
    for i in $( seq 0 $((${#foldernames[@]} - 1)) ); do
        samplename=${samplenames[i]}
        foldername=${foldernames[i]}
        
        sed 's/\s*END$/ --SPMR --bdg END/'
        
        sampleFilesWithSpace=$( echo ${samplefiles[i]} | tr ',' ' ' )
        
        if [ "${weHaveControl}" -eq 1 ]; then
        controlFilesWithSpace=$( echo ${controlfiles[i]} | tr ',' ' ' )
        runParams=$( echo ${parameterList} -t ${sampleFilesWithSpace} -c ${controlFilesWithSpace} )
        else
        runParams=$( echo ${parameterList} -t ${sampleFilesWithSpace} )
        fi
        
        rm -rf ${foldername}
        mkdir ${foldername}
        cd ${foldername}
            runMacsParamFile
            macs2runner            
        cd ..
        
    done    
    echo
fi

# ----------------------------------------
# All done !

#Remove the marker files from hub - run has ended !

if [ -r "./PIPE_hubbing.txt" ] ; then
   hubFolderCheck=$( cat ./PIPE_hubbing.txt | awk '{print $2"/"$1 }' )
elif [ -r "./PIPE_hubbingSymbolic.txt" ] ;  then
   hubFolderCheck=$( cat ./PIPE_hubbingSymbolic.txt | awk '{print $2"/"$1 }' )
fi

rm -f ${hubFolderCheck}/*/${MagicNumber}.temp

rm -f versionInfoHTML.txt
rm -f versionInfo.txt

printThis="Now finished with all samples !"
printNewChapterToLogFile


# As we make only one hub, the address is always the same .
if [ $(($( ls */hub_address.txt 2> /dev/null | grep -c "" ))) -ne 0 ]; then
echo
echo "Generated / updated data hub :"
echo
cat */hub_address.txt | uniq
echo
echo 'How to load this hub to UCSC : http://userweb.molbiol.ox.ac.uk/public/telenius/DataHubs/ReadMe/HowToUseA_DataHUB_160813.pdf'
echo
echo 'Other tutorials : http://userweb.molbiol.ox.ac.uk/public/telenius/DataHubs/ReadmeFiles.html'
fi

if [ $(($( ls */hub_error.txt 2> /dev/null | grep -c "" ))) -ne 0 ]; then
    
echo
echo "Hubbing did not succeed for these samples :"
echo
    
for file in */hub_error.txt
do
echo "${file} :"
cat ${file}
echo
done

fi


timepoint=$( date )
echo
echo "run finished : ${timepoint}"
echo

exit 0


