#!/bin/bash

setUCSCgenomeSizes(){
    
genomeBuild="UNDETERMINED"
    
for g in $( seq 0 $((${#supportedGenomes[@]}-1)) ); do
    
# echo ${supportedGenomes[$g]}

if [ "${supportedGenomes[$g]}" == "${HUBGENOME}" ]; then
    genomeBuild="${UCSC[$g]}"
fi

done 
    
if [ "${genomebuild}" == "UNDETERMINED" ]; then 
  echo "Genome build " ${HUBGENOME} " is not supported - aborting !"  >&2
  exit 1 
fi

# Check that the file exists..
if [ ! -e "${genomeBuild}" ] || [ ! -r "${genomeBuild}" ] || [ ! -s "${genomeBuild}" ]; then
  echo "Genome build ${HUBGENOME} file ${genomeBuild} not found or empty file - aborting !"  >&2
  exit 1     
fi

echo
echo "Genome ${HUBGENOME} . Set UCSC genome sizes file : ${genomeBuild}"
echo

}

addShortLabelMacsParamAndValue(){
# adds the above param to ${shortlabel}
# NOTE ! - the below works only because we have added PARAMETERS\s (text+space) to the beginning (and text+END) to the end of the parameter list before ever entering this subroutine
# This because : 1) we need space before the first argument to parse this kind of arguments "--shift-control" (to know whether our hyphen - is happening in the middle of argument or beginning of it)
#                2) command "echo" shares flags --version and -n with macs2 : we need to shield with a string "PARAMETERS" before these flags, to not to give them as arguments to echo !

# Needs this to be set :
# macsflag="--shift-control"
# macsvalue="0"
TEMPflag="PARAM ${macsflag}"
TEMPflag=$( echo ${TEMPflag} | sed 's/^PARAM\s*-*//' )
TEMPvalue=$( echo ${macsvalue} | sed 's/\s/_/g' )
shortlabel=$( echo ${shortlabel} | sed 's/$/, '${TEMPflag}'/' | sed 's/$/ /' | sed 's/$/'${TEMPvalue}'/' )

}

removeMacsParam(){
# removes the above param from ${parameterList}
# NOTE ! - the below works only because we have added PARAMETERS\s (text+space) to the beginning (and text+END) to the end of the parameter list before ever entering this subroutine
# This because : 1) we need space before the first argument to parse this kind of arguments "--shift-control" (to know whether our hyphen - is happening in the middle of argument or beginning of it)
#                2) command "echo" shares flags --version and -n with macs2 : we need to shield with a string "PARAMETERS" before these flags, to not to give them as arguments to echo !

# Needs this to be set :
# macsflag="--shift-control"
parameterList=$( echo ${parameterList} | sed 's/'${macsflag}'\s\s*//g' )

}

removeLongLabelMacsParamAndValue(){
# removes the above param from ${longlabel}
# NOTE ! - the below works only because we have added PARAMETERS\s (text+space) to the beginning (and text+END) to the end of the parameter list before ever entering this subroutine
# This because : 1) we need space before the first argument to parse this kind of arguments "--shift-control" (to know whether our hyphen - is happening in the middle of argument or beginning of it)
#                2) command "echo" shares flags --version and -n with macs2 : we need to shield with a string "PARAMETERS" before these flags, to not to give them as arguments to echo !

# Needs this to be set :
# macsflag="--shift-control"
# macsvalue="0"

# If it was there multiple times - we cannot use global..
# So, we do recursion instead !

# First, we save values : as they were when this sub was called :
TEMPlonglabelHasThisFlag=${longlabelHasThisFlag}
TEMPlonglabelvalue=${longlabelvalue}

# Then we do the recursion !
longlabelOnOff

while [ "${longlabelHasThisFlag}" -eq 1 ]
do
# echo long
# We ask which value we now see
longlabelParam
TEMPflag=$( echo ${longlabelvalue} | sed 's/\//\\\//g' | sed 's/^/'${macsflag}'\\s\\s\*/' | sed 's/$/\\s\\s\*/' )
# echo ${TEMPflag}
# echo ${longlabel} | sed 's/'${TEMPflag}'//'
longlabel=$( echo ${longlabel} | sed 's/'${TEMPflag}'//' )
# We ask if we still see the flag
longlabelOnOff

done

# We reset the pre-call values :

longlabelHasThisFlag=${TEMPlonglabelHasThisFlag}
longlabelvalue=${TEMPlonglabelvalue}

}

removeMacsParamAndValue(){
# removes the above param from ${parameterList}
# NOTE ! - the below works only because we have added PARAMETERS\s (text+space) to the beginning (and text+END) to the end of the parameter list before ever entering this subroutine
# This because : 1) we need space before the first argument to parse this kind of arguments "--shift-control" (to know whether our hyphen - is happening in the middle of argument or beginning of it)
#                2) command "echo" shares flags --version and -n with macs2 : we need to shield with a string "PARAMETERS" before these flags, to not to give them as arguments to echo !

# Needs this to be set :
# macsflag="--shift-control"
# macsvalue="0"

# If it was there multiple times - we cannot use global..
# So, we do recursion instead !

# First, we save values : as they were when this sub was called :
TEMPmacsHasThisFlag=${macsHasThisFlag}
TEMPmacsvalue=${macsvalue}

# Then we do the recursion !
macsOnOff

while [ "${macsHasThisFlag}" -eq 1 ]
do
# echo macs
# We ask which value we now see
macsParam
TEMPflag=$( echo ${macsvalue} | sed 's/\//\\\//g' | sed 's/^/'${macsflag}'\\s\\s\*/' | sed 's/$/\\s\\s\*/' )
# echo ${TEMPflag}
# echo ${parameterList} | sed 's/'${TEMPflag}'//'
parameterList=$( echo ${parameterList} | sed 's/'${TEMPflag}'//' )
# We ask if we still see the flag
macsOnOff

done

# We reset the pre-call values :

macsHasThisFlag=${TEMPmacsHasThisFlag}
macsvalue=${TEMPmacsvalue}

}

macsParamListFromValue(){
# NOTE ! - the below works only because we have added PARAMETERS\s (text+space) to the beginning (and text+END) to the end of the parameter list before ever entering this subroutine
# This because : 1) we need space before the first argument to parse this kind of arguments "--shift-control" (to know whether our hyphen - is happening in the middle of argument or beginning of it)
#                2) command "echo" shares flags --version and -n with macs2 : we need to shield with a string "PARAMETERS" before these flags, to not to give them as arguments to echo !

# Needs this to be set :
# macsflag="--shift-control"
macslist=()
macslist=($( echo ${parameterList} | sed 's/.*\s\s*'${macsflag}'\s\s*//' | sed 's/\s.*$//' | tr ',' '\n' ))
}

macsParam(){
# NOTE ! - the below works only because we have added PARAMETERS\s (text+space) to the beginning (and text+END) to the end of the parameter list before ever entering this subroutine
# This because : 1) we need space before the first argument to parse this kind of arguments "--shift-control" (to know whether our hyphen - is happening in the middle of argument or beginning of it)
#                2) command "echo" shares flags --version and -n with macs2 : we need to shield with a string "PARAMETERS" before these flags, to not to give them as arguments to echo !

# Needs this to be set :
# macsflag="--shift-control"

# If multiple occurences, gives the last one (will mimick MACS2 behavior - the last of them will be the one taking effect ! )

macsvalue=""
macsvalue=$( echo ${parameterList} | sed 's/.*\s\s*'${macsflag}'\s\s*//' | sed 's/\s.*$//' )
}

longlabelParam(){
# NOTE ! - the below works only because we have added PARAMETERS\s (text+space) to the beginning (and text+END) to the end of the parameter list before ever entering this subroutine
# This because : 1) we need space before the first argument to parse this kind of arguments "--shift-control" (to know whether our hyphen - is happening in the middle of argument or beginning of it)
#                2) command "echo" shares flags --version and -n with macs2 : we need to shield with a string "PARAMETERS" before these flags, to not to give them as arguments to echo !

# Needs this to be set :
# macsflag="--shift-control"
longlabelvalue=""
longlabelvalue=$( echo ${longlabel} | sed 's/.*\s\s*'${macsflag}'\s\s*//' | sed 's/\s.*$//' )
}

macsTwoValueParam(){
# NOTE ! - the below works only because we have added PARAMETERS\s (text+space) to the beginning (and text+END) to the end of the parameter list before ever entering this subroutine
# This because : 1) we need space before the first argument to parse this kind of arguments "--shift-control" (to know whether our hyphen - is happening in the middle of argument or beginning of it)
#                2) command "echo" shares flags --version and -n with macs2 : we need to shield with a string "PARAMETERS" before these flags, to not to give them as arguments to echo !

# Needs this to be set :
# macsflag="--shift-control"
macsvalue=""
macsvalue=$( echo ${parameterList} | sed 's/.*\s\s*'${macsflag}'\s\s*//' | sed 's/\s\s*/_/' | sed 's/\s.*$//' | sed 's/_/ /' )
}

macsOnOff(){
# NOTE ! - the below works only because we have added PARAMETERS\s (text+space) to the beginning (and text+END) to the end of the parameter list before ever entering this subroutine
# This because : 1) we need space before the first argument to parse this kind of arguments "--shift-control" (to know whether our hyphen - is happening in the middle of argument or beginning of it)
#                2) command "echo" shares flags --version and -n with macs2 : we need to shield with a string "PARAMETERS" before these flags, to not to give them as arguments to echo !

# Needs this to be set :
# macsflag="--shift-control"
macsHasThisFlag=0
# echo "${parameterList}" | grep -c ${TEMPflag} | awk '{ if ($1>0) print 1; else print 0}'
TEMPflag="\s${macsflag}\s"
macsHasThisFlag=$(($( echo "${parameterList}" | grep -c ${TEMPflag} | awk '{ if ($1>0) print 1; else print 0}' )))
}

longlabelOnOff(){
# NOTE ! - the below works only because we have added PARAMETERS\s (text+space) to the beginning (and text+END) to the end of the parameter list before ever entering this subroutine
# This because : 1) we need space before the first argument to parse this kind of arguments "--shift-control" (to know whether our hyphen - is happening in the middle of argument or beginning of it)
#                2) command "echo" shares flags --version and -n with macs2 : we need to shield with a string "PARAMETERS" before these flags, to not to give them as arguments to echo !

# Needs this to be set :
# macsflag="--shift-control"
longlabelHasThisFlag=0
# echo "${parameterList}" | grep -c ${TEMPflag} | awk '{ if ($1>0) print 1; else print 0}'
TEMPflag="\s${macsflag}\s"
longlabelHasThisFlag=$(($( echo "${longlabel}" | grep -c ${TEMPflag} | awk '{ if ($1>0) print 1; else print 0}' )))
}

checkIfObligatoryWasFound(){

if [ "${macsHasThisFlag}" -eq 0 ];then
    printThis="Run command didn't include flag ${macsflag} : You cannot run without setting that !"
    printToLogFile
    obligatoryFlagsFound=0
fi

}

checkIfSuggestedWasFound(){

if [ "${macsHasThisFlag}" -eq 0 ];then
    printThis="NOTE !! Run command didn't include flag ${macsflag} : \nOptimising this parameter to suit your data set is recommended ! \n( now running with default parameters )"
    printToLogFile
fi

}

checkIfSynonymousSuggestedWasFound(){

if [ "${macsHasThisFlag_first}" -eq 0 ] && [ "${macsHasThisFlag_second}" -eq 0 ] ;then
    printThis="NOTE !! Run command didn't include flag ${macsflag} : \nOptimising this parameter to suit your data set is recommended ! \n( now running with default parameters )"
    printToLogFile
fi

}

parseWhiteSpace(){

# Here parsing the parameter files - if they are not purely tab-limited, but partially space-limited, or multiple-tab limited, this fixes it.
# Also, we need to take EMPTY lines out of the files..

for file in PIPE*.txt
    do
        # echo ${file}
        # excluding the free format file
        if [ "${file}" != "PIPE_sampleComments.txt" ];
        then
            
        sed -i 's/\s\s*/\t/g' ${file}
        rm -f TEMP_$$.txt
        cp ${file} TEMP_$$.txt
        rm -f TEMP_$$_2.txt
        cat TEMP_$$.txt | grep -v "^\s*$" > TEMP_$$_2.txt
        mv -f TEMP_$$_2.txt ${file}
        rm -f TEMP_$$.txt TEMP_$$_2.txt
        
        fi
    done  
    
}

parseParameterFiles(){
    
# Reading in the parameters.
# Checking for non-unique sample names and forbidden characters, or different amount of control and sample lines.
# Setting if we have control or not
# Not checking bam file existence - will do this later (common subroutine with non-parameter-file based runs)
    
if [ ! -s PIPE_sampleBamPaths.txt ]; then
       parameterFilesOK=0
       echo "" >&2
       echo "Couldn't find file PIPE_sampleBamPaths.txt !" >&2
       echo "" >&2
else
    cut -f 1 PIPE_sampleBamPaths.txt > TEMPsampleNames.txt
    BAMtype="sample"
    testSampleNameCharacters
    if [ "${bamsFine}" -eq 0 ]; then
       parameterFilesOK=0 
    fi 
fi


if [ "${weHaveControl}" -eq 1 ]; then
    if [ ! -s PIPE_controlBamPaths.txt ]; then
       parameterFilesOK=0
       echo "" >&2
       echo "Couldn't find file PIPE_controlBamPaths.txt !" >&2
       echo "" >&2
    else
      cut -f 1 PIPE_controlBamPaths.txt > TEMPcontrolNames.txt
      BAMtype="control"
      testSampleNameCharacters
      if [ "${bamsFine}" -eq 0 ]; then
         parameterFilesOK=0 
      fi
    fi
fi

if [ "${parameterFilesOK}" -eq 1 ]; then

# Checking that same amount of lines .. (we can ignore only-whitespace-line issues, as these were parsed in the PIPE* file parsing above)

TEMPsamplecount=$(($( cat TEMPsampleNames.txt | grep -c "" )))

if [ "${weHaveControl}" -eq 1 ]; then
   TEMPcontrolcount=$(($( cat TEMPcontrolNames.txt | grep -c "" )))
   if [ "${TEMPsamplecount}" -ne "${TEMPcontrolcount}" ]; then
       parameterFilesOK=0
       echo "" >&2
       echo "Different amount of SAMPLE and CONTROL samples given in the parameter files ! " >&2
       echo "( if you give CONTROL for one sample, you have to give it for all - mixing with-control and without-control samples in the same run is not supported ) " >&2
       echo "" >&2
   fi
fi 

# Checking uniqueness ..
    
  if [ "${weHaveControl}" -eq 1 ]; then
    paste TEMPsampleNames.txt TEMPcontrolNames.txt | sed 's/\s/_VS_/' > TEMPfullnames.txt
  else
    mv -f TEMPsampleNames.txt TEMPfullnames.txt
  fi
  rm -f TEMPsampleNames.txt TEMPcontrolNames.txt
  
  TEMPuniqCount=$(($( cat TEMPfullnames.txt | uniq | grep -c "" )))
  
   if [ "${TEMPsamplecount}" -ne "${TEMPuniqCount}" ]; then
       parameterFilesOK=0
       echo "" >&2
       echo "Some sample names (or sample-control name pairs) are not unique !" >&2
       echo "( using same name for multiple samples causes overwriting of output files, so is not supported ) " >&2
       echo "" >&2
   fi
  
fi

# Setting the values ..

if [ "${parameterFilesOK}" -eq 1 ]; then
    samplenames=($( cat TEMPfullnames.txt ))
    foldernames=($( cat TEMPfullnames.txt | awk '{ print $1"_macs2_output" }' ))
    samplefiles=($( cut -f 2 PIPE_sampleBamPaths.txt ))
    if [ "${weHaveControl}" -eq 1 ]; then
    controlfiles=($( cut -f 2 PIPE_controlBamPaths.txt ))
    fi
fi

rm -f TEMPfullnames.txt
    
}

parseParameters(){
    
# -------------------------------------------------
# Building the macs2 pipe.
# 
# Flag filtering.
# 
# Have to exist :
# -g --hubGenome -f (genome, hub genome, file type)
# 
# Will be parsed out if exist IF parameter files are given :
# -n (sample name)
# --outdir (output dir)
# ( will be red from parameter files instead )
# 
# Will be parsed to a VARIABLE to be used in shell if given (and no parameter file is given) :
# -n (sample name)
# --outdir (output dir)
# 
# If found run will be crashed IF parameter files are given :
# -t -c (sample, control files)
# 
# Auto-sets these :
# 
# --SPRM --bdg --call-summits
# 
# If user given, will not be overwritten by pipe default :
# --verbose ( if user has not set, will be given as --verbose 100 )
# 
# Suggest ( give NOTE if these are ran by defaults ) :
# 
# -m 
# --bw
#
# Save the values of all params (excluding the hyphens) - excluding --SPRM --bdg --call-summits -t -c --outdir
# - to be added into longlabel. M and bw and n also to be added to the shortlabel
#
# -------------------------------------------------


# NOW, DOING IT ALONG ABOVE INSTRUCTIONS

printThis="Checking obligatory parameters.."
printToLogFile
# echo "${parameterList}" >&2

# Have to exist :
# -g --hubGenome -f (genome, hub genome, file type)

obligatoryFlagsFound=1

macsflag='-g'
macsOnOff
macsParam
# above sets this : macsvalue
GENOME="${macsvalue}"
checkIfObligatoryWasFound
# sets this : obligatoryFlagsFound=0/1

macsflag='-f'
macsOnOff
macsParam
# above sets this : macsvalue
FILETYPE="${macsvalue}"
checkIfObligatoryWasFound
# sets this : obligatoryFlagsFound=0/1

macsflag='--hubGenome'
macsOnOff
macsParam
# above sets this : macsvalue
HUBGENOME="${macsvalue}"
checkIfObligatoryWasFound
# sets this : obligatoryFlagsFound=0/1
removeMacsParamAndValue


if [ "${obligatoryFlagsFound}" -eq 0 ]; then
    parametersOK=0
    echo "" >&2
    echo "Flags -f (input file type) and -g (macs2 genome) and --hubGenome (visualisation genome) are OBLIGATORY !" >&2
    echo "Fix your command line parameters !" >&2
    echo "" >&2        
fi

# echo "${parameterList}" >&2

printThis="Checking SAMPLE and CONTROL file flags.."
printToLogFile
# echo "${parameterList}" >&2

# If found run will be crashed IF parameter files are given :
# -t -c (sample, control files)
#

if [ "${weHaveParamFiles}" -eq 1 ]; then
   macsflag='-t'
   macsOnOff
   if [ "${macsHasThisFlag}" -eq 1 ];then
       parametersOK=0
       echo "" >&2
       echo "Flag -t (sample bam file list) in command line is not allowed when using PIPE_*BamPaths.txt parameter files !" >&2
       echo "Fix your command line parameters (or delete your PIPE_*BamPaths.txt parameter files)" >&2
       echo "" >&2
   fi
   
   macsflag='-c'
   macsOnOff
   if [ "${macsHasThisFlag}" -eq 1 ];then
       parametersOK=0
       echo "" >&2
       echo "Flag -c (control bam file list) in command line is not allowed when using PIPE_*BamPaths.txt parameter files !" >&2
       echo "Fix your command line parameters (or delete your PIPE_*BamPaths.txt parameter files)" >&2
       echo "" >&2
   fi  

fi

# echo "${parameterList}" >&2

if [ "${parametersOK}" -ne 0 ]; then

printThis="Checking OUTDIR and NAME flags .."
printToLogFile
# echo "${parameterList}" >&2

# --outdir and -n (sample name)

if [ "${weHaveParamFiles}" -eq 1 ]; then
# Will be parsed out if exist IF parameter files are given :
# -n (sample name)
# --outdir (output dir)
# ( will be red from parameter files instead )
 
   macsflag='-n'
   macsOnOff
   if [ "${macsHasThisFlag}" -eq 1 ];then
       printThis="NOTE!! Found macs2 command line parameter -n : \nHOWEVER, the value of this will be replaced with the sample names given in PIPE_sampleBamPaths.txt (and PIPE_controlBamPaths.txt) !"
       printToLogFile
       TEMPparam=$( echo ${parameterList} | sed 's/^.*-n\s\s*//' | sed 's/\s.*$//' | sed 's/^/-n /' )
       parameterList=$( echo ${parameterList} | sed 's/'${TEMPparam}'//g' )
   fi

   macsflag='--name'
   macsOnOff
   if [ "${macsHasThisFlag}" -eq 1 ];then
       printThis="NOTE!! Found macs2 command line parameter -n : \nHOWEVER, the value of this will be replaced with the sample names given in PIPE_sampleBamPaths.txt (and PIPE_controlBamPaths.txt) !"
       printToLogFile
       macsParam
       removeMacsParamAndValue
   fi
   
   macsflag='--outdir'
   macsOnOff
   if [ "${macsHasThisFlag}" -eq 1 ];then
       printThis="NOTE!! Found macs2 command line parameter --outdir : \nHOWEVER, the value of this will be replaced with the sample names given in PIPE_sampleBamPaths.txt (and PIPE_controlBamPaths.txt) !"
       printToLogFile
       macsParam
       removeMacsParamAndValue
   fi
   
else
# Will be parsed to a VARIABLE to be used in shell (instead of MACS2) if given (and no parameter file is given) :
# -n (sample name)
# --outdir (output dir)
   macsflag='-n'
   macsOnOff
   if [ "${macsHasThisFlag}" -ne 0 ];then
       macsParam
       # above sets this : macsvalue
       samplename="${macsvalue}"
       removeMacsParamAndValue
   fi
   
   macsflag='--outdir'
   macsOnOff
   if [ "${macsHasThisFlag}" -ne 0 ];then
       macsParam
       # above sets this : macsvalue
       foldername="${macsvalue}"
       removeMacsParamAndValue
   fi
fi


# echo "${parameterList}" >&2

printThis="Checking FOLD CHANGE and BANDWIDTH parameters.."
printToLogFile
# echo "${parameterList}" >&2

# Suggest ( give NOTE if these are ran by defaults ) :
# 
# -m 
# --bw

macsflag='-m'
macsOnOff
macsHasThisFlag_first="${macsHasThisFlag}"

macsflag='--mfold'
macsOnOff
macsHasThisFlag_second="${macsHasThisFlag}"

checkIfSynonymousSuggestedWasFound
# gives NOTE to output log if wasn't found (as it is suggested flag)

if [ "${macsHasThisFlag_first}" -eq 0 ] && [ "${macsHasThisFlag_second}" -eq 0 ] ;then
    parameterList=$( echo "${parameterList}" | sed 's/\s*END$/ -m 5 50 END/')
fi
# At the time of building this CBRG has macs2/2.0.1 and macs2/2.0.10 . Both of these have -m 5 50 as default

macsflag='--bw'
macsOnOff

checkIfSuggestedWasFound
# gives NOTE to output log if wasn't found (as it is suggested flag)

if [ "${macsHasThisFlag}" -eq 0 ]; then
    parameterList=$( echo "${parameterList}" | sed 's/\s*END$/ --bw 300 END/')
fi
# At the time of building this CBRG has macs2/2.0.1 and macs2/2.0.10 . Both of these have --bw 300 as default

# echo "${parameterList}" >&2

# Save the values of all params (excluding the hyphens) - excluding --SPRM --bdg --call-summits --verbose xxx  -t xxx -c xxx --outdir xxx
# - to be added into longlabel. m and bw and n also to be added to the shortlabel

printThis="Setting parameter names into LONGLABEL for hub .."
printToLogFile
# echo "${longlabel}" >&2


longlabel=$( echo ${parameterList} | sed 's/--SPMR\s\s*//' | sed 's/--bdg\s\s*//' | sed 's/-B\s\s*//' | sed 's/--call-summits\s\s*//')

# echo "${longlabel}" >&2


macsflag='--verbose'
longlabelOnOff
if [ "${longlabelHasThisFlag}" -eq 1 ];then
    longlabelParam
    removeLongLabelMacsParamAndValue
fi

macsflag='-t'
longlabelOnOff
if [ "${longlabelHasThisFlag}" -eq 1 ];then
    longlabelParam
    removeLongLabelMacsParamAndValue
fi

macsflag='-c'
longlabelOnOff
if [ "${longlabelHasThisFlag}" -eq 1 ];then
    longlabelParam
    removeLongLabelMacsParamAndValue
fi

macsflag='--outdir'
longlabelOnOff
if [ "${longlabelHasThisFlag}" -eq 1 ];then
    longlabelParam
    removeLongLabelMacsParamAndValue
fi

# echo "${longlabel}" >&2

# Now, last one is to check, that we don't have MULTI-sample -t or -c parameters, i.e. taking away from long label all paths and bams !
longlabel=$( echo ${longlabel} | tr ' ' '\n'  | tr '\t' '\n' | grep -v '.bam$' | grep -v '/' | tr '\n' ' ' )

# echo "${longlabel}" >&2

# Then taking out hyphens : changing them to commas, and finalising parsing.
longlabel=$( echo ${longlabel} | sed 's/\s\s*--*/, /g' | sed 's/^PARAMETERS,\s*//' | sed 's/\s\s*END$//'  )

# echo "${longlabel}" >&2


# m and bw and n also to be added to the shortlabel

printThis="Setting parameter names into SHORTLABEL for hub .."
printToLogFile
shortlabel="PARAMETERS "
echo "${shortlabel}" >&2

macsflag='-n'
macsOnOff
if [ "${macsHasThisFlag}" -eq 1 ];then
    macsTwoValueParam
    addShortLabelMacsParamAndValue
fi

macsflag='-m'
macsOnOff
if [ "${macsHasThisFlag}" -eq 1 ];then
    macsTwoValueParam
    addShortLabelMacsParamAndValue
fi

macsflag='--mfold'
macsOnOff
if [ "${macsHasThisFlag}" -eq 1 ];then
    macsTwoValueParam
    addShortLabelMacsParamAndValue
fi

macsflag='--bw'
macsOnOff
if [ "${macsHasThisFlag}" -eq 1 ];then
    macsParam
    addShortLabelMacsParamAndValue
fi

echo "${shortlabel}" >&2

shortlabel=$( echo ${shortlabel} | sed 's/^PARAMETERS,\s*//' )

echo "${shortlabel}" >&2

# Auto-sets these :
# 
# --SPRM --bdg --call-summits
#
# Or, if specifically requested not --no-summits
# then only giving :
#
# --SPRM --bdg

# The below is 3-way if :

# 1) if --no-summits=1
# 2) if --no-summits=0 (default)
#    2a) if --broad is set (have to turn summits off)
#    2b) --broad is not set (default)

macsflag='--no-summits'
macsOnOff
if [ "${macsHasThisFlag}" -eq 1 ];then
    # Parse it away from the command (as it is not MACS2 flag).
    removeMacsParam;
    # Remove possible conflicting --call-summits
    macsflag='--call-summits'; macsOnOff
    if [ "${macsHasThisFlag}" -eq 1 ];then removeMacsParam; fi

    printThis="Adding the defaults ( --SPRM --bdg ) to run command .."
    printToLogFile
#     echo "${parameterList}" >&2

    parameterList=$( echo "${parameterList}" | sed 's/\s*END$/ --SPMR --bdg END/')
    
fi

macsflag='--no-summits'
macsOnOff
if [ "${macsHasThisFlag}" -eq 0 ];then

    macsflag='--broad'
    macsOnOff
    
    if [ "${macsHasThisFlag}" -eq 1 ];then

    printThis="Adding the defaults ( --SPRM --bdg ) to run command .."
    printToLogFile
#     echo "${parameterList}" >&2
    parameterList=$( echo "${parameterList}" | sed 's/\s*END$/ --SPMR --bdg END/')
    
    else

    printThis="Adding the defaults ( --SPRM --bdg --call-summits ) to run command .."
    printToLogFile
#     echo "${parameterList}" >&2

    parameterList=$( echo "${parameterList}" | sed 's/\s*END$/ --SPMR --bdg --call-summits END/')
    
    fi

fi

# end of if [ "${parametersOK}" -ne 0 ]; then
fi

# echo "${parameterList}" >&2

# If user given, will not be overwritten by pipe default :
# --verbose ( if user has not set, will be given as --verbose 100 )

printThis="Setting verbose to maximum (if user didn't specifically set it lower) .."
printToLogFile
# echo "${parameterList}" >&2

macsflag='--verbose'
macsOnOff

if [ "${macsHasThisFlag}" -eq 0 ];then
    parameterList=$( echo "${parameterList}" | sed 's/\s*END$/ --verbose 100 END/')
fi

# echo "${parameterList}" >&2

}

