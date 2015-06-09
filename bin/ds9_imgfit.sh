#! /bin/sh


ds9=$1
model=$2
modelbkg=$3
getconf=$4



nxpa=`xpaaccess -n ${ds9}`
if test $nxpa -ne 1
then
  echo "# -------------------"
  echo "Multiple (${nxpa}) ds9's are running using the same title: '${ds9}'.  Please close the other windows and restart."
  exit 1
fi




src=`xpaget ${ds9} regions -format ciao source -strip -selected | tr -d ";"`

if test "x${src}" = x
then
  src="field()"
fi

if test x$getconf = x1
then
  conf="conf()"
else
  conf=""
fi


echo "  (1/3) Getting data"

xpaget $ds9 fits > $ASCDS_WORK_PATH/$$_img.fits 

echo "  (2/3) Getting moments to provide better guess"

punlearn imgmoment
imgmoment "$ASCDS_WORK_PATH/$$_img.fits[(x,y)=$src]" 
xx=`pget imgmoment x_mu`
yy=`pget imgmoment y_mu`
mjr=`pget imgmoment xsig`
mnr=`pget imgmoment ysig`
phi=`pget imgmoment phi | awk '{print (($1+360.0)%360)*3.141592/180.0}'`


cat <<EOF > $ASCDS_WORK_PATH/$$_img.cmd

load_data("$ASCDS_WORK_PATH/$$_img.fits")
set_coord("physical")

set_source("${model}.mdl1+${modelbkg}.bkg1")
ignore2d()
notice2d("${src}")
thaw(mdl1)
thaw(bkg1)
guess(mdl1)
guess(bkg1)

mdl1.theta=$phi
ee=${mnr}/${mjr}
if (ee>1):
  ee=(1/ee)
mdl1.ellip=np.sqrt( 1-(ee*ee))
mdl1.xpos=$xx
mdl1.ypos=$yy
try:
  fit()
  ${conf}
except:
  pass


notice()
save_source("$ASCDS_WORK_PATH/$$_out.fits", clobber=True)
quit()
EOF

echo "  (3/3) Doing fit"

sherpa -b $ASCDS_WORK_PATH/$$_img.cmd

xpaset -p $ds9 tile
xpaset -p $ds9 frame new
cat $ASCDS_WORK_PATH/$$_out.fits | xpaset $ds9 fits


xpaset -p $ds9 frame new
dmimgcalc $ASCDS_WORK_PATH/$$_img.fits $ASCDS_WORK_PATH/$$_out.fits $ASCDS_WORK_PATH/$$_resid.fits sub clob+ lookup=""
cat $ASCDS_WORK_PATH/$$_resid.fits | xpaset $ds9 fits

echo "Done!"


/bin/rm -f  $ASCDS_WORK_PATH/$$_img.fits $ASCDS_WORK_PATH/$$_img.cmd $ASCDS_WORK_PATH/$$_out.fits $ASCDS_WORK_PATH/$$_resid.fits
