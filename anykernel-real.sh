# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=ExampleKernel by osm0sis @ xda-developers
kernel.for=KernelForDriver
kernel.compiler=SDPG
kernel.made=User @Host
kernel.version=4.4.xxx
message.word=ooflol
build.date=2077
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=X00TD
device.name2=X00T
device.name3=Zenfone Max Pro M1 (X00TD)
device.name4=ASUS_X00TD
device.name5=ASUS_X00T
supported.versions=
supported.patchlevels=
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;


## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
set_perm_recursive 0 0 755 644 $ramdisk/*;
set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;


## AnyKernel install
dump_boot;

# begin ramdisk changes

# init.rc
backup_file init.rc;
replace_string init.rc "cpuctl cpu,timer_slack" "mount cgroup none /dev/cpuctl cpu" "mount cgroup none /dev/cpuctl cpu,timer_slack";

# init.tuna.rc
backup_file init.tuna.rc;
insert_line init.tuna.rc "nodiratime barrier=0" after "mount_all /fstab.tuna" "\tmount ext4 /dev/block/platform/omap/omap_hsmmc.0/by-name/userdata /data remount nosuid nodev noatime nodiratime barrier=0";
append_file init.tuna.rc "bootscript" init.tuna;

# fstab.tuna
backup_file fstab.tuna;
patch_fstab fstab.tuna /system ext4 options "noatime,barrier=1" "noatime,nodiratime,barrier=0";
patch_fstab fstab.tuna /cache ext4 options "barrier=1" "barrier=0,nomblk_io_submit";
patch_fstab fstab.tuna /data ext4 options "data=ordered" "nomblk_io_submit,data=writeback";
append_file fstab.tuna "usbdisk" fstab;

# remove spectrum profile
if [ -e $ramdisk/init.spectrum.rc ];then
  rm -rf $ramdisk/init.spectrum.rc
  ui_print "delete /init.spectrum.rc"
fi
if [ -e $ramdisk/init.spectrum.sh ];then
  rm -rf $ramdisk/init.spectrum.sh
  ui_print "delete /init.spectrum.sh"
fi
if [ -e $ramdisk/sbin/init.spectrum.rc ];then
  rm -rf $ramdisk/sbin/init.spectrum.rc
  ui_print "delete /sbin/init.spectrum.rc"
fi
if [ -e $ramdisk/sbin/init.spectrum.sh ];then
  rm -rf $ramdisk/sbin/init.spectrum.sh
  ui_print "delete /sbin/init.spectrum.sh"
fi
if [ -e $ramdisk/etc/init.spectrum.rc ];then
  rm -rf $ramdisk/etc/init.spectrum.rc
  ui_print "delete /etc/init.spectrum.rc"
fi
if [ -e $ramdisk/etc/init.spectrum.sh ];then
  rm -rf $ramdisk/etc/init.spectrum.sh
  ui_print "delete /etc/init.spectrum.sh"
fi
if [ -e $ramdisk/init.aurora.rc ];then
  rm -rf $ramdisk/init.aurora.rc
  ui_print "delete /init.aurora.rc"
fi
if [ -e $ramdisk/sbin/init.aurora.rc ];then
  rm -rf $ramdisk/sbin/init.aurora.rc
  ui_print "delete /sbin/init.aurora.rc"
fi
if [ -e $ramdisk/etc/init.aurora.rc ];then
  rm -rf $ramdisk/etc/init.aurora.rc
  ui_print "delete /etc/init.aurora.rc"
fi

# end ramdisk changes

write_boot;
## end install

