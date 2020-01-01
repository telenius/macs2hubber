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

setMacs2Module(){
    
# We need to :
# 1) parse the --macs2version out of the command (so that we don't feed it to the macs2 run accidentally)
# 2) defaults to "module load macs2" - if none is specified.

# NOTE ! - the below works only because we have added PARAMETERS\s (text+space) to the beginning of the parameter list before ever entering this subroutine
# This because : 1) we need space before the first argument to parse this kind of arguments "--shift-control" (to know whether our hyphen - is happening in the middle of argument or beginning of it)
#                2) command "echo" shares flags --version and -n with macs2 : we need to shield with a string "PARAMETERS" before these flags, to not to give them as arguments to echo !

macsflag="--macs2version"
macsOnOff
if [ "${macsHasThisFlag}" -eq 0 ];then
    printThis="Not found flag --macs2version : setting the DEFAULT macs2 module of CBRG ."
    printToLogFile
    module load macs2
else
    macsParam
    # above sets this : macsvalue
    printThis="Found flag --macs2version : setting the USER DEFINED macs2 module ${macsvalue} ."
    printToLogFile
    module load ${macsvalue}
    removeMacsParamAndValue
fi

# Check that this worked :

macsLoadedOK=$(($( module list 2>&1  | grep -c macs2 | awk '{ if ($1>0) print 1 ; else print 0 }' )))

}

setPathsForPipe(){
    
module purge
module load ucsctools/1.0

perl --version | head -n 3
# (biopivot uses perl)

# python --version
# R --version | head -n 3

macsLoadedOK=1
setMacs2Module
# Above parses the parameter file, and sets the requested module.
# If none is specifically requested, running "module load macs2" to get default.

if [ "${macsLoadedOK}" -eq 0 ] ; then
    printThis="Could not load requested macs2 module !\n Check error messages from the run error file !"
    printToLogFile
    availableMacsVersions=$( module avail 2>&1  | grep macs2 | sed 's/^.*macs2/macs2/' | sed 's/\s.*//' | sed 's/n//' | tr '\n' ' ' | sed 's/\s/     /g' )
    printThis="These macs2 versions are available :"
    printToLogFile
    printThis="${availableMacsVersions}"
    printToLogFile
    printThis="Request the one you wish like this : --macs2version macs2/2.0.1 "
    printToLogFile
    
    printThis "Exiting !"
    printToLogFile
    
    exit 1
fi


module list 2>&1

# usepkg biopivot
# usepkg is not available in queue system

# Setting this manually (based on biopivot usage message : )

# [telenius@deva macs2tester_040417]$ usepkg biopivot
# "biopivot" has the following versions installed:
# 0.01 
#  All programs in /package/biopivot/default/bin should
#  be accessible. information about the package, if any,
#  may be found in  /package/biopivot/default/doc
#
# The system default version is  0.01

export PATH=$PATH:/package/biopivot/default/bin

echo
echo "Biopivot loaded to path as : "
echo
echo $PATH | tr ':' '\n' | grep biopivot
echo

}

