" unimpaired.vim - Pairs of handy bracket mappings
" Maintainer:   Tim Pope <http://tpo.pe/>
" Version:      1.1
" GetLatestVimScripts: 1590 1 :AutoInstall: unimpaired.vim

if exists("g:loaded_unimpaired") || &cp || v:version < 700
  finish
endif
let g:loaded_unimpaired = 1


function! s:entries(path)
  let path = substitute(a:path,'[\\/]$','','')
  let files = split(glob(path."/.*"),"\n")
  let files += split(glob(path."/*"),"\n")
  call map(files,'substitute(v:val,"[\\/]$","","")')
  call filter(files,'v:val !~# "[\\\\/]\\.\\.\\=$"')
  call filter(files,'v:val[-4:-1] !=# ".swp" && v:val[-1:-1] !=# "~"')
  return files
endfunction

function! s:FileByOffset(num)
  let file = expand('%:p')
  let num = a:num
  while num
    let files = s:entries(fnamemodify(file,':h'))
    if a:num < 0
      call reverse(sort(filter(files,'v:val < file')))
    else
      call sort(filter(files,'v:val > file'))
    endif
    let temp = get(files,0,'')
    if temp == ''
      let file = fnamemodify(file,':h')
    else
      let file = temp
      while isdirectory(file)
        let files = s:entries(file)
        if files == []
          " TODO: walk back up the tree and continue
          break
        endif
        let file = files[num > 0 ? 0 : -1]
      endwhile
      let num += num > 0 ? -1 : 1
    endif
  endwhile
  return file
endfunction

nnoremap <silent> <Plug>unimpairedONext     :<C-U>edit `=<SID>FileByOffset(v:count1)`<CR>
nnoremap <silent> <Plug>unimpairedOPrevious :<C-U>edit `=<SID>FileByOffset(-v:count1)`<CR>

nmap ]o <Plug>unimpairedONext
nmap [o <Plug>unimpairedOPrevious
nmap ]b :bnext<cr>
nmap [b :bprev<cr>

" vim:set sw=2 sts=2:
