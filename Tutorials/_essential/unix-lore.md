## Our Glossary of Unix Lore

This is a quick primer of most of the things you need to know about unix/terminal to get started with the Beaglebone Black

----------------
#### 0. Basic Unix Syntax / Symbols

username/password for beagleboard is **debian/debian**

Some syntax symbols and their meaning:  
`~`	= home directory  
`$`	= used to mark start of the command prompt  
`|`	= (pipe)   
`/`	= (backslash)  
`#` = separates comments in the command line/ shell/terminal  

**Important: Getting help**

Type: `$ whatis [commandname]`, e.g.  
`$ whatis ping`

another possibility is to type just the commandname, or the commandname followed by `-help` or `--help` to get a display of the helpfile:
`$ git push --help ` (opens in vim editor, type `q` at the `:` (last line) to exit)


###### Some Helpful Shortcuts: 

For using on the command line / terminal. 
(CMD key on mac osx == CTRL key on Linux/win)

- CMD+C	= terminate the running process
- CMD+A	= jump with cursor to start of the command line
- CMD+K	= clear the buffer / command line (cannot scroll back)

----------------
#### 1. Standard actions

###### Navigating: 
**cd**   
`$ cd [path to directory]` 	= change to the given directory path  
`$ cd ../..` 	= change to root directory  
`$ cd ..` = go up to parent directory  

**ls**  
`$ ls` = show whats in the directory, also works like:  
`$ ls [path to directory]` - just looking without actuall navigating to the directory  
Options:   
`$ ls -a` = use -a flag to display hidden files (i.e. those preceded with a `.`)  
`$ ls -l` = use -l to display items in a list  
*- ls -d ?!* mention here?  

**pwd**   
This displays the current directory path e.g  
`$ pwd` -> you get something like: `$ /home/debian/soundvase  

###### File Management:

**mkdir**  
`$ mkdir [directoryname]` = create a directory in the current folder  

**mv**  
`$ mv [filename]` = move (==copy) a file around  
e.g. `$ mv bob.pdf ..`  
`$ mv bob.pdf ~/`  
`$ mv bob.pdf bob.txt # creates a duplicate of bob.pdf as bob.txt`  

**cp**  
`$ cp` = Copy …   

**rm**  
`$ rm annoyingFile.txt` = remove single files of given name  
use -R to remove a whole folder and its contents (recursively) e.g  
`$ rm -R annoyingFolder`  

----------------
#### 2. TCP Communication / Up-&Downloads

**ping**  
This sends a ping msg to the given IP address. useful for checking wether BBB is up & running in the network:
`$ ping 192.168.2.7` this should return something like: 
`$ `

**traceroute**   
This traces the package being sent to the given IP … e.g. 
`$ traceroute 192.168.2.6`

**SSH**  
is used to log into the beaglebone via a TCP Cable Connection 
`$ ssh debian@192.168.1.1` = Login at the given IP under name _debian_

**SCP**  
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

----------------
#### 3. Starting/Terminating Processes & Managing Access Rights

**sudo**  
superuser privileges are often require to perform certain tasks (sudo = superuser do)
- e.g. to allow python to access the beaglebone pins through the adafruit bbio library
Usage: Simply preface the command with `sudo`
`$ sudo python sense.py`
Then enter the password for your beaglebone.

_NOTE: there are also cases where sudo should not be used_ 
e.g. running sclang, where superuser is not in the audio group, but the standard user is

**pkill**  
kills a running process by **name** e.g: `$ pkill python`

**lsoi**  
_need this ? _

**chmod**  
changes file permissions  
_EXAMPLES_

----------------
#### 4. System Shutdown/Startup

this section involves running small programs (in /sbin typically), they are not unix commands as such... 

**reboot/shutdown**  
- reboot the beagle board from the command line:
```shell
$ sudo /sbin/reboot # option 1: directly do reboot
$ sudo /sbin/shutdown -r now # option 2, shutdown with option for reboot, scheduled now
```

**shutdown:**
`$ sudo /sbin/shutdown now #shutdown, scheduled immediatly`

----------------
#### 5. Text editors

**nano**  
_nano_ is a simple text editor in the shell. The interface is mostly self-explanatory, unlike _vim_
`$ nano myTextFile.txt`#if filename does not exist, it gets created! 

**pico**  
see nano  
_is there any difference?_

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

----------------
#### 6. Miscellanous

**diskutil**  
This is the volume/disc manager, useful for mounting/unmounting etc, e.g. 
`$ diskutil list` gives you a list of the connected volumes on the system.

**cat**    
This prints the contents of a file to the screen e.g.
`$ cat /etc/passwd`
or: `$ cat id_rsa.pub`

**setting the correct time on the system**  
**NOTE:requires an internet connection**  
`$ /usr/sbin/ntpdate -b -s -u pool.ntp.org`

**history**  
_???_

**grep**  
This performs regular expression search on the given

**some more shell commands others**  
- less
- bg
- fg
- kill
- killall
- uname -a
- sync
- netstat
- traceroute
- top
- ps aux
- tar
- zcat
- ifconfig

-----------------------
#### 7. More Keyboard Shortcuts

A reference can be found here in German: http://www.debian.org/doc/manuals/debian-reference/ch-tutorial.de.html
modifier key is: CMD (mac osx) == CTRL (Linux)

