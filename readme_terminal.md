# General
## Packages
```bash
apt-cache search qt | grep designer // Search apt and grep results for specific package  
apt-cache show designer-qt6 // show info about the package 
```

## Git
You can amend the last commit to include your changes:
```bash
git add team_provision.tf
git commit --amend --no-edit #(This will add the file to the last commit without changing the commit message)
```
You can stash a specific file with a message, to bring it back after applying other changes like switching branch or pulling changes ie.
Temporarily saves changes made to the filename file, allowing you to switch branches or work on other tasks without committing. The stash is labeled with the message "comment" for easy identification. You can later reapply these changes using git stash apply.
```bash
git stash -m "comment" -- filename
```
