#!/bin/bash

current_branch=$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
if [ "$current_branch" != "master" ]; then
  echo "WARNING: You are on branch $current_branch, NOT master."
fi
echo -e "Fetching merged branches...\n"

git remote update --prune
remote_branches=$(git branch -r --merged | grep -v '/master$' | grep -v "/$current_branch$")
local_branches=$(git branch --merged | grep -v 'master$' | grep -v "$current_branch$")
if [ -z "$remote_branches" ] && [ -z "$local_branches" ]; then
  echo "No existing branches have been merged into $current_branch."
else
  echo "This will remove the following branches:"
  if [ -n "$remote_branches" ]; then
echo "$remote_branches"
  fi
  if [ -n "$local_branches" ]; then
echo "$local_branches"
  fi
  read -p "Continue? (y/n): " -n 1 choice
  echo
  if [ "$choice" == "y" ] || [ "$choice" == "Y" ]; then
    remotes=`echo "$remote_branches" | sed 's/\(.*\)\/\(.*\)/\1/g' | sort -u`
# Remove remote branches
for remote in $remotes
do
        branches=`echo "$remote_branches" | grep "$remote/" | sed 's/\(.*\)\/\(.*\)/:\2 /g' | tr -d '\n'`
        git push $remote $branches 
done

# Remove local branches
git branch -d `git branch --merged | grep -v 'master$' | grep -v "$current_branch$" | sed 's/origin\///g' | tr -d '\n'`
  else
echo "No branches removed."
  fi
fi
