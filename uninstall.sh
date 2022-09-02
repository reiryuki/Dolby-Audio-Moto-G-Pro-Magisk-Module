mount -o rw,remount /data
MODPATH=${0%/*}
MODID=`echo "$MODPATH" | sed -n -e 's/\/data\/adb\/modules\///p'`
APP="`ls $MODPATH/system/priv-app` `ls $MODPATH/system/app`"
PKG="com.motorola.dolby.dolbyui
     com.dolby.daxservice
     com.motorola.motosignature.app"
     
# cleaning
for PKGS in $PKG; do
  rm -rf /data/user/*/$PKGS
done
for APPS in $APP; do
  rm -f `find /data/system/package_cache -type f -name *$APPS*`
  rm -f `find /data/dalvik-cache /data/resource-cache -type f -name *$APPS*.apk`
done
rm -rf /metadata/magisk/"$MODID"
rm -rf /mnt/vendor/persist/magisk/"$MODID"
rm -rf /persist/magisk/"$MODID"
rm -rf /data/unencrypted/magisk/"$MODID"
rm -rf /cache/magisk/"$MODID"
rm -f /data/vendor/media/dax_sqlite3.db
rm -rf /data/vendor/dolby
resetprop -p --delete persist.vendor.audio_fx.current

# boot mode
if [ ! "$BOOTMODE" ]; then
  [ -z $BOOTMODE ] && ps | grep zygote | grep -qv grep && BOOTMODE=true
  [ -z $BOOTMODE ] && ps -A | grep zygote | grep -qv grep && BOOTMODE=true
  [ -z $BOOTMODE ] && BOOTMODE=false
fi

# magisk
if [ ! "$MAGISKTMP" ]; then
  if [ -d /sbin/.magisk ]; then
    MAGISKTMP=/sbin/.magisk
  else
    MAGISKTMP=`find /dev -mindepth 2 -maxdepth 2 -type d -name .magisk`
  fi
fi

# function
grep_cmdline() {
REGEX="s/^$1=//p"
cat /proc/cmdline | tr '[:space:]' '\n' | sed -n "$REGEX"
}
set_read_write() {
for NAMES in $NAME; do
  blockdev --setrw $DIR$NAMES
done
}

# slot
if [ ! "$SLOT" ]; then
  SLOT=`grep_cmdline androidboot.slot_suffix`
  if [ -z $SLOT ]; then
    SLOT=`grep_cmdline androidboot.slot`
    [ -z $SLOT ] || SLOT=_${SLOT}
  fi
fi

# remount
DIR=/dev/block/bootdevice/by-name
NAME="/vendor$SLOT /cust$SLOT /system$SLOT /system_ext$SLOT"
set_read_write
DIR=/dev/block/mapper
set_read_write
DIR=$MAGISKTMP/block
NAME="/vendor /system_root /system /system_ext"
set_read_write
mount -o rw,remount $MAGISKTMP/mirror/system
mount -o rw,remount $MAGISKTMP/mirror/system_root
mount -o rw,remount $MAGISKTMP/mirror/system_ext
mount -o rw,remount $MAGISKTMP/mirror/vendor
mount -o rw,remount /system
mount -o rw,remount /
mount -o rw,remount /system_root
mount -o rw,remount /system_ext
mount -o rw,remount /vendor

# function
restore() {
for FILES in $FILE; do
  if [ -f $FILES.orig ]; then
    mv -f $FILES.orig $FILES
  fi
  if [ -f $FILES.bak ]; then
    mv -f $FILES.bak $FILES
  fi
done
}

# restore
FILE="$MAGISKTMP/mirror/*/etc/vintf/manifest.xml
      $MAGISKTMP/mirror/*/*/etc/vintf/manifest.xml
      /*/etc/vintf/manifest.xml /*/*/etc/vintf/manifest.xml
      $MAGISKTMP/mirror/*/etc/selinux/*_hwservice_contexts
      $MAGISKTMP/mirror/*/*/etc/selinux/*_hwservice_contexts
      /*/etc/selinux/*_hwservice_contexts /*/*/etc/selinux/*_hwservice_contexts
      $MAGISKTMP/mirror/*/etc/selinux/*_file_contexts
      $MAGISKTMP/mirror/*/*/etc/selinux/*_file_contexts
      /*/etc/selinux/*_file_contexts /*/*/etc/selinux/*_file_contexts"
restore

# remount
if [ "$BOOTMODE" == true ]; then
  mount -o ro,remount $MAGISKTMP/mirror/system
  mount -o ro,remount $MAGISKTMP/mirror/system_root
  mount -o ro,remount $MAGISKTMP/mirror/system_ext
  mount -o ro,remount $MAGISKTMP/mirror/vendor
  mount -o ro,remount /system
  mount -o ro,remount /
  mount -o ro,remount /system_root
  mount -o ro,remount /system_ext
  mount -o ro,remount /vendor
fi


