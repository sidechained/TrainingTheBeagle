* TUTORIAL: Github Basics

- this document covers some basics of how to use Github 
- it is basically a document of our experiences of how to share beaglebone projects using github


** Friday 23rd May
(we worked on both being able to contribute to the /TrainingTheBeagle github page)

- sidechained created a master repo
- monodread forked it on the github website (fork button)
- monodread cloned his fork of it to a local directory:
$ git clone ahttps://github.com/monodread/TrainingTheBeagle.git
- monodread added an upstream of the original project master:
$ git remote add upstream https://github.com/monodread/TrainingTheBeagle.git
- sidechained created a new file in TrainingTheBeagle/Tutorials and pushed it
$ touch test
$ git add -A
$ git commit -m "added test"
$ git push
- monodread fetched the upstream change:
$ git fetch upstream
$ git merge upstream/master
- vim editor comes up, press I
$ git commit -m "merged"
- sidechained created another new file in TrainingTheBeagle/Tutorials and pushed it
$ touch test2
$ git add -A
$ git commit -m "added test2"
$ git push
- monodread pulled in the changes (instead of merging, this time)
$ git pull
- sidechained and monodread's repo's are now identical

** submitting a pull request
- monodread added a new file in TrainingTheBeagle/Tutorials
$ touch JonasTutorial.txt
(need to git add, git commit, git push here)?
- monodread submitted this change as a pull request on the github website:
-- navigate to your repository with the changes you want someone else to pull and press the Pull Request button.
-- branch selection dropdownSwitch to your branch
-- pull Request button -> Click the Compare & review button
- sidechained checked the pull request on the website

** pulling

- pulling is a combo of fetch and merge

** vim

[23/05/2014 19:32:12] Graham Booth: If you're in insert mode, hit Escape. Then enter : and you'll see a line at the bottom of the screen with a cursor ready to take input.

To write the file you're editing, enter w. (So, you'll have :w.) That will write the file to the existing filename. If you don't have a filename or want to write out to a different filename, use :w filename.
[23/05/2014 19:33:49] Graham Booth: To quit Vim after you've finished, hit :q.


* How to Properly Add Multiple Files to the Repo

warning: The behavior of 'git add --all (or -A)' with no path argument from a
subdirectory of the tree will change in Git 2.0 and should not be used anymore.
To add content for the whole tree, run:

  git add --all :/
  (or git add -A :/)

To restrict the command to the current directory, run:

  git add --all .
  (or git add -A .)

With the current Git version, the command is restricted to the current directory.
