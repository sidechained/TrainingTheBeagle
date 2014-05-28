TUTORIAL: Cloning SD Cards

\TODO/
> basically complete, but needs testing and tidying up
> could add section on flashing an SD card to the beaglebone internal memory (eMMC) - something I've been interested to do but never tried, pros and cons are:
++ would speed up boot process (useful if the devices crash out in performance)
++ would mean we don’t need to have SD cards for each device
-- may make it harder to revert to stock image

- this document covers two procedures for cloning SD cards
- cloning is generally a slow process, so is not advisable in time critical situations
- for us so far, cloning has been useful in two situations:
- 1. creating a modified debian image which has all the software we need already installed
- e.g. in our case debian + bbio + supercollider + jack + pyOSC, etc
- 2. when scaling up a project which uses many beaglebones
- we used this method at first to ensure that all the beagles in RebDev/Chinese Whispers were identical
- however as it is very time consuming, any mistakes can be costly
- a better alternative here is to create a bash install/uninstall script (see separate tutorial)

* Method 1: Difficult But Fast(isn)

- put the sd card into a SD card reader on a PC, then:
$ distil list
- unmount existing volumes:
$ diskutil unmount /Volumes/boot
$ diskutil unmount /Volumes/rootfs
$ diskutil unmount /Volumes/Untitled
- remount the partition we want:
$ diskutil mount /dev/disk1s2
- (or just use the existing mount point as the target)
- go into the rootfs folder and backup the contents:
$ cd /Volumes/rootfs
$ sudo tar -zcvf ~/rootfs.tar.gz .
- If you use TAR, make sure you use the p option, which copies the file permissions e.g. tar cvjpf
- got error "tar: Error exit delayed from previous errors."
- What this means is that tar hit errors which were not bad enough for tar to fail immediately on hitting the error. tar kept going. Then when tar ends it says that it had errors but managed to run to completion.
- destination drive must have a similar partition structure, did this by flashing original Debian Wheezy image onto freshly formatted card using Pi Filler
- advice on how to use linux-dev/tools/install_image.sh script, but didn't work for me:
https://groups.google.com/forum/?fromgroups#!searchin/beagleboard/backup$20sd$20card/beagleboard/X7XDd3BCz40/KKRKmsWQH4AJ
- to reinstate:
$ sudo tar -xzvf rootfs.tar.gz -C /Volumes/rootfs
- Q: need hyphen here or not?

* Method 2: Easy but Slow

- If the destination card is the same size, then an easy (but slower) way is to use the unix dd command.
- Read from the device, not the partition, so you get partition table for free.
- firstly, insert the original card (don't mount it). I'm assuming it /dev/sdc:
$ dd if=/dev/disk1 of=/Volumes/Master/card_image.dmg
- Pull the original, and insert the destination card
- WARNING: This will overwrite /dev/disk1, so triple check this is correct
$ dd if=/Volumes/Master/card_image.dmg of=/dev/disk1






