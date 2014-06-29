## TUTORIAL: A quickstart into using Github 

This document covers some basics of how to use Github for collaborating on a repo. It is basically a document of our experiences of how to share beaglebone projects using github as a communication and exchange platform. We use git from the command line, but the github site also offers some useful functions for doing small edits.

For related info on document formatting on github - using GitHub Flavored Markdown, see: [general document-Markdown-Rules] (https://github.com/sidechained/TrainingTheBeagle/tree/master/Tutorials/general-documentMarkdownRules.md)

**When using terminal, you need to install git on your system first!**
Install with brew: `$ brew install git`

__NOTE: When working from Mac OSX you will get merge conflicts through .ds store files__
- Check these links for clearing that: 
- http://stackoverflow.com/questions/107701/how-can-i-remove-ds-store-files-from-a-git-repository 
- http://stackoverflow.com/questions/18393498/gitignore-all-the-ds-store-files-in-every-folder-and-subfolder


### Scenario1: Just Following / Cloning

Author1 wants to get & copy any repo from github 'manually' to his computer. 

__Commandline__
In Terminal, navigate to your preferred folder. then type `$ git clone [UrlOfTheRepo]`

__Browser__
For this use the webbrowser and navigate to the repo of interest, e.g. https://github.com/monodread/TrainingTheBeagle
and click the button "Download ZIP" at the lower right corner to get the zipped repo folder usually named "NameOfRepo-master".


### Scenario2: Update your Clone

Author1 wants to update his preferred and updated repo from github 'manually':  
It's easiest to just delete the "master"-folder and clone again... (see above)


### Scenario3: Following a repo through 'Forking'

Author1 _sidechained_ manages the Working Repo, Author2 _monodread_ follows the master branch with this fork of it.

__TODO__ *add another scenario with other working models? e.g. contributing to repo without forking...*


#### Setup Process

- _sidechained_ created a master repo
- _monodread_ forked it on the github website (using the fork button)
- _monodread_ cloned his fork of this repo to a local directory with Terminal:  
`$ git clone ahttps://github.com/monodread/TrainingTheBeagle.git`
- _monodread_ added an upstream of the original project master to his fork (relinking this repo to the original)=:  
`$ git remote add upstream https://github.com/monodread/TrainingTheBeagle.git`

--------------------------
#### Keep the Fork in sync with the __upstream__ Repo

- _sidechained_ created a new file in the local directory `TrainingTheBeagle/Tutorials` and pushed it
```
$ touch test # creates the file `test`
$ git add -A # this adds a change to the 'history'
$ git commit -m "added test" # this commits the change to the 'history'
$ git push # this pushes the local changes/commits incl. files to the online repo
```
- _monodread_ fetched the upstream changes:
```
$ git fetch upstream # asks the latest changes/files from online upstream repo
$ git merge upstream/master # merges them with your local files/changes
```
Now the vim editor comes up, press I for inserting text, go to end of document, add a change comment.
then save the file and quit the editor:
`:w` and ` :q`

or use this line instead: 
`$ git commit -m "merged" # or any other message than 'merged'` 

#### Do the same with _pull_ instead of _fetch_ + _merge_

- _sidechained_ created another new file in TrainingTheBeagle/Tutorials and pushed it
```
$ touch test2
$ git add -A
$ git commit -m "added test2"
$ git push
```
- _monodread_ pulls in the changes (instead of merging, this time)
`$ git pull`

- _sidechained_ and _monodread_'s repo's are now identical. 


-------------

### Scenario4: Making changes to your repo and pushing them to your fork and then to the upstream

#### Updating your fork with your changes:

__Browser__  
The easiest way to do this is through the browser editor, as it is already all synchronized!
For this you click on the file that you want to change (in your fork), edit it, save it, ideally with a commit message (at bottom). 

__Commandline__  
For making changes to the files/folders in your local repo, just edit, save them locally, then: 
```
$ git add -A # this adds the change to the git history
$ git commit -m "added test2" # this adds this stage with a commit message appearing the browser
$ git push # this pushes the local and modified files to your online repo / fork
```
Problems: The Commit history needs to be in sync and the "push" can be rejected. You have 2 options: 
a) Pull in the latest changes from the online repo:  
`$ git pull` accept the changes in the editor, quit it, and then do the above pushing again.

b) overwrite the online repo, if you are sure noone else has done anything to it (case: your local folder is a direct clone of the online repo):  
`$ git push --force`  (But this uploads the whole repo again, in case you have a lot of data -> takes longer)

#### Contribute ("Pull in") your changes from your fork to the original "upstream" repo

Now that your fork is up-to-date with your changes, you want to merge your updated fork with the original repo from which you forked it.
For this you have to submit a **"pull request"**  via the github website:  
__Browser__  
- Now that the fork is up-to-date: Navigate to your repository with the changes you want someone else to pull and press the Pull Request button.
- For branch selection, choose from dropdownSwitch to your branch
- use the pull Request button -> Click the Compare & review button
- author1/_sidechained_ gets an email notification and checks the pull request on the website, authorizes it.  
You can review/compare the changes online, line-by-line

-------------
#### Merge Conflicts

