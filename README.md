About it
===

this is the vim conf i used, i created it just for myself. but there may be something you can learn from it, just read it and create your own, don't copy it, copying will help nothing.

you can try it with the following steps:

0. `git clone --recursive git@github.com:luochen1990/vimconf.git`
1. put this directory 'vimconf' to whereever you like, such as your dropbox directory.
2. edit your vimrc so it looks like this (just replace the dropbox path 'D:/Dropbox/' to your own):
```vim
let $vimrc = 'D:/Dropbox/vimconf/vimrc'
source $vimrc
```
3. reboot your vim.
4. `:BundleInstall`

