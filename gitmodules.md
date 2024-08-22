# Git module commands

Command	Description
git submodule add <repository-url> <path>	Adds a new submodule to your project at the specified path.
git clone --recurse-submodules <repository-url>	Clones the main repository and initializes & updates all submodules recursively.
git submodule update --init --recursive	Initializes any new submodules and updates all submodules to the commits specified in the main project.
git submodule update --remote --recursive	Updates all submodules to the latest commits on their default branches (potentially different from what's specified in the main project).
cd <submodule-path>	Navigate into the submodule directory.
Standard Git commands (e.g., git checkout, git pull, git commit, git push)	Make changes within the submodule as you would in a regular repository.
git add <submodule-path>	Stage the changes to the submodule's commit reference in the main project.
git commit -m "Updated submodule"	Commit the changes to the main project.
git submodule status	Shows the status of each submodule (current commit, any local changes).
git submodule foreach <command>	Executes a Git command in each submodule.
git submodule deinit <submodule-path>	De-initializes a submodule (removes its special status, but keeps the files).
git rm <submodule-path>	Removes a submodule completely (including its files).

Eksporter til Regneark
Key Points (Formatted)

Submodules are essentially separate Git repositories embedded within your main project.
Changes within a submodule need to be committed both within the submodule itself and in the main project to be fully tracked.
Use --recursive with git submodule update and other commands to handle nested submodules.
Be careful when making changes directly in a submodule, as it can affect other projects that use the same submodule.
