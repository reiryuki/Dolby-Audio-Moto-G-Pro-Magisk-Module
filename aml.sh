[ ! "$MODPATH" ] && MODPATH=${0%/*}

# destination
[ ! "$libdir" ] && libdir=/vendor
MODAEC=`find $MODPATH -type f -name *audio*effects*.conf`
MODAEX=`find $MODPATH -type f -name *audio*effects*.xml`
MODAP=`find $MODPATH -type f -name *policy*.conf -o -name *policy*.xml`

# function
archdir() {
if [ -f $libdir/lib/soundfx/$LIB ]\
|| [ -f $MODPATH/system$libdir/lib/soundfx/$LIB ]\
|| [ -f $MODPATH$libdir/lib/soundfx/$LIB ]; then
  ARCHDIR=/lib
else
  ARCHDIR=/lib64
fi
}
remove_conf() {
for RMV in $RMVS; do
  sed -i "s|$RMV|removed|g" $MODAEC
done
sed -i 's|path /vendor/lib/soundfx/removed||g' $MODAEC
sed -i 's|path /system/lib/soundfx/removed||g' $MODAEC
sed -i 's|path /vendor/lib/removed||g' $MODAEC
sed -i 's|path /system/lib/removed||g' $MODAEC
sed -i 's|path /vendor/lib64/soundfx/removed||g' $MODAEC
sed -i 's|path /system/lib64/soundfx/removed||g' $MODAEC
sed -i 's|path /vendor/lib64/removed||g' $MODAEC
sed -i 's|path /system/lib64/removed||g' $MODAEC
sed -i 's|library removed||g' $MODAEC
sed -i 's|uuid removed||g' $MODAEC
sed -i "/^        removed {/ {;N s/        removed {\n        }//}" $MODAEC
sed -i 's|removed { }||g' $MODAEC
sed -i 's|removed {}||g' $MODAEC
}
remove_xml() {
for RMV in $RMVS; do
  sed -i "s|\"$RMV\"|\"removed\"|g" $MODAEX
done
sed -i 's|<library name="removed" path="removed"/>||g' $MODAEX
sed -i 's|<library name="proxy" path="removed"/>||g' $MODAEX
sed -i 's|<effect name="removed" library="removed" uuid="removed"/>||g' $MODAEX
sed -i 's|<effect name="removed" uuid="removed" library="removed"/>||g' $MODAEX
sed -i 's|<libsw library="removed" uuid="removed"/>||g' $MODAEX
sed -i 's|<libhw library="removed" uuid="removed"/>||g' $MODAEX
sed -i 's|<apply effect="removed"/>||g' $MODAEX
sed -i 's|<library name="removed" path="removed" />||g' $MODAEX
sed -i 's|<library name="proxy" path="removed" />||g' $MODAEX
sed -i 's|<effect name="removed" library="removed" uuid="removed" />||g' $MODAEX
sed -i 's|<effect name="removed" uuid="removed" library="removed" />||g' $MODAEX
sed -i 's|<libsw library="removed" uuid="removed" />||g' $MODAEX
sed -i 's|<libhw library="removed" uuid="removed" />||g' $MODAEX
sed -i 's|<apply effect="removed" />||g' $MODAEX
}

# store
RMVS="ring_helper alarm_helper music_helper voice_helper
      notification_helper ma_ring_helper ma_alarm_helper
      ma_music_helper ma_voice_helper ma_system_helper
      ma_notification_helper sa3d fens lmfv dirac dtsaudio
      dlb_music_listener dlb_ring_listener dlb_alarm_listener
      dlb_system_listener dlb_notification_listener"

# setup audio effects conf
if [ "$MODAEC" ]; then
  for RMV in $RMVS; do
    sed -i "/^        $RMV {/ {;N s/        $RMV {\n        }//}" $MODAEC
    sed -i "s|$RMV { }||g" $MODAEC
    sed -i "s|$RMV {}||g" $MODAEC
  done
  if ! grep -q '^output_session_processing {' $MODAEC; then
    sed -i -e '$a\
\
output_session_processing {\
    music {\
    }\
    ring {\
    }\
    alarm {\
    }\
    system {\
    }\
    voice_call {\
    }\
    notification {\
    }\
    bluetooth_sco {\
    }\
    dtmf {\
    }\
    enforced_audible {\
    }\
    accessibility {\
    }\
    tts {\
    }\
    assistant {\
    }\
    call_assistant {\
    }\
    patch {\
    }\
    rerouting {\
    }\
}\' $MODAEC
  else
    if ! grep -q '^    rerouting {' $MODAEC; then
      sed -i "/^output_session_processing {/a\    rerouting {\n    }" $MODAEC
    fi
    if ! grep -q '^    patch {' $MODAEC; then
      sed -i "/^output_session_processing {/a\    patch {\n    }" $MODAEC
    fi
    if ! grep -q '^    call_assistant {' $MODAEC; then
      sed -i "/^output_session_processing {/a\    call_assistant {\n    }" $MODAEC
    fi
    if ! grep -q '^    assistant {' $MODAEC; then
      sed -i "/^output_session_processing {/a\    assistant {\n    }" $MODAEC
    fi
    if ! grep -q '^    tts {' $MODAEC; then
      sed -i "/^output_session_processing {/a\    tts {\n    }" $MODAEC
    fi
    if ! grep -q '^    accessibility {' $MODAEC; then
      sed -i "/^output_session_processing {/a\    accessibility {\n    }" $MODAEC
    fi
    if ! grep -q '^    enforced_audible {' $MODAEC; then
      sed -i "/^output_session_processing {/a\    enforced_audible {\n    }" $MODAEC
    fi
    if ! grep -q '^    dtmf {' $MODAEC; then
      sed -i "/^output_session_processing {/a\    dtmf {\n    }" $MODAEC
    fi
    if ! grep -q '^    bluetooth_sco {' $MODAEC; then
      sed -i "/^output_session_processing {/a\    bluetooth_sco {\n    }" $MODAEC
    fi
    if ! grep -q '^    notification {' $MODAEC; then
      sed -i "/^output_session_processing {/a\    notification {\n    }" $MODAEC
    fi
    if ! grep -q '^    voice_call {' $MODAEC; then
      sed -i "/^output_session_processing {/a\    voice_call {\n    }" $MODAEC
    fi
    if ! grep -q '^    system {' $MODAEC; then
      sed -i "/^output_session_processing {/a\    system {\n    }" $MODAEC
    fi
    if ! grep -q '^    alarm {' $MODAEC; then
      sed -i "/^output_session_processing {/a\    alarm {\n    }" $MODAEC
    fi
    if ! grep -q '^    ring {' $MODAEC; then
      sed -i "/^output_session_processing {/a\    ring {\n    }" $MODAEC
    fi
    if ! grep -q '^    music {' $MODAEC; then
      sed -i "/^output_session_processing {/a\    music {\n    }" $MODAEC
    fi
  fi
fi

# setup audio effects xml
if [ "$MODAEX" ]; then
  for RMV in $RMVS; do
    sed -i "s|<apply effect=\"$RMV\"/>||g" $MODAEX
    sed -i "s|<apply effect=\"$RMV\" />||g" $MODAEX
  done
  if ! grep -q '<postprocess>' $MODAEX\
  || grep -q '<!-- Audio post processor' $MODAEX; then
    sed -i '/<\/effects>/a\
    <postprocess>\
        <stream type="music">\
        <\/stream>\
        <stream type="ring">\
        <\/stream>\
        <stream type="alarm">\
        <\/stream>\
        <stream type="system">\
        <\/stream>\
        <stream type="voice_call">\
        <\/stream>\
        <stream type="notification">\
        <\/stream>\
        <stream type="bluetooth_sco">\
        <\/stream>\
        <stream type="dtmf">\
        <\/stream>\
        <stream type="enforced_audible">\
        <\/stream>\
        <stream type="accessibility">\
        <\/stream>\
        <stream type="tts">\
        <\/stream>\
        <stream type="assistant">\
        <\/stream>\
        <stream type="call_assistant">\
        <\/stream>\
        <stream type="patch">\
        <\/stream>\
        <stream type="rerouting">\
        <\/stream>\
    <\/postprocess>' $MODAEX
  else
    if ! grep -q '<stream type="rerouting">' $MODAEX; then
      sed -i "/<postprocess>/a\        <stream type=\"rerouting\">\n        <\/stream>" $MODAEX
    fi
    if ! grep -q '<stream type="patch">' $MODAEX; then
      sed -i "/<postprocess>/a\        <stream type=\"patch\">\n        <\/stream>" $MODAEX
    fi
    if ! grep -q '<stream type="call_assistant">' $MODAEX; then
      sed -i "/<postprocess>/a\        <stream type=\"call_assistant\">\n        <\/stream>" $MODAEX
    fi
    if ! grep -q '<stream type="assistant">' $MODAEX; then
      sed -i "/<postprocess>/a\        <stream type=\"assistant\">\n        <\/stream>" $MODAEX
    fi
    if ! grep -q '<stream type="tts">' $MODAEX; then
      sed -i "/<postprocess>/a\        <stream type=\"tts\">\n        <\/stream>" $MODAEX
    fi
    if ! grep -q '<stream type="accessibility">' $MODAEX; then
      sed -i "/<postprocess>/a\        <stream type=\"accessibility\">\n        <\/stream>" $MODAEX
    fi
    if ! grep -q '<stream type="enforced_audible">' $MODAEX; then
      sed -i "/<postprocess>/a\        <stream type=\"enforced_audible\">\n        <\/stream>" $MODAEX
    fi
    if ! grep -q '<stream type="dtmf">' $MODAEX; then
      sed -i "/<postprocess>/a\        <stream type=\"dtmf\">\n        <\/stream>" $MODAEX
    fi
    if ! grep -q '<stream type="bluetooth_sco">' $MODAEX; then
      sed -i "/<postprocess>/a\        <stream type=\"bluetooth_sco\">\n        <\/stream>" $MODAEX
    fi
    if ! grep -q '<stream type="notification">' $MODAEX\
    || grep -q '<!-- YunMang.Xiao@PSW.MM.Dolby' $MODAEX\
    || grep -q '<!-- WuHao@MULTIMEDIA.AUDIOSERVER.EFFECT' $MODAEX; then
      sed -i "/<postprocess>/a\        <stream type=\"notification\">\n        <\/stream>" $MODAEX
    fi
    if ! grep -q '<stream type="voice_call">' $MODAEX; then
      sed -i "/<postprocess>/a\        <stream type=\"voice_call\">\n        <\/stream>" $MODAEX
    fi
    if ! grep -q '<stream type="system">' $MODAEX; then
      sed -i "/<postprocess>/a\        <stream type=\"system\">\n        <\/stream>" $MODAEX
    fi
    if ! grep -q '<stream type="alarm">' $MODAEX\
    || grep -q '<!-- YunMang.Xiao@PSW.MM.Dolby' $MODAEX\
    || grep -q '<!-- WuHao@MULTIMEDIA.AUDIOSERVER.EFFECT' $MODAEX; then
      sed -i "/<postprocess>/a\        <stream type=\"alarm\">\n        <\/stream>" $MODAEX
    fi
    if ! grep -q '<stream type="ring">' $MODAEX\
    || grep -q '<!-- YunMang.Xiao@PSW.MM.Dolby' $MODAEX\
    || grep -q '<!-- WuHao@MULTIMEDIA.AUDIOSERVER.EFFECT' $MODAEX; then
      sed -i "/<postprocess>/a\        <stream type=\"ring\">\n        <\/stream>" $MODAEX
    fi
    if ! grep -q '<stream type="music">' $MODAEX\
    || grep -q '<!-- YunMang.Xiao@PSW.MM.Dolby' $MODAEX\
    || grep -q '<!-- WuHao@MULTIMEDIA.AUDIOSERVER.EFFECT' $MODAEX; then
      sed -i "/<postprocess>/a\        <stream type=\"music\">\n        <\/stream>" $MODAEX
    fi
  fi
fi

# function
dap() {
# store
LIB=libswdap.so
LIBNAME=dap
LIBNAME=dap_mod
NAME=dap
NAME=dap_mod
UUID=9d4921da-8225-4f29-aefa-39537a04bcaa
RMVS="$LIB $LIBNAME $NAME $UUID"
archdir
# patch audio effects conf
if [ "$MODAEC" ]; then
  remove_conf
  sed -i "/^libraries {/a\  $LIBNAME {\n    path \\$libdir\\$ARCHDIR\/soundfx\/$LIB\n  }" $MODAEC
  sed -i "/^effects {/a\  $NAME {\n    library $LIBNAME\n    uuid $UUID\n  }" $MODAEC
#m  sed -i "/^    music {/a\        $NAME {\n        }" $MODAEC
#r  sed -i "/^    ring {/a\        $NAME {\n        }" $MODAEC
#a  sed -i "/^    alarm {/a\        $NAME {\n        }" $MODAEC
#s  sed -i "/^    system {/a\        $NAME {\n        }" $MODAEC
#v  sed -i "/^    voice_call {/a\        $NAME {\n        }" $MODAEC
#n  sed -i "/^    notification {/a\        $NAME {\n        }" $MODAEC
#b  sed -i "/^    bluetooth_sco {/a\        $NAME {\n        }" $MODAEC
#f  sed -i "/^    dtmf {/a\        $NAME {\n        }" $MODAEC
#e  sed -i "/^    enforced_audible {/a\        $NAME {\n        }" $MODAEC
#y  sed -i "/^    accessibility {/a\        $NAME {\n        }" $MODAEC
#t  sed -i "/^    tts {/a\        $NAME {\n        }" $MODAEC
#i  sed -i "/^    assistant {/a\        $NAME {\n        }" $MODAEC
#c  sed -i "/^    call_assistant {/a\        $NAME {\n        }" $MODAEC
#p  sed -i "/^    patch {/a\        $NAME {\n        }" $MODAEC
#g  sed -i "/^    rerouting {/a\        $NAME {\n        }" $MODAEC
fi
# patch effects xml
if [ "$MODAEX" ]; then
  remove_xml
  sed -i "/<libraries>/a\        <library name=\"$LIBNAME\" path=\"$LIB\"\/>" $MODAEX
  sed -i "/<effects>/a\        <effect name=\"$NAME\" library=\"$LIBNAME\" uuid=\"$UUID\"\/>" $MODAEX
#m  sed -i "/<stream type=\"music\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
#r  sed -i "/<stream type=\"ring\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
#a  sed -i "/<stream type=\"alarm\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
#s  sed -i "/<stream type=\"system\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
#v  sed -i "/<stream type=\"voice_call\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
#n  sed -i "/<stream type=\"notification\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
#b  sed -i "/<stream type=\"bluetooth_sco\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
#f  sed -i "/<stream type=\"dtmf\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
#e  sed -i "/<stream type=\"enforced_audible\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
#y  sed -i "/<stream type=\"accessibility\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
#t  sed -i "/<stream type=\"tts\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
#i  sed -i "/<stream type=\"assistant\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
#c  sed -i "/<stream type=\"call_assistant\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
#p  sed -i "/<stream type=\"patch\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
#g  sed -i "/<stream type=\"rerouting\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
fi
}
dvl() {
# store
LIB=libdlbvol.so
LIBNAME=dvl
NAME=dvl_music
UUID=40f66c8b-5aa5-4345-8919-53ec431aaa98
NAME2=dvl_ring
UUID2=21d14087-558a-4f21-94a9-5002dce64bce
NAME3=dvl_alarm
UUID3=6aff229c-30c6-4cc8-9957-dbfe5c1bd7f6
NAME4=dvl_system
UUID4=874db4d8-051d-4b7b-bd95-a3bebc837e9e
NAME5=dvl_notification
UUID5=1f0091e3-6ad8-40fe-9b09-5948f9a26e7e
RMVS="$LIB $LIBNAME $NAME $UUID $NAME2 $UUID2
      $NAME3 $UUID3 $NAME4 $UUID4 $NAME5 $UUID5"
archdir
# patch audio effects conf
if [ "$MODAEC" ]; then
  remove_conf
  sed -i "/^libraries {/a\  $LIBNAME {\n    path \\$libdir\\$ARCHDIR\/soundfx\/$LIB\n  }" $MODAEC
  sed -i "/^effects {/a\  $NAME {\n    library $LIBNAME\n    uuid $UUID\n  }" $MODAEC
#m  sed -i "/^    music {/a\        $NAME {\n        }" $MODAEC
  sed -i "/^effects {/a\  $NAME2 {\n    library $LIBNAME\n    uuid $UUID2\n  }" $MODAEC
#r  sed -i "/^    ring {/a\        $NAME2 {\n        }" $MODAEC
  sed -i "/^effects {/a\  $NAME3 {\n    library $LIBNAME\n    uuid $UUID3\n  }" $MODAEC
#a  sed -i "/^    alarm {/a\        $NAME3 {\n        }" $MODAEC
  sed -i "/^effects {/a\  $NAME4 {\n    library $LIBNAME\n    uuid $UUID4\n  }" $MODAEC
#s  sed -i "/^    system {/a\        $NAME4 {\n        }" $MODAEC
  sed -i "/^effects {/a\  $NAME5 {\n    library $LIBNAME\n    uuid $UUID5\n  }" $MODAEC
#n  sed -i "/^    notification {/a\        $NAME5 {\n        }" $MODAEC
fi
# patch effects xml
if [ "$MODAEX" ]; then
  remove_xml
  sed -i "/<libraries>/a\        <library name=\"$LIBNAME\" path=\"$LIB\"\/>" $MODAEX
  sed -i "/<effects>/a\        <effect name=\"$NAME\" library=\"$LIBNAME\" uuid=\"$UUID\"\/>" $MODAEX
#m  sed -i "/<stream type=\"music\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
  sed -i "/<effects>/a\        <effect name=\"$NAME2\" library=\"$LIBNAME\" uuid=\"$UUID2\"\/>" $MODAEX
#r  sed -i "/<stream type=\"ring\">/a\            <apply effect=\"$NAME2\"\/>" $MODAEX
  sed -i "/<effects>/a\        <effect name=\"$NAME3\" library=\"$LIBNAME\" uuid=\"$UUID3\"\/>" $MODAEX
#a  sed -i "/<stream type=\"alarm\">/a\            <apply effect=\"$NAME3\"\/>" $MODAEX
  sed -i "/<effects>/a\        <effect name=\"$NAME4\" library=\"$LIBNAME\" uuid=\"$UUID4\"\/>" $MODAEX
#s  sed -i "/<stream type=\"system\">/a\            <apply effect=\"$NAME4\"\/>" $MODAEX
  sed -i "/<effects>/a\        <effect name=\"$NAME5\" library=\"$LIBNAME\" uuid=\"$UUID5\"\/>" $MODAEX
#n  sed -i "/<stream type=\"notification\">/a\            <apply effect=\"$NAME5\"\/>" $MODAEX
fi
}

# effect
dap
#11dvl

# patch audio policy
#uif [ "$MODAP" ]; then
#u  sed -i 's|RAW|NONE|g' $MODAP
#u  sed -i 's|,raw||g' $MODAP
#ufi












