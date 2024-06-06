#!/bin/zsh

echo 'Configuring git'
echo 

echo -e 'What is your github author name?'
read git_author_name
echo -e 'What is your github user email?'
read git_author_email

echo

git config --global user.name $git_author_name
git config --global user.email $git_author_email

git config --global core.excludesfile $HOME/.gitignore
git config --global core.editor vim
git config --global core.autocrlf input

git config --global init.defaultBranch master
git config --global pull.rebase true
git config --global push.default current

git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
git config --global alias.undo "reset HEAD~1 --mixed"
git config --global alias.branches "branch --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) %(color:green)(%(committerdate:relative)) [%(authorname)]' --sort=-committerdate"
git config --global alias.last "log -1 HEAD --stat"
git config --global alias.last "git add --all && git commit -m 'work in progress'"

echo -e '${GREEN}XX -- Git done.${NC}'
