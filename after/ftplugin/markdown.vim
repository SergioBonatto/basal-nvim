" Basal custom syntax for Markdown files within the brain
if empty($BASAL) | finish | endif

let l:current_file = expand('%:p')
let l:brain_path = expand($BASAL)

" Only apply if the file is inside the Basal directory
if l:current_file !~# '^' . l:brain_path
  finish
endif

" Highlight #tags
syntax match BasalTag /#\w\+/
highlight default link BasalTag Tag

" Highlight [[links]]
syntax match BasalLink /\[\[[^\]]\+\]\]/
highlight default link BasalLink Underlined
