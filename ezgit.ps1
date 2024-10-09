# Check if gum is installed
if (-not (Get-Command gum -ErrorAction SilentlyContinue)) {
    Write-Error "gum is not installed. Please install gum first."
    exit 1
}

$header = 
"               _ _
  ___ ______ _(_| |_
 / _ |_  / _` | | __|
|  __// | (_| | | |_
 \___/___\__, |_|\__|
         |___/"
Write-Output $header

while ($true) {
    # Use gum to display a menu for git actions
    $action = gum choose "Commit" "Status" "Stash" "Push" "Pull" "Fetch" "Branch" "Merge" "Init" "Help" "Exit" --header "Select a git action"
    
    switch ($action) {
        "Commit" { 
            $commitMessage = gum input --placeholder "Enter commit message"
            if ($commitMessage) {
                gum confirm "Do you want to commit with message: ${commitMessage}?" && git add . && git commit -m $commitMessage
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
            $branchAction = gum choose "Create" "Switch" "Delete" "Exit" --header "Select a branch action"
            
            switch ($branchAction) {
                "Create" {
                    $branchName = gum input --placeholder "Enter new branch name"
                    if ($branchName) {
                        gum confirm "Do you want to create a new branch: ${branchName}?" && git switch -c $branchName
                    }
                    elseif ($branchName -eq "") {
                        Write-Host "Branch creation cancelled."
                    }
                    else {
                        Write-Error "No branch name entered."
                    }
                }
                "Switch" {
                    # Get the list of branches
                    $branches = git branch --format="%(refname:short)"
                    $branches += "Exit"
                    $branchName = gum choose $branches --header "Select a branch to switch to"
                    if ($branchName -eq "Exit") {
                        Write-Host "Branch switching cancelled."
                    }
                    elseif ($branchName) {
                        git switch $branchName
                    }
                    else {
                        Write-Error "No branch selected."
                    }
                }
                "Delete" {
                    # Get the list of branches
                    $branches = git branch --format="%(refname:short)"
                    $branches += "Exit"
                    $branchName = gum choose $branches --header "Select a branch to delete"
                    if ($branchName -eq "Exit") {
                        Write-Host "Branch deletion cancelled."
                    }
                    elseif ($branchName) {
                        gum confirm "Do you want to delete the branch ${branchName}?" && git branch -d $branchName
                    }
                    else {
                        Write-Error "No branch selected."
                    }
                }
                "Exit" {
                    Write-Host "Branch action cancelled."
                }
            }
        }
        "Merge" {
            # Get the list of branches
            $branches = git branch --format="%(refname:short)"
            $branches += "Exit"
            $mergeTo = gum choose $branches --header "Select a branch to merge into"
            if ($mergeTo -eq "Exit") {
                Write-Host "Branch merging cancelled."
            }
            elseif ($mergeTo) {
    
                $mergeFrom = gum choose $branches --header "Select a branch to merge from"
                if ($mergeFrom -eq "Exit") {
                    Write-Host "Branch merging cancelled."
                }
                elseif ($mergeFrom) {
                    gum confirm "Do you want to merge ${mergeFrom} > ${mergeTo}?" && git checkout $mergeTo && git merge $mergeFrom
                    if ($LASTEXITCODE -eq 0) {
                        $deleteBranch = gum confirm "Merge successful. Do you want to delete the branch ${mergeFrom}?"
                        if ($deleteBranch) {
                            git branch -d $mergeFrom
                        }
                    }
                }
                else {
                    Write-Error "No branch selected."
                }
            }
            else {
                Write-Error "No branch selected."
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
}
