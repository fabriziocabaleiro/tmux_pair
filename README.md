# tmux_pair
Tmux/Vim setup for pair working

## How to use it
$ bash tmux\_pair.sh

The script will print out the command to connect to the tmux session, each user should connect to it's own session.

## How it works
The script creates 4 tmux servers, two of them are nested into the other two, by doing this we can have two tmux panes visible on the same window but being controlled at the same time by different users.
