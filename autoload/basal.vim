function! basal#search(query, bang)
  let l:pattern = (a:query =~ '^#') ? a:query . '\b' : a:query
  let l:command = 'rg --column --line-number --no-heading --color=always --smart-case -e ' . shellescape(l:pattern) . ' -- '
  let l:spec = fzf#vim#with_preview({'dir': expand($BASAL)})
  call fzf#vim#grep(l:command, 1, l:spec, a:bang)
endfunction

function! basal#init()
  let l:target_dir = expand($BASAL)
  
  if isdirectory(l:target_dir)
    echoerr "Basal: Target directory already exists: " . l:target_dir
    return
  endif

  let l:plugin_dir = expand('<sfile>:p:h:h')
  let l:skeleton_dir = l:plugin_dir . '/skeleton'

  let l:cmd = 'cp -r ' . shellescape(l:skeleton_dir) . ' ' . shellescape(l:target_dir)
  call system(l:cmd)

  if v:shell_error
    echoerr "Basal: Failed to create core infrastructure."
  else
    echom "Basal: Brain initialized at " . l:target_dir
    execute 'e ' . l:target_dir . '/index.md'
  endif
endfunction
