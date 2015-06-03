#! /bin/sh


if test $# -ne 4
then  
  echo "Please specify all values in the menu."
  exit 1
fi


ds9=$1
obsid=$2
dir=$3
view=$4

nxpa=`xpaaccess -n ${ds9}`
if test $nxpa -ne 1
then
  echo "# -------------------"
  echo "Multiple (${nxpa}) ds9's are running using the same title: '${ds9}'.  Please close the other windows and restart."
  exit 1
fi

if test "x$obsid" = x
then
  echo "Please enter a value for the OBS_ID: an integer number between 1 and 65535."
  exit 1  
fi

if test "x$dir" = x
then
  :
else
  mkdir -p $dir
  cd $dir
fi


obsid_search_csc obsid=$obsid outfile=${obsid}.tsv columns=INDEF download=none clobber=yes

if test "x$view" = xyes
then
    xpaset -p ${ds9} catalog import tsv $PWD/${obsid}.tsv
fi


echo "Files have been downloaded to $PWD"

exit 0

