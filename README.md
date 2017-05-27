dwttool - A tool to manage websites based on Dynamic Web Templates
==================================================================

![dwttool logo](dwttool-logo.jpg)

About
-----
A couple of years ago I created several websites with Microsoft's tool Expression Web. I loved Expression Web because it had a decent HTML/CSS editor and a cool feature called DWT - Dynamic Web Templates (similar to those in Adobe's Dreamweaver). Unfortunately Expression Web only runs on Windows. dwttool is a command line tool that tries to fill this gap. With dwttool you can create new projects based on DWT and manage existing ones on Linux. dwttool is written in the [D programming language](https://dlang.org/ "D programming language").

Download
--------
The latest binaries are available on [https://github.com/kambrium/dwttool/releases](https://github.com/kambrium/dwttool/releases "https://github.com/kambrium/dwttool/releases").

Installation
------------
Add the directory that contains the dwttool binary to your PATH. For example, on Ubuntu, add the following line to your `.bashrc`.
```
export PATH=$PATH:/this/is/your/dwttool/path/
```

Getting started
---------------
```shell
// Create new project
$ dwttool create project my_cool_website
$ cd my_cool_website
// Edit template
$ vim master.dwt
// Create new HTML file from template
$ dwttool create page index.html master.dwt
// Run server on port 50000
$ dwttool serve
```

License
-------
MIT