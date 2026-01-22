# Use ctrl arrows to navigate "partial" history
#bind '"\e[1;5A":history-search-backward'
#bind '"\e[1;5B":history-search-forward'
bind '"\e[1;5C":forward-word'
bind '"\e[1;5D":backward-word'

# Like ls but also with numeric (octal) permissions
alias lll='stat -c "%A (%a)  %G  %U   %n"'

# Sync master with origin
alias gitsync='git fetch origin master:master'

alias lock='sleep 1; xset dpms force off'

alias ks='echo common typo'
alias c='echo common typo'

# Delete those pesky .orig files git makes
#alias gitcleaner="find . -type f -name '*.orig' -exec rm -vf {} ';'"

# Like above but send to system trash instead of delete forever
alias gitcleaner="find . -type f -name '*.orig' -exec trash-put {} ';' -exec echo trashed {} ';'"

alias pipog='pip'
alias pip='uv pip'
alias pip3='uv pip'
alias emacs="emacs -nw"
