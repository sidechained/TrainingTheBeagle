## Backup and Restore

This document covers various approaches to:
* backing up your beaglebone SD card to a disk image
* restoring the image back to an SD card

Backing up can be useful at various stages of a complex installation process e.g. as covered [here](https://github.com/sidechained/TrainingTheBeagle/blob/master/Tutorials/_essential/installation.txt)
* for all the methods below you will need to remove the micro SD card from your beaglebone and find a way to insert it in your PC (i.e. using a card reader, or micro to full size SD card adapter)

Restoring from a disk image completely overwrites the card, replacing the operating system, software and settings.

* for multi-beagle installations, restoring from the same image can be a useful way to ensure that each beagle is running the same software
* however, restoring multiple SD cards takes a long time, so if you just want to add or remove files to multiple beagleboards, a better approach here might be to create a bash install/uninstall script (see separate tutorial [here](TODO))

### Method 1. Using A Third Party Tool

#### Backing Up

* The easiest approach is to use PiCopier, which also works well for backing up beaglebone images
* See: http://ivanx.com/raspberrypi/

#### Restoring

Q: How to restore using this approach?

### Method 2. Using the Unix 'dd' command

NOTE: This method has only been tested on Mac OSX and uses .dmg images. Some modification to the following procedure may be required for linux systems.

If the destination sd card is the same size as the source sd card, then an easy (but slow) way is to use the unix 'dd' command to make a disk image of the whole card. Reading from the device (e.g. /dev/disk1), not the partition (e.g. /dev/disk1s2) gives us the partition table for free. This is an easy but slow process, which guarantees an exact clone of the original sd card, though some care is required when restoring the image to avoid accidentally overwriting the wrong volume. NOTE: To minimise this risk it is recommended to eject all external hard drives before proceeding.

#### Backing Up

__NOTE:__ $ diskutil list may be a better approach than $ ls | grep disk
__NOTE:__ unmounting may not be necessary, I followed the guide without unmounting boot and rootfs first and it seemed to work fine

* Firstly, we need to know the device name that the sd card is given when it is inserted. Before inserting the card, perform the following command:
`$ ls | grep disk`  
* Make a note of the entries that begin with 'disk'. Typically, if no other drives are connected you should only see disk0 and it's associated partitions (disk0s1, disk0s2 etc). Entries named 'rdisk' can be ignored.
* Now insert the sd card, wait a few seconds, and perform the same command again:
`$ ls | grep disk`
* Make a note of which disk has been added (typically this would be disk1)
* Now check to see if your sd card was mounted automatically when it was inserted:
`$ cd /Volumes; ls`  
* If the 'boot' or 'rootfs' volume names appear in the list, unmount them as follows:
`$ diskutil unmount /Volumes/boot`  
`$ diskutil unmount /Volumes/rootfs`  
* Now check if they have been unmounted successfully (boot and rootfs should no longer be in the list)
`$ ls`
* Back up the sd card to an image (replacing disk? with the actual name of your sd card's device as found above, and putting your image in an appropriate place i.e. not necessarily ion '~/Desktop'):
`$ sudo dd if=/dev/disk? of=~/Desktop/myBeagleboneImage.dmg`
* At the prompt, enter your password, then wait for the backup to complete (will take a while, and no indication of progress is given)
* If you want to be sure the image is as it should be you can check it's size to see if matches your sd card size, and/or open the dog
	
#### Restoring

* To restore the disk image to an sd card, we again need to find out the device name that the sd card is given when it is inserted (this can potentially be skipped if you are restoring directly after backing up).
`$ ls | grep disk`  
* Make a note of the entries that begin with 'disk'. Typically, if no other drives are connected you should only see disk0 and it's associated partitions (disk0s1, disk0s2 etc)
* Now insert the sd card, and perform the same command again:
'$ ls | grep disk'
* Note which disk has been added, this is the name (typically this would be disk1) 
* WARNING: The next command will completely overwrite the device, so it pays to triple check that the device name is correct (i.e. make sure it's not your computer's main hard drive!)
`$ dd if=~/DesktopmyBeagleboneImage.dmg of=/dev/disk?`

### Method 3. Backing up the rootfs partition

If your destination sd card is not the same size as your source sd card, then taking an image of the whole volume will not work. One approach in this case is just to back up the rootfs partition of your sd card, and overwrite. This approach is faster than the above method 2...

#### Backing Up

* Insert the sd card into your PC, then check if the boot partition was mounted automatically:
`$ cd /Volumes; ls`
* If the 'boot' partition appear in the list, unmount it as follows:
`$ diskutil unmount /Volumes/boot`  
* A message similar to 'Volume boot on disk1s1 unmounted' should appear
* Backup the contents of the rootfs partition
NOTE: the p option, which copies the file permissions e.g. `$ tar cvjpf`
`$ sudo tar -zcvf /Volumes/rootfs/ ~/Desktop/myBeagleRootfsImage.tar.gz .`
* got error `"tar: Error exit delayed from previous errors."`
* What this means is that tar hit errors which were not bad enough for tar to fail immediately on hitting the error. tar kept going. Then when tar ends it says that it had errors but managed to run to completion.
* destination drive must have a similar partition structure, did this by restoring original Debian Wheezy image onto freshly formatted card using Pi Filler

#### Restoring

`$ sudo tar -xzvf rootfs.tar.gz -C /Volumes/rootfs`
* _Q: need hyphen here or not?_

### Links

* Some advice on a possible alternative approach using linux-dev/tools/install_image.sh script, (didn't work for me):
https://groups.google.com/forum/?fromgroups#!searchin/beagleboard/backup$20sd$20card/beagleboard/X7XDd3BCz40/KKRKmsWQH4AJ





