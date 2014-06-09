## TUTORIAL: A quickstart into using Github (mainly through terminal)

This document covers some basics of how to use Github for collaborating on a repo.
It is basically a document of our experiences of how to share beaglebone projects using github as a communication and exchange platform.

For related info, see: "general document-Markdown-Rules"
In every section there is also a way mentioned how to do the action from the browser.
__TODO__!!

#### Scenario1
-----
Author1 _sidechained_ manages the Working Repo, Author2 _monodread_ follows the master branch with this fork of it.

__TODO__ *add scenarios 2,3 with other working models? e.g. contributing to repo without forking...


#### Setup Process
- _sidechained_ created a master repo
- _monodread_ forked it on the github website (using the fork button)
- _monodread_ cloned his fork of this repo to a local directory with Terminal:
`$ git clone ahttps://github.com/monodread/TrainingTheBeagle.git`
- _monodread_ added an upstream of the original project master to his fork:
`$ git remote add upstream https://github.com/monodread/TrainingTheBeagle.git`

#### Keep the Fork in sync with the __upstream__ Repo

- _sidechained_ created a new file in the local directory `TrainingTheBeagle/Tutorials` and pushed it
```
$ touch test # creates the file `test`
$ git add -A 
$ git commit -m "added test"
$ git push
```
- _monodread_ fetched the upstream changes:
```
$ git fetch upstream
$ git merge upstream/master
```
Now the vim editor comes up, press I for inserting text, go to end of document, add a change comment.
then save the file and quit the editor:
`:w` and ` :q`

or use this line instead: 
`$ git commit -m "merged"` 

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
- _sidechained_ and _monodread_`s repo`s are now identical  
_is this true or do I need $ git pull upstream/master ?_

-------------
#### Add your changes in the fork to the original repo

** For this submitting a "pull request" **  
This is needed, as soon as author2 /_monodread_ added or changed a file in his fork and wants to synchronize this with the original repo of author1

Author2 creates a new file: `$ touch JonasTutorial.txt`
_(need to git add, git commit, git push here)?_
_monodread_ submits this change as a pull request via the github website:
1. update your local fork to your online repo: 
```
$ git add -A
$ git commit -m "added my new file"
$ git push
```
2. Now that the fork is up-to-date: Navigate to your repository with the changes you want someone else to pull and press the Pull Request button.
3. For branch selection, choose from dropdownSwitch to your branch
4. use the pull Request button -> Click the Compare & review button
5. author1/_sidechained_ gets an email notification and checks the pull request on the website, authorizes it.  
You can review/compare the changes online, line-by-line


--------------
###### Additional notes: 

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

