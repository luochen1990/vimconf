About it
========

This is the vim conf I used, I created it just for myself. but there may be something you can learn from it, just read it and create your own, don't copy it, copying will help nothing.

Properties
----------

- Multi Operating System Supported.
- Screen scrolling optmized, reading with `j` & `k` is now coziness.
- Smooth transition between a vim with default configuration.
- Plugins' version also managed by git using git submodule.
- Idle keys reasonably used.
- Working Directory auto detect.
- Most properties are useable for any type of files.
- Other treaking hacking.

Try it
------

You can try it with the following steps:

- `git clone --recursive git@github.com:luochen1990/vimconf.git`
- put this directory 'vimconf' to whereever you like, such as your dropbox directory.
- edit your vimrc so it looks like this (just replace the dropbox path 'D:/Dropbox/' to your own):
```vim
	let $vimconf = 'D:/Dropbox/vimconf'
	source $vimconf/vimrc
```
- reboot your vim.

Dropbox Friendly
----------------

With .git directory in Dropbox directory will cause some headache problems. So you must want to move your git working directory to somewhere else outside of Dropbox directory. Here is my solution:

create file `git-clone-ext.sh` with the following content:
```shell
gitpath=$(echo $(pwd)/$2 | sed 's/\/[^/]*\/\.\.\/\|\/\.\//\//g' | sed 's/\/\+/\//g')
workpath=$(echo $(pwd)/$3 | sed 's/\/[^/]*\/\.\.\/\|\/\.\//\//g' | sed 's/\/\+/\//g')
echo $gitpath
echo $workpath
git --work-tree=$workpath clone --recursive $1 $gitpath && echo "gitdir: $gitpath" > $workpath/.git
```

then run this command in CLI:
```shell
sh git-clone-ext.sh git@github.com:luochen1990/vimconf.git ../github/vimconf.git ./config/vimconf
```

here is the meaning of the arguments of `git-clone-ext.sh`
- `$1`: the url to clone
- `$2`: the git repo directory
- `$3`: the git working directory

