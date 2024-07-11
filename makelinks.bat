@echo off

:: check for admin rights and try to elevate
whoami /groups | findstr /b BUILTIN\Administrators | findstr /c:"Enabled group" > NUL && goto :run
echo Running command as Administrator...
elevate "makelinks.bat" && goto :end
echo Failed to elevate. Try running this script as Administrator.
pause
goto :end

:run
@echo on
mklink %USERPROFILE%\.bash_profile %USERPROFILE%\.dotfiles\bash_profile
mklink %USERPROFILE%\.bashrc %USERPROFILE%\.dotfiles\bashrc
mklink %USERPROFILE%\.gitconfig %USERPROFILE%\.dotfiles\gitconfig
mklink %USERPROFILE%\.vimrc %USERPROFILE%\.dotfiles\vimrc
mkdir %USERPROFILE%\Documents\Powershell
mklink %USERPROFILE%\Documents\Powershell\Microsoft.PowerShell_profile.ps1 %USERPROFILE%\.dotfiles\Microsoft.PowerShell_profile.ps1
@echo off
pause

:end
