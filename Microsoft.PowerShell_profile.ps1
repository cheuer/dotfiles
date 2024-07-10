Set-PSReadlineKeyHandler -Key Tab -Function Complete
set-alias npp "C:\Program Files\Notepad++\notepad++.exe"
function manage{
	poetry run python manage.py $args
}
function testall{
	poetry run pytest --create-db --functional --unit --integration --cov --cov-report=xml --disable-warnings $args
	poetry run pytest --reuse-db --functional --unit --integration --cov --cov-report=xml --disable-warnings $args
}

oh-my-posh init pwsh --config ~/.dotfiles/ohmyposhv3.json | Invoke-Expression
