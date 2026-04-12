let s:plugin_root = expand('<sfile>:p:h:h')

" Check dependencies and configuration
function! basal#check()
  let l:errors = []
  if !executable('rg')
    call add(l:errors, "ripgrep (rg) not found in PATH")
  endif
  if !exists('*fzf#run')
    call add(l:errors, "fzf.vim not found or not loaded")
  endif
  if empty(expand($BASAL))
    call add(l:errors, "$BASAL (g:basal_path) is not set")
  endif

  if !empty(l:errors)
    for l:err in l:errors
      echoerr "Basal: " . l:err
    endfor
    return 0
  endif
  echom "Basal: Environment OK"
  return 1
endfunction

" Initialize the brain structure from skeleton
function! basal#init()
  if !basal#check() | return | endif

  let l:target_dir = fnamemodify(expand($BASAL), ':p')
  if isdirectory(l:target_dir)
    echoerr "Basal: Directory " . l:target_dir . " already exists."
    return
  endif

  let l:skeleton_dir = s:plugin_root . '/skeleton'
  if !isdirectory(l:skeleton_dir)
    echoerr "Basal: Skeleton source not found at " . l:skeleton_dir
    return
  endif

  try
    " Use cp -R of the source directory itself into the parent of target
    let l:parent_dir = fnamemodify(l:target_dir, ':h')
    if !isdirectory(l:parent_dir) | call mkdir(l:parent_dir, 'p') | endif
    
    let l:cmd = 'cp -R ' . shellescape(l:skeleton_dir) . ' ' . shellescape(l:target_dir)
    call system(l:cmd)
    
    if v:shell_error
      echoerr "Basal: Copy failed. Check permissions for " . l:parent_dir
    else
      echom "Basal: Brain initialized at " . l:target_dir
      execute 'e ' . l:target_dir . '/index.md'
    endif
  catch
    echoerr "Basal: Initialization failed. " . v:exception
  endtry
endfunction

" Search within the brain using ripgrep and fzf
function! basal#search(query, bang)
  let l:dir = expand($BASAL)
  let l:pattern = (a:query =~ '^#') ? a:query . '\b' : a:query
  let l:command = 'rg --column --line-number --no-heading --color=always --smart-case -e ' . shellescape(l:pattern) . ' ' . shellescape(l:dir)
  let l:spec = fzf#vim#with_preview({'dir': l:dir})
  call fzf#vim#grep(l:command, 1, l:spec, a:bang)
endfunction

" Create a new note from a template
function! basal#new()
  let l:template_dir = expand($BASAL . '/4_Templates')
  if !isdirectory(l:template_dir)
    echoerr "Basal: Template directory not found at " . l:template_dir
    return
  endif

  let l:templates = split(globpath(l:template_dir, '*.md'), "\n")
  if empty(l:templates)
    echoerr "Basal: No templates found in " . l:template_dir
    return
  endif

  call fzf#run(fzf#wrap({
        \ 'source': map(l:templates, 'fnamemodify(v:val, ":t")'),
        \ 'sink': function('s:create_from_template'),
        \ 'options': '--prompt "Select Template> "'
        \ }))
endfunction

function! s:create_from_template(template_name)
  let l:name = input('Note Name (e.g., area/topic): ')
  if empty(l:name) | return | endif

  let l:path = expand($BASAL . '/' . l:name . '.md')
  if filereadable(l:path)
    echoerr "Basal: File already exists: " . l:path
    return
  endif

  let l:template_path = expand($BASAL . '/4_Templates/' . a:template_name)
  let l:content = readfile(l:template_path)
  
  " Create parent directories if needed
  let l:parent = fnamemodify(l:path, ':h')
  if !isdirectory(l:parent)
    call mkdir(l:parent, 'p')
  endif

  call writefile(s:process_template(l:content, l:name), l:path)
  execute 'e ' . l:path
endfunction

" Smart Daily Log creation
function! basal#daily()
  let l:date = strftime('%Y-%m-%d')
  let l:path = expand($BASAL . '/5_Daily/' . l:date . '.md')
  
  if !filereadable(l:path)
    let l:template_path = expand($BASAL . '/4_Templates/daily.md')
    let l:content = filereadable(l:template_path) ? readfile(l:template_path) : ['# Daily Log: ' . l:date]
    
    let l:parent = fnamemodify(l:path, ':h')
    if !isdirectory(l:parent) | call mkdir(l:parent, 'p') | endif
    
    call writefile(s:process_template(l:content, l:date), l:path)
  endif
  
  execute 'e ' . l:path
endfunction

" Find files linking to current note
function! basal#backlinks()
  let l:filename = fnamemodify(expand('%'), ':t:r')
  if empty(l:filename) | return | endif

  " Use character classes for literals to avoid backslash escaping issues across layers
  " Matches: [[filename]], (filename.md), or (filename)
  let l:pattern = '[[]' . l:filename . '[]]|[(]' . l:filename . '[.]md[)]|[(]' . l:filename . '[)]'
  call basal#search(l:pattern, 0)
endfunction

" Private: Replace placeholders in template content
function! s:process_template(lines, title)
  let l:processed = []
  let l:date = strftime('%Y-%m-%d')
  let l:title = fnamemodify(a:title, ':t:r')

  for l:line in a:lines
    let l:tmp = substitute(l:line, 'YYYY-MM-DD', l:date, 'g')
    let l:tmp = substitute(l:tmp, 'TITLE', l:title, 'g')
    call add(l:processed, l:tmp)
  endfor
  return l:processed
endfunction
