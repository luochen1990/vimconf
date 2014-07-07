"vim
au bufnewfile,bufread * if match(getline(1) , '\<lua\>') != -1 | set ft=lua | endif
au bufnewfile,bufread * if match(getline(1) , '\<c++11\>') != -1 | set ft=cpp11 | endif
"au bufnewfile,bufread * if match(getline(1) , '\<python3') != -1 | set ft=python3 | endif

