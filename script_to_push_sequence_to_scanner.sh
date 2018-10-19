#!/bin/bash

#
# Download <psd> and <psd>.psd.o files to the scanner
#
#  input ($1) is the name of the pulse sequence

#
#  Make sure that there is at least the one parameter
#  which should be the basename of the pulse sequence.
#
#	ex.  3dfsemti.e -->  3dfsemti
#

#if ( $1 == "" )  then
#  echo " "
#  echo " *** "
#  echo " *** USAGE: download_psd <psdname> [<newpsdname>]"
#  echo " *** "
#  echo " "
#  echo "     Ex. 1: download_psd fse      --> copies <fse> PSD"
#  echo "     Ex. 2: download_psd fse fse2 --> copies <fse> PSD as <fse2>"
#  echo " "
#
#  exit 1
#endif

#
#  Make sure that both <psd> and <psd>.psd.o exist.
#

#if ( ! -e $1 | ! -e $1.psd.o ) then
#  echo " "
#  echo " *** "
#  echo " *** ERROR: Either <$1> or <$1.psd.o> does not exist."
#  echo " ***        Please perform Hardware make to re-generate."
#  echo " *** "
#  echo " "
#
#  exit 1 
#endif

#
#  Scanner Side Parameters
#

export ME="mmacdon"
export SCANNER_USER="sdc"
export MR_DIR="/usr/g/research/UofC"
export SCANNER_IP="139.48.44.90"

#
#  Rsync the files to the scanner 
#

#echo "rsync -rv --verbose --progress --stats $1 ${USER}@${SCANNER}:${MR_DIR}"

#rsync -rv --verbose --progress --stats $1 ${SCANNER_USER}@${SCANNER_IP}:MR_DIR/$1
#rsync -rv --verbose --progress --stats $1.psd.o ${SCANNER_USER}@${SCANNER_IP}:MR_DIR/$1.psd.o

#
#  Now actually ftp.
#
#
/usr/bin/sftp ${SCANNER_USER}@${SCANNER_IP} <<end-ftp
  cd $MR_DIR/$ME
  put $1
  put $1.psd.o
end-ftp

