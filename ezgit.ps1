# Check if gum is installed
if (-not (Get-Command gum -ErrorAction SilentlyContinue)) {
    Write-Error "gum is not installed. Please install gum first."
    exit 1
}

# Create a cool header for ezgit
$header = 
"               _ _
  ___ ______ _(_| |_
 / _ |_  / _` | | __|
|  __// | (_| | | |_
 \___/___\__, |_|\__|
         |___/"
Write-Output $header

# Use gum to display a menu for git actions
$action = gum choose "Commit" "Status" "Stash" "Push" "Pull" "Fetch" "Branch" "Init" "Help" "Exit" --header "Select a git action"

switch ($action) {
    "Commit" { 
        $commitMessage = gum input --placeholder "Enter commit message"
        if ($commitMessage) {
            git add .
            git commit -m $commitMessage
        }
        else {
            Write-Error "No commit message entered."
        }
    }
    "Status" { 
        git status
    }
    "Stash" { 
        git stash
    }
    "Push" { 
        git push
    }
    "Pull" { 
        git pull
    }
    "Fetch" { 
        git fetch
    }
    "Branch" {
        # Use gum to display a menu for branch actions
        $branchAction = gum choose "Create" "Switch" "Delete" --header "Select a branch action"
        
        switch ($branchAction) {
            "Create" {
                $branchName = gum input --placeholder "Enter new branch name"
                if ($branchName) {
                    git branch $branchName
                    git checkout $branchName
                }
                else {
                    Write-Error "No branch name entered."
                }
            }
            "Switch" {
                $branchName = gum input --placeholder "Enter branch name to switch to"
                if ($branchName) {
                    git checkout $branchName
                }
                else {
                    Write-Error "No branch name entered."
                }
            }
            "Delete" {
                $branchName = gum input --placeholder "Enter branch name to delete"
                if ($branchName) {
                    git branch -d $branchName
                }
                else {
                    Write-Error "No branch name entered."
                }
            }
        }
    }
    "Init" {
        git init
    }
    "Help" {
        # Read and display the contents of GitHelp.md
        Get-Content -Path "GitHelp.md" -Raw | gum format -t markdown
    }
    "Exit" {
        exit 0
    }
    Default {}
}