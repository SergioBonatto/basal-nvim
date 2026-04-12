function! basal#init()
  let l:target_dir = fnamemodify(expand($BASAL), ':p')
  
  if isdirectory(l:target_dir)
    echoerr "Basal: Directory " . l:target_dir . " already exists."
    return
  endif

  let l:plugin_root = fnamemodify(expand('<sfile>:p'), ':h:h')
  let l:skeleton_dir = l:plugin_root . '/skeleton'

  if !isdirectory(l:skeleton_dir)
    echoerr "Basal: Skeleton source not found at " . l:skeleton_dir
    return
  endif

  call mkdir(l:target_dir, "p")

  let l:cmd = 'cp -R ' . shellescape(l:skeleton_dir) . '/. ' . shellescape(l:target_dir)
  call system(l:cmd)

  if v:shell_error
    echoerr "Basal: Copy failed. Check permissions for " . l:target_dir
  else
    echom "Basal: Brain initialized at " . l:target_dir
    execute 'e ' . l:target_dir . '/index.md'
  endif
endfunction
