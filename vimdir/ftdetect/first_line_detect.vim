
au bufnewfile,bufread * if match(getline(1) , '--lua') != -1 | set ft=lua | endif

au bufnewfile,bufread * if match(getline(1) , '//cpp11') != -1 | set ft=cpp11 | endif

au bufnewfile,bufread * if match(getline(1) , 'python27') != -1 | set ft=python27 | endif

au bufnewfile,bufread * if match(getline(1) , 'python33') != -1 | set ft=python33 | endif

