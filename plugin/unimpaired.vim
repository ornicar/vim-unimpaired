" unimpaired.vim - Pairs of handy bracket mappings
" Maintainer:   Tim Pope <vimNOSPAM@tpope.org>
" Version:      1.1

if exists("g:loaded_unimpaired") || &cp || v:version < 700
  finish
endif
let g:loaded_unimpaired = 1

let s:cpo_save = &cpo
set cpo&vim

" Next and previous {{{1

function! s:MapNextFamily(map,cmd)
  let map = '<Plug>unimpaired'.toupper(a:map)
  let end = ' ".(v:count ? v:count : "")<CR>'
  execute 'nmap <silent> '.map.'Previous :<C-U>exe "'.a:cmd.'previous'.end
  execute 'nmap <silent> '.map.'Next     :<C-U>exe "'.a:cmd.'next'.end
  execute 'nmap <silent> '.map.'First    :<C-U>exe "'.a:cmd.'first'.end
  execute 'nmap <silent> '.map.'Last     :<C-U>exe "'.a:cmd.'last'.end
  execute 'nmap <silent> ['.        a:map .' '.map.'Previous'
  execute 'nmap <silent> ]'.        a:map .' '.map.'Next'
  execute 'nmap <silent> ['.toupper(a:map).' '.map.'First'
  execute 'nmap <silent> ]'.toupper(a:map).' '.map.'Last'
endfunction

call s:MapNextFamily('a','')
call s:MapNextFamily('b','b')
call s:MapNextFamily('l','l')
call s:MapNextFamily('q','c')

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

" }}}1

let &cpo = s:cpo_save

" vim:set ft=vim ts=8 sw=2 sts=2:
