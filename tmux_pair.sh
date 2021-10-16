#!/bin/bash

tmpDir=$(mktemp -d /tmp/tmux-XXXX)
set -e

# Create bottom sessions
tmux -S $tmpDir/b1 new-session -d -e TMUX_PAIR_PROGRAMMING=1
tmux -S $tmpDir/b2 new-session -d -e TMUX_PAIR_PROGRAMMING=1

# Create top sessions
tmux -S $tmpDir/t1 new-session -d \; split-window -d -h \; send-keys -t%0 "tmux -S $tmpDir/b1 attach" C-m \; send-keys -t%1 "tmux -S $tmpDir/b2 attach" C-m \; select-pane -R
tmux -S $tmpDir/t2 new-session -d \; split-window -d -h \; send-keys -t%0 "tmux -S $tmpDir/b1 attach" C-m \; send-keys -t%1 "tmux -S $tmpDir/b2 attach" C-m

# If no $HOME/.vimrc or it doesn't have TMUX_PAIR_PROGRAMMING, then add it at the end
test -f $HOME/.vimrc && grep TMUX_PAIR_PROGRAMMING $HOME/.vimrc &>/dev/null || {
echo "Updating $HOME/.vimrc"
cat >> $HOME/.vimrc << EOF

" TMUX_PAIR_PROGRAMMING
" how to run it:
" vim z.c --cmd "set noswapfile" -c "source ~/.vim/source/tmux.vim"
" autocmd SwapExists * let v:swapchoice = "e"
if(\$TMUX_PAIR_PROGRAMMING == 1)
    function! SharedUpdate(timer)
        checktime
        if len(expand("%"))
            update
        endif
    endfunction

    let x = timer_start(200, 'SharedUpdate', {"repeat": -1})

    set noswapfile
    set cursorline
    set cursorcolumn
    set autoread
endif
EOF
}

echo "Connect to session with 'tmux -S $tmpDir/t1 attach' or 'tmux -S $tmpDir/t2 attach'."
