if exists('g:loaded_basal')
  finish
endif
let g:loaded_basal = 1

" Configuration
let g:basal_path = get(g:, 'basal_path', expand('~/Basal'))
let $BASAL = expand(g:basal_path)

" Path & Link settings for built-in Vim navigation (gf)
execute 'set path+=' . $BASAL . '/**'
set suffixesadd+=.md

" Commands
command! -bang -nargs=* BasalSearch call basal#search(<q-args>, <bang>0)
command! BasalInit call basal#init()
command! BasalCheck call basal#check()
command! BasalNew call basal#new()
command! BasalDaily call basal#daily()
command! BasalBacklinks call basal#backlinks()

" Mappings
if !get(g:, 'basal_disable_mappings', 0)
  nnoremap <leader>bb :execute 'e ' . $BASAL . '/index.md'<CR>
  nnoremap <leader>bt :execute 'e ' . $BASAL . '/TODO.md'<CR>
  nnoremap <leader>bd :BasalDaily<CR>
  nnoremap <leader>bn :BasalNew<CR>
  nnoremap <leader>bs :BasalSearch<space>
  nnoremap <leader>bl :BasalBacklinks<CR>
  nnoremap F :call basal#search(expand('<cWORD>'), 0)<CR>
endif
