if has("autocmd")
    " Make *.less appear as "less"
    autocmd BufRead,BufNewFile *.less set filetype=less

    " Enable bundles/plugins
    runtime! autoload/pathogen.vim

    if exists("g:loaded_pathogen")
        call pathogen#infect()
    endif
endif

packloadall

if has("ale")
    " Enable completion where available.
    " This setting must be set before ALE is loaded.
    "
    " You should not turn this setting on if you wish to use ALE as a completion
    " source for other completion plugins, like Deoplete.
    let g:ale_completion_enabled = 1

    " Set this. Airline will handle the rest.
    let g:airline#extensions#ale#enabled = 1

    " Disable to enable all ale_fixers by default
    let b:ale_fixers = {
      \ 'javascript': ['prettier', 'eslint'],
      \ 'typescript': ['prettier', 'tslint']
      \}

    " Show 5 lines of errors (default: 10)
    let g:ale_list_window_size = 5
endif

if has("autocmd")
    " Configure Nerdtree to make an explorer-like vim UI 
    let g:NERDTreeDirArrowExpandable = '▸'
    let g:NERDTreeDirArrowCollapsible = '▾'
    "autocmd vimenter * NERDTree
    map <C-o> :NERDTreeToggle<CR>
    let NERDTreeMapOpenInTab='<ENTER>'


    " NERDTress File highlighting
    function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
        exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
        exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
    endfunction

    call NERDTreeHighlightFile('jade', 'green', 'none', 'green', '#151515')
    call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#151515')
    call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')
    call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
    call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
    call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
    call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
    call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
    call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#151515')
    call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
    call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', '#151515')
    call NERDTreeHighlightFile('js', 'white', 'none', '#ffa500', '#151515')
    call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', '#151515')
    call NERDTreeHighlightFile('js.map', 'grey', 'none', 'grey', '#151515')
    call NERDTreeHighlightFile('json', 'grey', 'none', 'grey', '#151515')
    call NERDTreeHighlightFile('ts', 'white', 'none', 'white', '#151515')
    call NERDTreeHighlightFile('spec.ts', 'red', 'none', 'red', '#151515')
    call NERDTreeHighlightFile('less', 'cyan', 'none', 'cyan', '#151515')
endif

"
" I AM REALLY LAZY AND COPY THINGS FROM @fidian/bin WHEN VIMRC GETS COMPLEX
"

" Set tab and indent preferences
set expandtab tabstop=4 shiftwidth=4 softtabstop=4 smartindent autoindent

" Searching options
set incsearch ignorecase smartcase hlsearch

" Show matching brackets for a short time
set showmatch matchtime=2
set laststatus=2

" Allow backspace for everything
set backspace=indent,eol,start

" Turn on syntax highlighting and modelines
syntax on
set modeline

" Automatically set up per-filetype settings, like tag matching
filetype plugin indent on

" Automatically use spaces for YAML
autocmd Filetype yaml setlocal expandtab

" Turn on spell checking for Markdown
autocmd Filetype markdown setlocal spell! spelllang=en_us

" Control-arrow resizes splits
nnoremap <silent> <C-Right> <c-w>>
nnoremap <silent> <C-Left> <c-w><
nnoremap <silent> <C-Down> <c-w>+
nnoremap <silent> <C-Up> <c-w>-

" Split to the bottom right by default. Useful for :Se, :Se!, :Ex, :Ex!
set splitbelow
set splitright

" Change the sort sequence to directories first, then files (case sensitive)
let g:netrw_sort_sequence="\\/$"

" Show quotes in JSON files
let g:vim_json_syntax_conceal = 0

if has("autocmd")
    " Disable quickfix for TypeScript files and enable a tooltip
    let g:tsuquyomi_disable_quickfix = 1
    autocmd FileType typescript nnoremap <silent> <C-?> :echo tsuquyomi#hint()<CR>

    " Configure Syntastic syntax checking
    map <F5> :SyntasticToggleMode<CR>
    let g:syntastic_auto_jump=1
    let g:syntastic_auto_loc_list=1
    let g:syntastic_check_on_wq=0
    let g:syntastic_javascript_jslint_args="--es5=false"
    let g:syntastic_javascript_checkers=['eslint']
    let g:syntastic_javascript_eslint_exec='eslint_d'
    let g:syntastic_typescript_checkers=['tsuquyomi', 'tslint']
    let g:syntastic_html_checkers=['']

    " Insert <Tab> or complete identifier
    " if the cursor is after a keyword character
    function MyTabOrComplete()
        let col = col('.')-1
        if !col || getline('.')[col-1] !~ '\k'
            return "\<tab>"
        else
            return "\<C-N>"
        endif
    endfunction
    inoremap <Tab> <C-R>=MyTabOrComplete()<CR>

    autocmd FileType typescript setlocal completeopt+=menu,preview
endif

