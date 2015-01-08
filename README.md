About this repo
---------------

This is the VIM conf I'm using. I don't think that there could be a "perfect" and "general" VIM configuration which can make everybody happy.

If there was, then you should ask why VIM is designed configurable, what's the differents between VIM and the other editors which can be used directly without VIM's "complex" configuration, and the most important question: why you are using VIM?

In my opnion, people loves VIM(Emacs) because it is flexible and configurable. If we hate some behavoirs of VIM, we can change it ourself instead of suffering and complaining, not because VIM increases our typing speed.

I created this repo just for myself, but there may be something you can reference. Just read it and create your own, do not copy it, copying helps nothing.

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
- run `:BundleInstall` in Vim to install other plugins.
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

then run some command like this in CLI:
```shell
sh git-clone-ext.sh git@github.com:luochen1990/vimconf.git ../github/vimconf.git ./config/vimconf
```

here is the meaning of the arguments of `git-clone-ext.sh`
- `$1`: the url to clone
- `$2`: the git repo directory
- `$3`: the git working directory

