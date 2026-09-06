@echo off
REM pin - installation Windows.
REM Copie pin -> %%LOCALAPPDATA%%\pin\pin.py, crée un wrapper pin.cmd
REM et ajoute le dossier au PATH utilisateur.

setlocal
set "BAT_DIR=%~dp0"
set "INSTALL_DIR=%LOCALAPPDATA%\pin"
set "SRC=%BAT_DIR%pin"

if not exist "%SRC%" (
    echo Erreur : fichier "pin" introuvable a cote d'install.bat.
    exit /b 1
)

where python >nul 2>nul
if errorlevel 1 (
    echo Erreur : Python introuvable. Installez-le depuis https://www.python.org/downloads/
    echo et cochez "Add Python to PATH".
    exit /b 1
)

if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

copy /Y "%SRC%" "%INSTALL_DIR%\pin.py" >nul

REM Wrapper pin.cmd : python "…\pin.py" %*
> "%INSTALL_DIR%\pin.cmd" echo @echo off
>> "%INSTALL_DIR%\pin.cmd" echo python "%%~dp0pin.py" %%*

REM Ajout au PATH utilisateur
setx PATH "%PATH%;%INSTALL_DIR%" >nul
if errorlevel 1 (
    echo Attention : impossible de modifier le PATH automatiquement.
    echo Ajoutez %INSTALL_DIR% manuellement :
    echo   Parametres ^> Systeme ^> Parametres avances ^> Variables d'environnement
) else (
    echo PATH mis a jour. Ouvrez un NOUVEAU terminal pour utiliser "pin".
)

echo.
echo Installe : %INSTALL_DIR%\pin.cmd
echo.
echo Utilisation :
echo   pin -s ^<lien tableau^>
echo   pin -d ^<lien tableau^> ^<dossier^>
echo   pin -h
echo.
echo Si "pin" n'est pas reconnu, lancez directement :
echo   python "%INSTALL_DIR%\pin.py" -s ^<lien tableau^>
echo   python "%INSTALL_DIR%\pin.py" -d ^<lien tableau^> ^<dossier^>
echo.
echo NB : si vous aviez deja un PATH tres long, verifiez qu'il n'a pas ete
echo tronque (Systeme ^> Variables d'environnement), sinon ajoutez le dossier
echo ci-dessus manuellement.

endlocal
