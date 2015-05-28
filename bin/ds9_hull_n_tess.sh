#! /bin/sh
# 
#  Copyright (C) 2004-2008  Smithsonian Astrophysical Observatory
#
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License along
#  with this program; if not, write to the Free Software Foundation, Inc.,
#  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#



cmd=$1
ds9=$2
min=$3



nxpa=`xpaaccess -n ${ds9}`
if test $nxpa -ne 1
then
  echo "# -------------------"
  echo "Multiple (${nxpa}) ds9's are running using the same title: '${ds9}'.  Please close the other windows and restart."
  exit 1
fi




_r=`echo "$4" | egrep ^@`
if test x$_r = x
then
  reg=`echo "$4" | tr ";" "+" | sed 's,\+$,,;s,\+\-,\-,g' `
else
  _r=`echo $_r | tr -d @`
  reg=`cat $_r | tr ";" "+" | sed 's,\+$,,;s,\+\-,\-,g' `
fi


if test x$reg = x
then
 regions=""
else
 regions="[(x,y)=${reg}]"
fi



case $cmd in

  hull)
       cat - | dmimghull -"${regions}" - tol=$min |  \
       dmmakereg region="region(-)" out=- ker=ascii | \
       sed s,blue,green, | \
       xpaset $ds9 regions
  ;;

  tess)
       cat - | dmimgtess -"${regions}" - minpix=$min edge=0 meth=tess |  \
       dmmakereg region="region(-)" out=- ker=ascii | \
       sed s,blue,green, | \
       xpaset $ds9 regions

  ;;

  tri)
       cat - | dmimgtess -"${regions}" - minpix=$min edge=0 meth=tri |  \
       dmmakereg region="region(-)" out=- ker=ascii | \
       sed s,blue,green, | \
       xpaset $ds9 regions

  ;;

esac


exit 0


