# Backup

- this document covers various approaches to:
1. backing up your beaglebone SD card to a disk image
2. restoring the image back to an SD card

## Backup

- backup is useful at various stages of a long, complex installation process i.e.:
-- https://github.com/sidechained/TrainingTheBeagle/blob/master/Tutorials/_essential/installation.txt

1. Using A Third Party Tool

- The easier approach is to use PiCopier
- This tool was made for the Raspberry Pi, but also works well for backing up beaglebone images
- See: http://ivanx.com/raspberrypi/

2. Unix, Difficult But Fast(isn)

put the sd card into a SD card reader on a PC, then:  
```$ diskutil list```
unmount existing volumes:  
```$ diskutil unmount /Volumes/boot```
```$ diskutil unmount /Volumes/rootfs```
    $ diskutil unmount /Volumes/Untitled
- remount the partition we want:  
    $ diskutil mount /dev/disk1s2
- (or just use the existing mount point as the target)
- go into the rootfs folder and backup the contents:
    $ cd /Volumes/rootfs
    $ sudo tar -zcvf ~/rootfs.tar.gz .
- If you use TAR, make sure you use the p option, which copies the file permissions e.g. `$ tar cvjpf`
- got error "tar: Error exit delayed from previous errors."
- What this means is that tar hit errors which were not bad enough for tar to fail immediately on hitting the error. tar kept going. Then when tar ends it says that it had errors but managed to run to completion.
- destination drive must have a similar partition structure, did this by restoring original Debian Wheezy image onto freshly formatted card using Pi Filler
- advice on how to use linux-dev/tools/install_image.sh script, but didn't work for me:
https://groups.google.com/forum/?fromgroups#!searchin/beagleboard/backup$20sd$20card/beagleboard/X7XDd3BCz40/KKRKmsWQH4AJ
- to reinstate:
    $ sudo tar -xzvf rootfs.tar.gz -C /Volumes/rootfs
- Q: need hyphen here or not?

3. Easy but Slow

- If the destination card is the same size, then an easy (but slower) way is to use the unix dd command.
- Read from the device, not the partition, so you get partition table for free.
- firstly, insert the original card (don't mount it). I'm assuming it /dev/sdc:
    $ dd if=/dev/disk1 of=/Volumes/Master/card_image.dmg
- Pull the original, and insert the destination card
- WARNING: This will overwrite /dev/disk1, so triple check this is correct
    $ dd if=/Volumes/Master/card_image.dmg of=/dev/disk1

## Restore

- restoring can be used to restore operating systems, software and settings
- for multi-beaglebone installations, it can be a useful way to ensure that each beagle is running the same software
- however, due to the time it takes to restore multiple SD cards
- if you just want to add or remove files to multiple beagleboards, a better approach here might be to create a bash install/uninstall script (see separate tutorial)

\TODO/




