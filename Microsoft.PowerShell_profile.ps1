Set-PSReadlineKeyHandler -Key Tab -Function Complete

set-alias npp "C:\Program Files\Notepad++\notepad++.exe"

function ga {git add $args}
function gd {git.exe diff $args}
function gds {git.exe diff --staged $args}
function gf {git.exe fetch $args}
function gh {git.exe hist $args}
function gs {git.exe status -uno $args}

function manage{
	poetry run python manage.py $args
}
function testall{
	poetry run pytest --create-db --functional --unit --integration --cov --cov-report=xml --disable-warnings $args
	poetry run pytest --reuse-db --functional --unit --integration --cov --cov-report=xml --disable-warnings $args
}
function retest{
	poetry run pytest --reuse-db --functional --unit --integration --cov --cov-report=xml --disable-warnings --last-failed
}

oh-my-posh init pwsh --config ~/.dotfiles/ohmyposhv3.json | Invoke-Expression

# disable venv prompt
$env:VIRTUAL_ENV_DISABLE_PROMPT=1
