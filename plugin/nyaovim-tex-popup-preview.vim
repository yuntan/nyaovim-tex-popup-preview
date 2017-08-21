if get(g:, 'loaded_nyaovim_tex_popup_preview', 0) || !exists('g:nyaovim_version')
  finish
endif

augroup nyaovim-tex-popup-preview
  autocmd!
augroup END

function! s:open(path, line, col) abort
  call rpcnotify(0, 'tex-popup-preview:open', a:path, a:line, a:col)
  augroup nyaovim-tex-popup-preview
    autocmd!
    autocmd CursorMoved,CursorMovedI * call rpcnotify(0, 'tex-popup-preview:close') | autocmd! nyaovim-tex-popup-preview
  augroup END
endfunction

function! s:find_tex() abort
  let l = getline('.')
  let inline_re = '\v\$([^$]+)\$'
  " FIXME check match position
  if l =~ inline_re " inline math found
    return matchlist(l, inline_re)[1]
  endif

  " TODO display math (\[, $$, \begin)

  return '' " not found
endfunction

function! s:calc_virtline() abort
  if !&l:wrap
    return line('.') - line('w0') + 1
  endif

  let width = winwidth(0)
  let l = 0
  let c = line('w0')
  let end = line('.')

  while c < end
    let l += strdisplaywidth(getline(c)) / width + 1
    let c += 1
  endwhile

  return l + col('.') / width + 1
endfunction

nnoremap <silent><Plug>(nyaovim-tex-popup-preview-open) :<C-u>call <SID>open(<SID>find_tex(), <SID>calc_virtline(), virtcol('.'))<CR>
vnoremap <silent><Plug>(nyaovim-tex-popup-preview-open) y:call <SID>open('<C-r>"', <SID>calc_virtline(), virtcol('.'))<CR>

let g:loaded_nyaovim_tex_popup_preview = 1
