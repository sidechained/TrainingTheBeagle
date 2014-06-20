## Glossary of Unix Lore

_NOTE: this is not really a glossary anymore - as it is now split into topics_
_TODO: As this file now contains a lot of info, it now needs an introductory discussion of/pointer to 'the essentials'_

This is a quick primer of most of the things you need to know about unix terminal commands to get started with the Beaglebone Black.

_NOTE: for keyboard shortcuts, the modifier key differs depending on your system, for example on Mac systems it is CMD, whereas on Linux system it is CTRL. In this guide we refer to the Mac modifier as a convention (CMD)._

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

`$`
The dollar symbol is used to mark start of the command prompt

`~`
The tilde symbol acts as a shortcut to the home directory on your pc.
On the Beaglebone this will be `/home/debian`
On Mac systems this is the folder one level up from Applications, Desktop, Documents etc e.g. `/Users/yourUserName`

To find out exactly where your home directory is on your system, you can do the following  
`$ cd ~`
`$ pwd`

`|`
The pipe symbol is used to route terminal output to another program or process.
For example, by piping the command line history, we can get a list of all the ssh commands we have recently executed e.g.  
`$ history | grep ssh`

`/`
The backslash is used to escape characters which are otherwise reserved for special purposes (i.e. most of the symbols we are talking about in this section!)
A common use for the backslash is to escape spaces in file or folder names e.g.
`cd ~/Desktop/my\ folder\ with\ spaces\ in\ the\ title/`

`#`
The hash symbol is used to comments in the command line e.g.  
`$ mkdir myNiceFolder # This is a really cool new folder`
This is more commonly used in shell scripts than in single line terminal commands

`;`
The semicolon can be used to run commands one after the other e.g. 
`$ cd ~/Desktop/Documents; cat myTextFile.txt`

`&`
The ampersand is used to execute commands as background tasks.
This is useful in circumstances where a program does not return the shell to the user
e.g. when running jack audio in the background, we might do the following:
`$ jackd -P95 -d alsa -d hw:1,0 -p512 -n3 -s &`

### Getting Help

**whatis**
Type: `$ whatis [commandname]`, e.g.  
`$ whatis ping`

**--help**
another possibility is to type just the commandname, or the commandname followed by `-help` or `--help` to get a display of the helpfile:
`$ git push --help ` (opens in vim editor, type `q` at the `:` (last line) to exit)

### Moving Around the Command Line

**CMD+A**
move the cursor to start of the command line

### Clearing the Terminal Window

**clear**
the clear command clears the terminal buffer in a 'soft' way (i.e. you can still scroll back to see previously output) e.g.  
`$ clear`

**CMD+K**
this keyboard shortcut clears the terminal buffer in a 'hard' way (i.e. you cannot scroll back)

### Navigation

**.**
represents the current path

**..**
refers to the path one level up from the current path
for example if we want to move a file in the folder we are in to another folder which resides one level up from where we are currently, we could do the following:  
`$ mv myFile.txt ../myFolder/`

**cd**   
`$ cd [path to directory]` 	= change to the given directory path  
`$ cd ../..` 	= change to root directory  
`$ cd ..` = go up to parent directory  

**ls**  
`$ ls` = show whats in the directory, also works like:  
`$ ls [path to directory]` - just looking without actuall navigating to the directory  
Options:   
`$ ls -a` = use -a flag to display hidden files (i.e. those preceded with a `.`)  
`$ ls -l` = use -l to display items in a list form (also shows file permissions)
*- ls -d ?!* mention here?  

**pwd**   
This displays the current path e.g
`$ pwd`
gives something like  
`/home/debian/soundvase`

### File Management

**mkdir**  
create a directory, e.g. in the current folder  
`$ mkdir [directoryname]`

**mv**
move a file to a new location e.g. into a subfolder  
`$ mv myFile.txt /myFolder/myFile.txt`  
can also be used for renaming e.g. changing the extension of a file
`$ mv bob.pdf bob.txt'

**cp**  
Copy a file e.g. to duplicate a file before editing
`$ cp myFirstFile.txt mySecondFile.txt`

**rm**  
`$ rm annoyingFile.txt` = remove single files of given name  
use -R to remove a whole folder and its contents (recursively) e.g  
`$ rm -R annoyingFolder`

**touch**
creates a new empty file with the given name e.g.
`$ touch readme.txt`

### Communicating with the Beaglebone

NOTE: the default username/password for beagleboard is **debian/debian**

**ssh**  
is used to log into the beaglebone via a TCP Cable Connection 
`$ ssh debian@192.168.1.1` = Login at the given IP under name _debian_

**ping**  
This sends a ping msg to the given IP address. useful for checking wether BBB is up & running in the network:
`$ ping 192.168.2.7` this should return something like: 
`$ `

**traceroute**   
This traces the package being sent to the given IP … e.g. 
`$ traceroute 192.168.2.6`

**scp**  
In case you want to copy files over a secure connection (e.g. from laptop to beagle)
It can be used for both files and folders (option -r):
`$ scp testfile.txt debian@192.168.1.1:/home/debian #replace filename and IP with your own`
`$ scp -r soundvase debian@192.168.1.1:/home/debian` for copying folders
see also: https://github.com/redFrik/udk10-Embedded_Systems/tree/master/udk131128#--copy-files-from-laptop-to-bbb

**sftp**
for copying files between the beagle and another device
`$ sftp debian@192.168.7.5` # you will now be in sftp mode
There are two useful commands
- put (from laptop to beaglebone) e.g. `$ put aFileFromMyLaptop.txt`
- get (from beaglebone to laptop) e.g. `$ get aFileFromMyBeagle.txt`

### Terminating Processes

When using the Beaglebone for
running processes in the background (e.g. jackd for audio) and needing to terminate these processes.

**CMD+C**
terminate the running process

**&**
used at the end a - background process

**PID's**
PID stands for 'process ID' and can commonly be seen when running background processing using &, which would otherwise lock up
when we run such a process, it's PID will be shown
e.g. [1] 12760

**pkill**  
kills a running process by **name** e.g: `$ pkill python`

**lsof -p**  
using the -p switch of lsof lets us see the processes that are currently running 

### User Privileges

**sudo**  
sudo is short for 'superuser do'
superuser privileges are often require to perform certain tasks
they enter the password for your beaglebone (typically 'debian').
- e.g. to allow python to access the beaglebone pins through the adafruit bbio library
Usage: Simply preface the command with `sudo` e.g.
`$ sudo python sense.py`

_NOTE: there are also cases where sudo should not be used_ 
e.g. ?

### File Permissions

**chmod**  
changes file permissions  
_EXAMPLES_

### Shutting Down and Restarting the Beaglebone

This section involves running small programs (in /sbin typically), they are not unix commands as such... 

**reboot/shutdown**  
- reboot the beagle board from the command line:
```shell
```

**shutdown**
`$ sudo /sbin/shutdown now #shutdown, scheduled immediatly`
$ sudo /sbin/reboot # option 1: directly do reboot
$ sudo /sbin/shutdown -r now # option 2, shutdown with option for reboot, scheduled now

**halt**

### Viewing and Editing Files

**cat**
prints the entire contents of a file to the screen e.g.  
`$ cat ~/Documents/myLongTextFile.txt`

**tail**
prints only the end of the file

**pico/nano**  
_pico_ and _nano_ are simple text editors which can be used as follows  
`$ nano myTextFile.txt`
unlike _vim_ their interfaces are largely self-explanatory
note that if a given filename does not exist, it is created automatically! This is useful for creating and starting to edit a new blank file.

**vi**  
_vim_ is yet another more difficult to use text editor (IMO)
- Used as default text editor by the shell, e.g. for commiting git comments
Basic usage:
`$ vi myTextFile.txt`
- `I` enters insert mode
- `ESC` exits insert mode
- then type `:w` to write the file
- followed by `:q` to quit
- more details here: http://www.tldp.org/HOWTO/Tips-HOWTO.html

### Times and Dates

**setting the correct time on the system**  
NOTE:requires an internet connection
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




