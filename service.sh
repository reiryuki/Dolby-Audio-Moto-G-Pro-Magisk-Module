MODPATH=${0%/*}

# log
LOGFILE=$MODPATH/debug.log
exec 2>$LOGFILE
set -x

# var
API=`getprop ro.build.version.sdk`
if [ ! -d $MODPATH/vendor ]\
|| [ -L $MODPATH/vendor ]; then
  MODSYSTEM=/system
fi
MOD=/data/adb/modules/nomount
NM=$MOD/bin/nm
NOMOUNT=false
[ ! -f $MOD/disable ] && [ -x $NM ] && $NM v >/dev/null 2>&1 && NOMOUNT=true
AML=/data/adb/modules/aml
AUD=`cat $MODPATH/audio.txt`

# NoMount
if $NOMOUNT; then
  DES=/system/etc/vintf/manifest.xml
  FILE=$MODPATH$DES
  if [ -f $FILE ] && [ -f $DES ]; then
    $NM del $DES 2>/dev/null || true
    $NM add $DES $FILE
  fi
  if [ ! -d $AML ] || [ -f $AML/disable ]; then
    FILES=`find $MODPATH/system $MODPATH/vendor -type f -name $AUD`
    for FILE in $FILES; do
      DES=`echo $FILE | sed -e "s|$MODPATH||g" -e 's|/system/odm|/odm|g' -e 's|/system/my_product|/my_product|g'`
      RDES=`realpath $DES`
      if [ -f $RDES ]; then
        $NM del $RDES 2>/dev/null || true
        $NM add $RDES $FILE
      fi
    done
  fi
fi

# property
resetprop -n ro.audio.ignore_effects false
resetprop -n ro.product.brand motorola
resetprop -p --delete persist.vendor.audio_fx.current
resetprop -n persist.vendor.audio_fx.current dolby
resetprop -n ro.vendor.dolby.dax.version DS1_2.3.0.0_r1
resetprop -n ro.dolby.mod_uuid false
resetprop -n ro.dolby.music_stream false
resetprop -n vendor.audio.dolby.ds2.enabled true
resetprop -n vendor.audio.dolby.ds2.hardbypass true

# restart
if [ "$API" -ge 24 ]; then
  SERVER=audioserver
else
  SERVER=mediaserver
fi
killall $SERVER\
 android.hardware.audio@4.0-service-mediatek\
 android.hardware.audio.service

# stop
NAMES="dms-hal-1-0 dms-hal-2-0"
for NAME in $NAMES; do
  if [ "`getprop init.svc.$NAME`" == running ]\
  || [ "`getprop init.svc.$NAME`" == restarting ]; then
    stop $NAME
  fi
done

# mount
DIR=/odm/bin/hw
FILES=$DIR/vendor.dolby.hardware.dms@2.0-service
if [ "`realpath $DIR`" == $DIR ]; then
  for FILE in $FILES; do
    MODFILE=$MODPATH$MODSYSTEM/vendor$FILE
    if [ -f $FILE ]; then
      if $NOMOUNT; then
        $NM del $FILE 2>/dev/null || true
        $NM add $FILE $MODFILE
      else
        umount $FILE
        mount -o bind $MODFILE $FILE
      fi
    fi
  done
fi

# permission
chmod 0755 $MODPATH$MODSYSTEM/vendor/bin/hw/*
chown 0.2000 $MODPATH$MODSYSTEM/vendor/bin/hw/*

# run
SERVICES=`realpath /vendor`/bin/hw/vendor.dolby.hardware.dms@1.0-service
for SERVICE in $SERVICES; do
  killall $SERVICE
  $SERVICE &
  PID=`pidof $SERVICE`
done

# wait
until [ "`getprop sys.boot_completed`" == 1 ]; do
  sleep 10
done

# list
PKGS=`cat $MODPATH/package.txt`
for PKG in $PKGS; do
  magisk --denylist rm $PKG 2>/dev/null
  magisk --sulist add $PKG 2>/dev/null
done
if magisk magiskhide sulist; then
  for PKG in $PKGS; do
    magisk magiskhide add $PKG
  done
else
  for PKG in $PKGS; do
    magisk magiskhide rm $PKG
  done
fi

# grant
PKG=com.motorola.dolby.dolbyui
if appops get $PKG >/dev/null 2>&1; then
  pm grant --all-permissions $PKG
  appops set $PKG SYSTEM_ALERT_WINDOW allow
  if [ "$API" -ge 30 ]; then
    appops set $PKG AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore
  fi
  PKGOPS=`appops get $PKG`
  UID=`grep "^$PKG " /data/system/packages.list | awk '{print $2}'`
  if [ "$UID" ] && [ "$UID" -gt 9999 ]; then
    UIDOPS=`appops get --uid "$UID"`
  fi
fi

# grant
PKG=com.dolby.daxservice
if appops get $PKG >/dev/null 2>&1; then
  pm grant --all-permissions $PKG
  if [ "$API" -ge 30 ]; then
    appops set $PKG AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore
  fi
  PKGOPS=`appops get $PKG`
  UID=`grep "^$PKG " /data/system/packages.list | awk '{print $2}'`
  if [ "$UID" ] && [ "$UID" -gt 9999 ]; then
    UIDOPS=`appops get --uid "$UID"`
  fi
fi

# function
stop_log() {
SIZE=`du $LOGFILE | sed "s|$LOGFILE||g"`
if [ "$LOG" != stopped ] && [ "$SIZE" -gt 50 ]; then
  exec 2>/dev/null
  set +x
  LOG=stopped
fi
}
check_audioserver() {
if [ "$NEXTPID" ]; then
  PID=$NEXTPID
else
  PID=`pidof $SERVER`
fi
sleep 15
stop_log
NEXTPID=`pidof $SERVER`
[ "$PID" != "$NEXTPID" ] && killall $PROC
check_audioserver
}

# check
for SERVICE in $SERVICES; do
  if ! pidof $SERVICE; then
    $SERVICE &
    PID=`pidof $SERVICE`
  fi
done
PROC=com.dolby.daxservice
killall $PROC
check_audioserver










