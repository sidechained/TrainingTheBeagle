_TODO: add traceroute example_  
_TODO: add lsof to 'terminating processes' section_  
_TODO: As this file now contains a lot of info, it now needs an introductory discussion of/pointer to 'the essentials'_

## Unix Lore

This is a primer covering most of the things you need to know about unix terminal commands to get started with the Beaglebone Black.

_NOTE: When mentioning keyboard shortcuts we refer to the Mac modifier key (i.e. CMD). If using a Linux system please substitute this for CTRL. Please note that there may also be other conventions we use that are also Mac specific (without realising it)_

Topic Index:  
[Basic Syntax](#basic-syntax)  
[Getting Help](#getting-help)  
[Moving Around the Command Line](#moving-around-the-command-line)  
[Clearing the Terminal Window](#clearing-the-terminal-window)  
[Navigation](#navigation)  
[File Management](#file-management)  
[Communicating with the Beaglebone](#communicating-with-the-beaglebone)  
[Terminating Processes](#terminating-processes)  
[User Privileges](#user-privileges)  
[File Permissions](#file-permissions)  
[Shutting Down and Restarting the Beaglebone](#shutting-down-and-restarting-the-beaglebone)  
[Viewing and Editing Files](#viewing-and-editing-files)  
[Times and Dates](#times-and-dates)  
[Recalling Previously Used Commands](#recalling-previously-used-commands)  
[Miscellanous Commands](#miscellaneous-commands)  

### Basic Syntax

This section covers some common unix symbols and their meaning.

**$**  
The dollar symbol is used to mark start of the command prompt

**~**  
The tilde symbol acts as a shortcut to the home directory on your pc.
* On the Beaglebone this will be `/home/debian`
* On Mac systems this is the folder one level up from Applications, Desktop, Documents etc e.g. `/Users/yourUserName`

To find out exactly where your home directory is on your system, you can do the following:  
`$ cd ~`  
`$ pwd`

**|**  
The pipe symbol is used to route terminal output to another program or process.
For example, by piping the command line history, we can get a list of all the ssh commands we have recently executed e.g.  
`$ history | grep ssh`

**/**    
The backslash symbol is used to escape characters which are otherwise reserved for special purposes (i.e. most of the symbols we are talking about in this section!)
A common use for the backslash is to escape spaces in file or folder names e.g.  
`cd ~/Desktop/my\ folder\ with\ spaces\ in\ the\ title/`

**#**  
The hash symbol is used to comments in the command line e.g.  
`$ mkdir myNiceFolder # This is a really cool new folder`  
This is more commonly used in shell scripts than in single line terminal commands

**;**   
The semicolon can be used to run commands one after the other on the same line e.g.  
`$ cd ~/Desktop/Documents; cat myTextFile.txt`

**&**  
The ampersand is used at the end of a line to execute commands as background tasks.  
This is useful in circumstances where a program does not return control to the user  
e.g. when running jack audio in the background, we might do the following:  
`$ jackd -P95 -d alsa -d hw:1,0 -p512 -n3 -s &`

### Getting Help

**whatis**  
Type:  
`$ whatis [commandname]`  
e.g.  
`$ whatis ping`

**--help**  
Another possibility is to type just the commandname, or the commandname followed by `-help` or `--help` to get a display of the helpfile e.g.  
`$ git push --help `  
NOTE: this opens in vim editor, type `:q` to exit

### Moving Around the Command Line

**CMD+A**  
Moves the cursor to start of the command line

### Clearing the Terminal Window

**clear**  
The clear command clears the terminal buffer in a 'soft' way (i.e. you can still scroll back to see previously output) e.g.  
`$ clear`

**CMD+K**  
This keyboard shortcut clears the terminal buffer in a 'hard' way (i.e. you cannot scroll back)

### Navigation

**..**  
Refers to the path one level up from the current path  
For example if we want to move a file in the folder we are in to another folder which resides one level up from where we are currently, we could do the following:  
`$ mv myFile.txt ../myFolder/`

**cd**  
Change to the given directory path e.g.  
`$ cd myNewDir`
change to root directory  
`$ cd ../..`
go up to parent directory    
`$ cd ..`

**ls**  
Show whats in a given directory e.g for the current path  
`$ ls`  
Just looking without actually navigating to the directory  
`$ ls /pathTo/myDirectory`  
Options:  
Use -a flag to display hidden files (i.e. those preceded with a `.`)  
`$ ls -a`  
Use -l to display items in a list form (also shows file permissions)  
`$ ls -l`

**pwd**  
This displays the current path e.g  
`$ pwd`  
On the beaglebone may show something like this:  
`/home/debian`

### File Management

**mkdir**  
Create a directory, e.g. in the current folder  
`$ mkdir myNewDir`

**mv**  
Move a file to a new location e.g. into a subfolder  
`$ mv myFile.txt /myFolder/myFile.txt`  
Can also be used for renaming e.g. changing the extension of a file  
`$ mv myFile.txt bob.pdf`

**cp**  
Copy a file e.g. to duplicate a file before editing  
`$ cp myFirstFile.txt mySecondFile.txt`

**rm**  
Remove individual files by name  
`$ rm annoyingFile.txt`  
Use -R to remove a whole folder and its contents (recursively) e.g  
`$ rm -R annoyingFolder`

**touch**  
Creates a new empty file with the given name e.g.  
`$ touch readme.txt`

### Communicating with the Beaglebone

The default username/password for beagleboard is **debian/debian**

**ping**  
This sends a ping msg to a given IP address and is useful for checking whether a Beaglebone is connected and running on the network e.g.  
`$ ping 192.168.2.7`  
If the Beaglebone exists at this address, you should see something like:
```
PING 192.168.2.14 (192.168.2.14): 56 data bytes
64 bytes from 192.168.2.14: icmp_seq=0 ttl=64 time=0.702 ms
64 bytes from 192.168.2.14: icmp_seq=1 ttl=64 time=0.543 ms
64 bytes from 192.168.2.14: icmp_seq=2 ttl=64 time=0.543 ms
```

**ssh**  
Used to remotely log into the beaglebone via a network connection  
e.g. to login at the given IP with the username 'debian':  
`$ ssh debian@192.168.1.1`

**traceroute**  
This traces the package being sent to the given IP … e.g.  
`$ traceroute 192.168.2.6`

**scp**  
Copy files over a secure connection (e.g. from laptop to Beaglebone)
It can be used for sending individual files… e.g:  
`$ scp testfile.txt debian@192.168.1.1:/home/debian #replace filename and IP with your own`  
…and also for folders e.g.  
`$ scp -r soundvase debian@192.168.1.1:/home/debian`  
…also, see how Fredrik Olofsson does it [here](https://github.com/redFrik/udk10-Embedded_Systems/tree/master/udk131128#--copy-files-from-laptop-to-bbb)

**sftp**  
Another way to copy files between the beagle and another device (i.e. a laptop)  
Example:  
`$ sftp debian@192.168.7.5`  
You will now be in sftp mode, where there are two useful commands…
* get downloads from beaglebone to laptop e.g.  
`$ put aFileFromMyLaptop.txt`
* put uploads from laptop to beaglebone e.g.  
`$ get aFileFromMyBeagle.txt`

### Terminating Processes

Sometimes it is necessary to terminate processes that are running in the background e.g. when using jackd for audio.

**CMD+C**  
Force exits from an interactive running process e.g a running bash script

**PID's**  
PID stands for 'process ID' and can commonly be seen when running background processing using &, which would otherwise lock up  
when we run such a process, it's PID will be shown  
e.g. [1] 12760

**pkill**  
kills a running process by name e.g:  
`$ pkill python`

### User Privileges

**sudo**  
sudo is short for 'superuser do' and requires that you enter the password for your beaglebone (typically 'debian')  
Superuser privileges are often require to perform certain tasks e.g. to allow Python to access the Beaglebone pins through the Adafruit BBIO library  
Usage is simply to preface the command with `sudo` e.g.  
`$ sudo python sense.py`

### File Permissions

**chmod**  
changes file permissions  
\TODO/

### Shutting Down and Restarting the Beaglebone

This section involves running small programs (in /sbin typically), they are not unix commands as such... 

**reboot**  
Reboot the beagle board from the command line e.g.  
`$ sudo /sbin/reboot`

**shutdown**
Shutdown immediately:  
`$ sudo /sbin/shutdown now`  
Shutdown with option for reboot, scheduled now:  
`$ sudo /sbin/shutdown -r now`

**halt**  
\TODO/: add Fredrik's halt example

### Viewing and Editing Files

**cat**  
prints the entire contents of a file to the screen e.g.  
`$ cat ~/Documents/myLongTextFile.txt`

**tail**  
prints only the end of the file e.g.  
`$ tail myLongFile.txt`

**pico/nano**  
_pico_ and _nano_ are simple text editors which can be used as follows  
`$ nano myTextFile.txt`  
Unlike vim their interfaces are largely self-explanatory  
Note that if a given filename does not exist, it is created automatically! This is useful for creating and starting to edit a new blank file.

**vi**  
vim is yet another more difficult to use text editor (IMO)  
it is used as default text editor by the shell, e.g. for commiting git comments  
Basic usage:  
`$ vi myTextFile.txt`  
And some basic commands:
* `I` enters insert mode
* `ESC` exits insert mode
* then type `:w` to write the file
* followed by `:q` to quit

See [here](http://www.tldp.org/HOWTO/Tips-HOWTO.html) for more details.

### Times and Dates

**ntpdate**  
Used to set the correct time on the system (sync with NTP server)  
_NOTE: requires an internet connection_  
`$ /usr/sbin/ntpdate -b -s -u pool.ntp.org`

### Recalling Previously Used Commands  

**up/down arrows**  
The up and down arrow keys can be used to step back through the history of the command line
e.g. to repeat or modify a previously issued command

**history/grep**  
The history command prints a list of previously executed terminal commands e.g.  
`$ history`  
this can be useful when trying to remember something you did previously or to retracing your steps to understand how you did something  
the output of history can also be piped to a grep search in order to look for specific entries e.g. to filter out all the jackd commands you have previously issued  
`$ history | grep jackd`  
Q: how far does history go back?

### Miscellanous Commands

**diskutil**  
This is the volume/disc manager, useful for mounting/unmounting etc, e.g.  
`$ diskutil list` gives you a list of the connected volumes on the system.

### Further Reading
A reference can be found [here](http://www.debian.org/doc/manuals/debian-reference/ch-tutorial.de.html) in German.




