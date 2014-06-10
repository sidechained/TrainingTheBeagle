## Rules for Markdown in this Project

Some conventions I think we should follow when using markdown:

* we use ## for the document title (not #)
`# is too big, but # and ## both include a big line break below them`
* for first sub heading use `###`, other headings use `####`  
#### Example Heading
* we use *italics* to represents notes or questions to ourselves
* we use a **bold** __TODO__ to represent elements of tutorials that still need to be completed

* *when marking Comments in a code block we use SC Syntax (`//`) -> or rather Terminal Syntax (`#`) ?*

----------

#### More Basic Formatting Syntax 
**Valuable things to know & use:**

###### Text Formatting: 

* make text bold or italic:  
`*This text will be italic* ` *This text will be italic*  
`**This text will be bold** ` **This text will be bold**  
(Both bold and italic can use either a * or an _ around the text for styling. This allows you to combine both bold and italic if needed.
In a word with several underscores, it won`t work properly! e.g. perform_complicated_task)  

* striketrough text:   
use double `~`. My ~~error~~

* Bullet points / lists   
`*` makes bullet points and starts a list (you can use hypens `-` as well)

* Making Paragraphs:  
Leaving at least **two spaces** at the end of a line forces a carriage return/end of paragraph.
Also an empty line forces a carriage return.

* many singles lines containing many ----'s or ===='s create a line break  
`----------------` 
------------------

* Table of Contents / Cross-reference Links  
These are picked up automatically through the heading formatting  
(hover over left of each section heading to see!)

###### CODE formatting:  
- Enclosing in single ```   
is good for marking up single lines of code e.g.  
`$ sudo python thisismycode.py `  

-Enclosing in triple ````s is good for marking up code blocks e.g.  
```
// my amazing sc patch
s.boot
s.quit
```
- Do Syntax Colorization:  
use ```` [nameOfLanguage] … `  
e.g. 
```SuperCollider   
Ndef(\mysound, {|freq=400, amp=0.1| SinOsc.ar(freq) * amp}).play;
```  
other relevant languages here: Python, Shell

###### LINKS:  
[thisLink] followed by (http://www.link.com) creates a hyperlink that hides the URL under "thislink"
[Jonas` archive] (http://jonashummel.de)

###### Inserting an Image / Video:
[![IMAGE Description TEXT HERE](http://myfancyimage.jpg)](http://www.theUrlToTheImageHere)

Videos can`t be added directly but you can add an image with a link to the video like this:
<a href="http://www.youtube.com/watch?feature=player_embedded&v=YOUTUBE_VIDEO_ID_HERE
" target="_blank"><img src="http://img.youtube.com/vi/YOUTUBE_VIDEO_ID_HERE/0.jpg" 
alt="IMAGE ALT TEXT HERE" width="240" height="180" border="10" /></a>

###### Inserting a Table:  

You can create tables by assembling a list of words and dividing them with hyphens - (for the first row), and then separating each column with a pipe |:

```
First Header  | Second Header
------------- | -------------
Content Cell  | Content Cell
Content Cell  | Content Cell
```
First Header  | Second Header
------------- | -------------
Content Cell  | Content Cell
Content Cell  | Content Cell


###### Reference:  

*this info is compiled from:*   
- https://help.github.com/articles/github-flavored-markdown
- https://help.github.com/articles/markdown-basics
- https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet

- https://github.com/github/linguist/blob/master/lib/linguist/languages.yml

