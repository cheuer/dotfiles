# bash-like shortcuts
Set-PSReadlineKeyHandler -Key Tab -Function Complete
Set-PSReadLineKeyHandler -Key Alt+b -Function ShellBackwardWord
Set-PSReadLineKeyHandler -Key Alt+f -Function ShellForwardWord
Set-PSReadLineKeyHandler -Key Alt+B -Function SelectShellBackwardWord
Set-PSReadLineKeyHandler -Key Alt+F -Function SelectShellForwardWord
Set-PSReadLineKeyHandler -Key Ctrl+k -Function ForwardDeleteInput

set-alias npp "C:\Program Files\Notepad++\notepad++.exe"
set-alias grep rg

function ga {git add $args}
function gc {git commit -v $args}
function gd {git.exe diff $args}
function gds {git.exe diff --staged $args}
function gf {git.exe fetch $args}
function gg {git.exe hist $args}
function gs {git.exe status $args}

function manage{
	poetry run python manage.py $args
}
function testall{
	poetry run pytest --create-db --functional --unit --integration --disable-warnings $args && poetry run pytest --reuse-db --functional --unit --integration --cov --cov-report=xml --disable-warnings $args
}
function retest{
	poetry run pytest --reuse-db --functional --unit --integration --cov --cov-report=xml --disable-warnings --last-failed $args
}

function token{
	C:\Users\chris\git\jf2\.venv\Scripts\python C:\Users\chris\git\jf2\scripts\database-token.py chris | clip
}

function apply{
	[regex]::Replace((Get-Clipboard -Raw), "`r`n", "`n", "Singleline") | git apply --ignore-whitespace && echo "Patch from clipboard applied"
}

function cloudwatch-logs{
	$app, $rest = $args
	aws logs tail "/ecs/$app" --follow --color on $rest
}

oh-my-posh init pwsh --config ~/.dotfiles/ohmyposhv3.json | Invoke-Expression

# disable venv prompt
$env:VIRTUAL_ENV_DISABLE_PROMPT=1

Import-Module posh-git
Import-Module CompletionPredictor

# fix up/down in python shells https://github.com/microsoft/terminal/issues/2558#issuecomment-2069286909
py -c "import ctypes; ctypes.windll.kernel32.SetConsoleHistoryInfo(b'\x10\x00\x00\x00\x00\x02\x00\x00 \x00\x00\x00\x01\x00\x00\x00')"

# Don't add to history if short or common https://stackoverflow.com/a/52818502
$addToHistoryHandler = {
    Param([string]$line)
    if ($line.Length -le 3) {
        return $false
    }
    if (@("exit","dir","ls","pwd","cd ..").Contains($line.ToLowerInvariant())) {
        return $false
    }
    return $true
}
Set-PSReadlineOption -AddToHistoryHandler $addToHistoryHandler


# Remove history items with shift+del https://stackoverflow.com/a/77959050
Set-PSReadLineKeyHandler -Chord Shift+Delete -Description "Search through the history and remove lines starting with entered text" -ScriptBlock {
    $in = ''
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref] $in, [ref] $null)

    if ([string]::IsNullOrWhiteSpace($in)) {
        return
    }

    $historyPath = (Get-PSReadLineOption).HistorySavePath

    # only way to "refresh" the history in the current session is to clear it
    [Microsoft.PowerShell.PSConsoleReadLine]::ClearHistory()
    $content = [System.IO.File]::ReadAllLines($historyPath)
    Clear-Content $historyPath

    foreach ($line in $content) {
        if ($line.StartsWith($in, [System.StringComparison]::InvariantCultureIgnoreCase)) {
            continue
        }

        # and re-add it (excluding the line to remove)
        [Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($line)
    }

    [Microsoft.PowerShell.PSConsoleReadLine]::DeleteLine()
}

# Define keyboard shortcut Alt-V to paste the current clipboard
# content as a verbatim here-string.
Set-PSReadLineKeyHandler 'alt+v' -ScriptBlock {
  [Microsoft.PowerShell.PSConsoleReadLine]::Insert("@'`n`n'@")
  foreach ($i in 1..3) { [Microsoft.PowerShell.PSConsoleReadLine]::BackwardChar() }
  [Microsoft.PowerShell.PSConsoleReadLine]::Insert((Get-Clipboard -Raw))
  foreach ($i in 1..3) { [Microsoft.PowerShell.PSConsoleReadLine]::ForwardChar() }
}
