MODPATH=${0%/*}

# log
LOGFILE=$MODPATH/debug.log
exec 2>$LOGFILE
set -x

# var
API=`getprop ro.build.version.sdk`

# property
resetprop -n ro.audio.ignore_effects false
resetprop -n ro.product.brand motorola
resetprop -p --delete persist.vendor.audio_fx.current
resetprop -n persist.vendor.audio_fx.current dolby
resetprop -n ro.vendor.dolby.dax.version DS1_2.3.0.0_r1
resetprop -n ro.dolby.mod_uuid false
resetprop -n vendor.audio.dolby.ds2.enabled true
resetprop -n vendor.audio.dolby.ds2.hardbypass true

# restart
if [ "$API" -ge 24 ]; then
  SERVER=audioserver
else
  SERVER=mediaserver
fi
killall $SERVER\
 android.hardware.audio@4.0-service-mediatek

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
    if [ -f $FILE ]; then
      if [ -L $MODPATH/system/vendor ]\
      && [ -d $MODPATH/vendor ]; then
        mount -o bind $MODPATH/vendor$FILE $FILE
      else
        mount -o bind $MODPATH/system/vendor$FILE $FILE
      fi
    fi
  done
fi

# run
SERVICES=`realpath /vendor`/bin/hw/vendor.dolby.hardware.dms@1.0-service
for SERVICE in $SERVICES; do
  killall $SERVICE
  if ! stat -c %a $SERVICE | grep -E '755|775|777|757'\
  || [ "`stat -c %u.%g $SERVICE`" != 0.2000 ]; then
    mount -o remount,rw $SERVICE
    chmod 0755 $SERVICE
    chown 0.2000 $SERVICE
  fi
  $SERVICE &
  PID=`pidof $SERVICE`
done

# restart
killall vendor.qti.hardware.vibrator.service\
 vendor.qti.hardware.vibrator.service.oneplus9\
 vendor.qti.hardware.vibrator.service.oplus\
 android.hardware.camera.provider@2.4-service_64\
 vendor.mediatek.hardware.mtkpower@1.0-service\
 android.hardware.usb@1.0-service\
 android.hardware.usb@1.0-service.basic\
 android.hardware.light-service.mt6768\
 android.hardware.lights-service.xiaomi_mithorium\
 vendor.samsung.hardware.light-service\
 vendor.qti.hardware.lights.service\
 android.hardware.health-service.qti
#skillall vendor.qti.hardware.display.allocator-service\
#s vendor.qti.hardware.display.composer-service\
#s camerahalserver
#xkillall android.hardware.sensors@1.0-service\
#x android.hardware.sensors@2.0-service\
#x android.hardware.sensors@2.0-service-mediatek\
#x android.hardware.sensors@2.0-service.multihal\
#x android.hardware.sensors@2.0-service.multihal-mediatek

# wait
sleep 20

# aml fix
AML=/data/adb/modules/aml
if [ -L $AML/system/vendor ]\
&& [ -d $AML/vendor ]; then
  DIR=$AML/vendor/odm/etc
else
  DIR=$AML/system/vendor/odm/etc
fi
if [ -d $DIR ] && [ ! -f $AML/disable ]; then
  chcon -R u:object_r:vendor_configs_file:s0 $DIR
fi
AUD=`grep AUD= $MODPATH/copy.sh | sed -e 's|AUD=||g' -e 's|"||g'`
if [ -L $AML/system/vendor ]\
&& [ -d $AML/vendor ]; then
  DIR=$AML/vendor
else
  DIR=$AML/system/vendor
fi
FILES=`find $DIR -type f -name $AUD`
if [ -d $AML ] && [ ! -f $AML/disable ]\
&& find $DIR -type f -name $AUD; then
  if ! grep '/odm' $AML/post-fs-data.sh && [ -d /odm ]\
  && [ "`realpath /odm/etc`" == /odm/etc ]; then
    for FILE in $FILES; do
      DES=/odm`echo $FILE | sed "s|$DIR||g"`
      if [ -f $DES ]; then
        umount $DES
        mount -o bind $FILE $DES
      fi
    done
  fi
  if ! grep '/my_product' $AML/post-fs-data.sh\
  && [ -d /my_product ]; then
    for FILE in $FILES; do
      DES=/my_product`echo $FILE | sed "s|$DIR||g"`
      if [ -f $DES ]; then
        umount $DES
        mount -o bind $FILE $DES
      fi
    done
  fi
fi

# wait
until [ "`getprop sys.boot_completed`" == 1 ]; do
  sleep 10
done

# grant
PKG=com.motorola.dolby.dolbyui
if [ "$API" -ge 33 ]; then
  pm grant $PKG android.permission.POST_NOTIFICATIONS
fi
if [ "$API" -ge 31 ]; then
  pm grant $PKG android.permission.BLUETOOTH_CONNECT
fi
appops set $PKG SYSTEM_ALERT_WINDOW allow
if [ "$API" -ge 30 ]; then
  appops set $PKG AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore
fi
PKGOPS=`appops get $PKG`
UID=`dumpsys package $PKG 2>/dev/null | grep -m 1 Id= | sed -e 's|    userId=||g' -e 's|    appId=||g'`
if [ "$UID" ] && [ "$UID" -gt 9999 ]; then
  UIDOPS=`appops get --uid "$UID"`
fi

# grant
PKG=com.dolby.daxservice
pm grant $PKG android.permission.READ_EXTERNAL_STORAGE
pm grant $PKG android.permission.WRITE_EXTERNAL_STORAGE
if [ "$API" -ge 31 ]; then
  pm grant $PKG android.permission.BLUETOOTH_CONNECT
fi
if [ "$API" -ge 30 ]; then
  appops set $PKG AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore
fi
PKGOPS=`appops get $PKG`
UID=`dumpsys package $PKG 2>/dev/null | grep -m 1 Id= | sed -e 's|    userId=||g' -e 's|    appId=||g'`
if [ "$UID" ] && [ "$UID" -gt 9999 ]; then
  UIDOPS=`appops get --uid "$UID"`
fi

# audio flinger
DMAF=`dumpsys media.audio_flinger`

# function
stop_log() {
SIZE=`du $LOGFILE | sed "s|$LOGFILE||g"`
if [ "$LOG" != stopped ] && [ "$SIZE" -gt 75 ]; then
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
if [ "`getprop init.svc.$SERVER`" != stopped ]; then
  [ "$PID" != "$NEXTPID" ] && killall $PROC
else
  start $SERVER
fi
check_audioserver
}

# check
for SERVICE in $SERVICES; do
  if ! pidof $SERVICE; then
    $SERVICE &
    PID=`pidof $SERVICE`
  fi
done
PROC="com.dolby.daxservice com.motorola.dolby.dolbyui"
killall $PROC
check_audioserver










