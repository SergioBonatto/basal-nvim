if exists('g:loaded_basal')
  finish
endif
let g:loaded_basal = 1

let g:basal_path = get(g:, 'basal_path', expand('~/Basal'))
let $BASAL = g:basal_path

" Path & Link settings
execute 'set path+=' . $BASAL . '/**'
set suffixesadd+=.md

" Commands
command! -bang -nargs=* BasalSearch call basal#search(<q-args>, <bang>0)
command! BasalInit call basal#init()

" Mappings
if !get(g:, 'basal_disable_mappings', 0)
  nnoremap <leader>bb :execute 'e ' . $BASAL . '/index.md'<CR>
  nnoremap <leader>bt :execute 'e ' . $BASAL . '/TODO.md'<CR>
  nnoremap <leader>bd :execute 'e ' . $BASAL . '/5_Daily/' . strftime('%Y-%m-%d') . '.md'<CR>
  nnoremap <leader>bs :BasalSearch<space>
  nnoremap F :call basal#search(expand('<cWORD>'), 0)<CR>
endif
