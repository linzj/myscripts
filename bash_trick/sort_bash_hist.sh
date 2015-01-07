cat .bash_history | nl|sort -k 2|uniq -f 1|sort -n|cut -f 2
