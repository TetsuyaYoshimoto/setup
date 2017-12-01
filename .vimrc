
	" release autogroup in MyAutoCmd
augroup MyAutoCmd
	autocmd!
augroup END

syntax on
colorscheme desert


" バックスペースでなんでも消せるようにする
set backspace=indent,eol,start
set clipboard=unnamedplus

" Swap,Backup 全て無効化
set nowritebackup
set nobackup
set noswapfile
set mouse=a
set number              " 行番号の表示
set scrolloff=5
set laststatus=2   " ステータス行を常に表示
set cmdheight=1    " メッセージ表示欄1行確保
set shiftwidth=3
set tabstop=3
set showmatch           " 対応する括弧などをハイライト表示する
set matchtime=3         " 対応括弧のハイライト表示を3秒にする
set cindent
set textwidth=0

imap { {}<Left>
imap [ []<Left>
imap ( ()<Left>
imap :: ''<Left>
imap < <><Left>



let s:noplugin = 0
let s:bundle_root = expand('~/.vim/bundle')
let s:neobundle_root = s:bundle_root . '/neobundle.vim'
if !isdirectory(s:neobundle_root) || v:version < 702
	let s:noplugin = 1
else
	if has('vim_starting')
  		execute "set runtimepath+=" . s:neobundle_root
 	endif
	call neobundle#begin(s:bundle_root)

	" NeoBundle自身をNeoBundleで管理させる
	NeoBundleFetch 'Shougo/neobundle.vim'
	
	NeoBundle has('lua') ? 'Shougo/neocomplete' : 'Shougo/neocomplcache'
  	if neobundle#is_installed('neocomplete')
		" neocomplete用設
		let g:neocomplete#enable_at_startup = 1
		let g:neocomplete#enable_ignore_case = 1
		let g:neocomplete#enable_smart_case = 1
		if !exists('g:neocomplete#keyword_patterns')
	  		let g:neocomplete#keyword_patterns = {}
  		endif
		let g:neocomplete#keyword_patterns._= '\h\w*'
	elseif neobundle#is_installed('neocomplcache')
		" neocomplcache用設定
      let g:neocomplcache_enable_at_startup = 1
  		let g:neocomplcache_enable_ignore_case = 1
  		let g:neocomplcache_enable_smart_case = 1
  		if	!exists('g:neocomplcache_keyword_patterns')
			let g:neocomplcache_keyword_patterns = {}
		endif
		let g:neocomplcache_keyword_patterns = '\h\w*'
  		let g:neocomplcache_enable_camel_case_completion = 1
  		let g:neocomplcache_enable_underbar_completion = 1
	endif
	inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
	inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
	 
	NeoBundle "thinca/vim-quickrun"
	let g:quickrun_config = {'*': {'hook/time/enable': '1'},}

	NeoBundle 'vim-jp/cpp-vim'	

	NeoBundleLazy "lambdalisue/vim-django-support", {
				\ "autoload": {
				\   "filetypes": ["python", "python3", "djangohtml"]
				\ }}

	NeoBundleLazy "jmcantrell/vim-virtualenv", {
	  			\ "autoload": {
				\   "filetypes": ["python", "python3", "djangohtml"]
				\ }}

	NeoBundle "davidhalter/jedi-vim", {
				\ "autoload": {
				\   "filetypes": ["python", "python3", "djangohtml"],
				\ },
				\ "build": {
				\   "mac": "pip install jedi",
				\   "unix": "pip install jedi",
				\ }}
	let s:hooks = neobundle#get_hooks("jedi-vim")
	function! s:hooks.on_source(bundle)
 		" jediにvimの設定を任せると'completeopt+=preview'するので
		" 自動設定機能をOFFにし手動で設定を行う
		let g:jedi#auto_vim_configuration = 0
	 	" 補完の最初の項目が選択された状態だと使いにくいためオフにする
		let g:jedi#popup_select_first = 0
	   " quickrunと被るため大文字に変更
  		" let g:jedi#rename_command = '<Leader>R'
    	" gundoと被るため大文字に変更 (2013-06-24 10:00 追記）
		" let g:jedi#goto_command = '<Leader>G'
	endfunction

	autocmd FileType python setlocal omnifunc=jedi#completions
	if !exists('g:neocomplete#force_omni_input_patterns')
		let g:neocomplete#force_omni_input_patterns = {}
	endif
	let g:neocomplete#force_omni_input_patterns.python = '\h\w*\|[^. \t]\.\w*'
	autocmd FileType python setlocal completeopt-=preview

	NeoBundle "scrooloose/nerdtree"
	noremap /// :NERDTreeToggle

	NeoBundle "tyru/caw.vim"
	" コメントアウト
	nmap :cc <Plug>(caw:zeropos:toggle)
	vmap :cc <Plug>(caw:zeropos:toggle)

	" 解除
	nmap :CC <Plug>(caw:zeropos:uncomment)
	vmap :CC <Plug>(caw:zeropos:uncomment)

	NeoBundleCheck
endif

call neobundle#end()

filetype plugin indent on
