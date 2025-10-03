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

git config --global diff.context 3
git config --global diff.renames copies
git config --global diff.interHunkContext 10

git config --global pager.branch false
git config --global pager.diff "diff-so-fancy | \$PAGER"

git config --global blame.coloring highlightRecent
git config --global blame.date relative

git config --global log.abbrevCommit true
git config --global color.ui true
git config --global color.graph blue
git config --global color.graph yellow
git config --global color.graph cyan
git config --global color.graph magenta
git config --global color.graph green
git config --global color.graph red

git config --global color.branch.current magenta
git config --global color.branch.local default
git config --global color.branch.remote yellow
git config --global color.branch.upstream green
git config --global color.branch.plain blue

git config --global color.blame.highlightRecent "black bold,1 year ago,white,1 month ago,default,7 days ago,blue"

git config --global color.diff.meta "black bold"
git config --global color.diff.frag magenta
git config --global color.diff.context white
git config --global color.diff.whitespace "yellow reverse"

git config --global interactive.diffFilter "diff-so-fancy --patch"
git config --global interactive.singlekey true

git config --global url.git@github.com:.insteadOf "gh:"

git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
git config --global alias.undo "reset HEAD~1 --mixed"
git config --global alias.branches "branch --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) %(color:green)(%(committerdate:relative)) [%(authorname)]' --sort=-committerdate"
git config --global alias.last "log -1 HEAD --stat"
git config --global alias.wip "!f() { git add --all && git commit -m 'work in progress'; }; f"
git config --global alias.nah '!f() { git reset --hard; if [[ $1 == "-f" ]]; then git clean -df; fi; }; f'

echo -e '${GREEN}XX -- Git done.${NC}'