According to [github](https://help.github.com/articles/resolving-merge-conflicts) a merge conflict "happens when two branches have changed the same part of the same file, and then those branches are merged together. For example, if you make a change on a particular line in a file, and your colleague working in a repository makes a change on the exact same line, a merge conflict occurs. Git has trouble understanding which change should be used, so it asks you to help out."

##### Problem: .DS Store Files on Mac -> The Mergetool

I tried to pull before committing my latest local changes, which aborted with this error

```
error: Your local changes to the following files would be overwritten by merge:
	Tutorials/.DS_Store
	Tutorials/_essential/backup.md
Please, commit your changes or stash them before you can merge.
Aborting
```
I then did:
```
$ git add --all :/
$ git commit -m "commiting before pull"
```
Then pulled: `$ git pull`

Got this error: `Automatic merge failed; fix conflicts and then commit the result.`

##### Resolution

I used merge tool, as follows (and agreed to the one conflict it had found on a .ds store file)
`$ git mergetool`

This resolved the issue so I could commit and pull!

##### Links

- for more info on merge conflicts see this blog post: http://weblog.masukomi.org/2008/07/12/handling-and-avoiding-conflicts-in-git
- and this about how to resolve in github for mac: https://help.github.com/articles/resolving-merge-conflicts

--------------

### Additional notes: 

**pulling**

`git pull` is a combo of fetch and merge

**vim editor**

To write something you need to be in `insert mode`, for that hit `Escape`. 
Then enter : and you'll see a line at the bottom of the screen with a cursor ready to take input.
(e.g. `w` = write, `q` = quit, `w filename` = write to filename)

**How to Properly Add Multiple Files to the Repo**

*warning: The behavior of `git add --all (or -A)` with no path argument from a subdirectory of the tree will change in Git 2.0 and should not be used anymore.*
To add content for the whole tree, run:
```
  git add --all :/
  (or git add -A :/)
```
To restrict the command to the current directory, run:
```
  git add --all .
  (or git add -A .)
```
*With the current Git version, the command is restricted to the current directory.*

**Renaming Files**

For renaming a file, do not simply do: `$ git add myRenamedFile.txt`!  
This will create a duplicate file in the online repo (will not remove the old file).  
But it is **better** to add all the files in the current dir, then git knows that a file has been renamed: `$ git add --all`

However, if the former is done accidentally, duplicates must then be deleted from the repo through the webpage. After that you want to update your local repo by pulling.

**Q: what does 'git commit -a' do?**

--------------

###### More Markdown Info

- https://help.github.com/articles/markdown-basics
- https://help.github.com/articles/github-flavored-markdown
- https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet



------------

More about what github calls "fast-forwarding":  
Quoted from the git push help: `$ git push --help #checkout Notes about Fast-Forwarding`


NOTE ABOUT FAST-FORWARDS

       When an update changes a branch (or more in general, a ref) that used
       to point at commit A to point at another commit B, it is called a
       fast-forward update if and only if B is a descendant of A.

       In a fast-forward update from A to B, the set of commits that the
       original commit A built on top of is a subset of the commits the new
       commit B builds on top of. Hence, it does not lose any history.

       In contrast, a non-fast-forward update will lose history. For example,
       suppose you and somebody else started at the same commit X, and you
       built a history leading to commit B while the other person built a
       history leading to commit A. The history looks like this:

                 B
                /
            ---X---A
    	
    	Further suppose that the other person already pushed changes leading to
       A back to the original repository from which you two obtained the
       original commit X.

       The push done by the other person updated the branch that used to point
       at commit X to point at commit A. It is a fast-forward.

       But if you try to push, you will attempt to update the branch (that now
       points at A) with commit B. This does not fast-forward. If you did so,
       the changes introduced by commit A will be lost, because everybody will
       now start building on top of B.

       The command by default does not allow an update that is not a
       fast-forward to prevent such loss of history.

       If you do not want to lose your work (history from X to B) nor the work
       by the other person (history from X to A), you would need to first
       fetch the history from the repository, create a history that contains
       changes done by both parties, and push the result back.

       You can perform "git pull", resolve potential conflicts, and "git push"
       the result. A "git pull" will create a merge commit C between commits A and B.

                 B---C
                /   /
            ---X---A

       Updating A with the resulting merge commit will fast-forward and your
       push will be accepted.

       Alternatively, you can rebase your change between X and B on top of A,
       with "git pull --rebase", and push the result back. The rebase will
       create a new commit D that builds the change between X and B on top of
       A.

                 B   D
                /   /
            ---X---A

       Again, updating A with this commit will fast-forward and your push will
       be accepted.

 		There is another common situation where you may encounter
       non-fast-forward rejection when you try to push, and it is possible
       even when you are pushing into a repository nobody else pushes into.
       After you push commit A yourself (in the first picture in this
       section), replace it with "git commit --amend" to produce commit B, and
       you try to push it out, because forgot that you have pushed A out
       already. In such a case, and only if you are certain that nobody in the
       meantime fetched your earlier commit A (and started building on top of
       it), you can run "git push --force" to overwrite it. In other words,
       "git push --force" is a method reserved for a case where you do mean to
       lose history.

