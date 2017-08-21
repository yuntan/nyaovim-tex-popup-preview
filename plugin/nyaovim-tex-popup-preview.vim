if get(g:, 'loaded_nyaovim_tex_popup_preview', 0) || !exists('g:nyaovim_version')
  finish
endif

augroup nyaovim-tex-popup-preview
  autocmd!
augroup END

function! s:open(tex) abort
  call rpcnotify(0, 'tex-popup-preview:open', a:tex)
  augroup nyaovim-tex-popup-preview
    autocmd!
    autocmd CursorMoved,CursorMovedI * call rpcnotify(0, 'tex-popup-preview:close') | autocmd! nyaovim-tex-popup-preview
  augroup END
endfunction

function! s:find_tex() abort
  let l = getline('.')
  let inline_re = '\v\$([^$]+)\$'
  " FIXME check match position and cursor position
  if l =~ inline_re " inline math found
    return matchlist(l, inline_re)[1]
  endif

  " TODO display math (\[, $$, \begin)

  " TODO show message
  return '' " not found
endfunction

nnoremap <silent><Plug>(nyaovim-tex-popup-preview-open) :<C-u>call <SID>open(<SID>find_tex())<CR>
vnoremap <silent><Plug>(nyaovim-tex-popup-preview-open) y:call <SID>open('<C-r>"')<CR>

let g:loaded_nyaovim_tex_popup_preview = 1
