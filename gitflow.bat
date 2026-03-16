```bat
@echo off
setlocal enabledelayedexpansion

REM ======================================================
REM CONFIGURACOES INICIAIS
REM ======================================================

REM Se for TRUE executa commits marcados com *
REM Se for FALSE apenas mostra o comando
set EXEC_COMMITS=TRUE

REM Caminho do pom.xml
set POM=pom.xml

echo ============================================
echo INICIANDO PROCESSO DE FECHAMENTO DE VERSAO
echo ============================================

REM ======================================================
REM 1 - CHECKOUT DEVELOP E ATUALIZA
REM ======================================================

echo.
echo [1] Indo para branch DEVELOP
git checkout develop

echo Atualizando develop
git pull

REM ======================================================
REM 2 - CHECKOUT MAIN E ATUALIZA
REM ======================================================

echo.
echo [2] Indo para branch MAIN
git checkout main

echo Atualizando main
git pull

REM ======================================================
REM 3 - MERGE DA DEVELOP NA MAIN
REM ======================================================

echo.
echo [3] Merge da develop na main
git merge develop

REM ======================================================
REM 4 - VERIFICAR VERSAO ATUAL
REM ======================================================

echo.
echo [4] Lendo versao atual do projeto

for /f "delims=" %%V in ('powershell -NoProfile -Command ^
 "[xml]$xml = Get-Content '%POM%'; $xml.project.version"') do set VERSAO=%%V

echo Versao atual encontrada: %VERSAO%

REM ======================================================
REM 5 - REMOVER SNAPSHOT PARA GERAR VERSAO FECHADA
REM ======================================================

echo.
echo [5] Removendo SNAPSHOT para gerar versao final

set VERSAO_FECHADA=%VERSAO:-SNAPSHOT=%

echo Nova versao fechada: %VERSAO_FECHADA%

mvn versions:set -DnewVersion=%VERSAO_FECHADA% -DgenerateBackupPoms=false

REM ======================================================
REM 6 - COMMIT DE FECHAMENTO *
REM ======================================================

echo.
echo [6] Commit de fechamento da versao

git add .

if /I "%EXEC_COMMITS%"=="TRUE" (
    git commit -m "fechamento da versao %VERSAO_FECHADA%"
) else (
    echo Commit ignorado (EXEC_COMMITS=FALSE)
)

REM ======================================================
REM 7 - GERAR TAG
REM ======================================================

echo.
echo [7] Criando TAG da versao

git tag %VERSAO_FECHADA%

REM ======================================================
REM 8 - COMMIT DA TAG *
REM ======================================================

echo.
echo [8] Commit da tag

if /I "%EXEC_COMMITS%"=="TRUE" (
    git push origin %VERSAO_FECHADA%
) else (
    echo Push da tag ignorado
)

REM ======================================================
REM 9 - GERAR NOVA VERSAO SNAPSHOT (MINOR +1)
REM ======================================================

echo.
echo [9] Gerando nova versao SNAPSHOT

for /f "tokens=1,2,3 delims=." %%a in ("%VERSAO_FECHADA%") do (
    set MAJOR=%%a
    set MINOR=%%b
    set PATCH=%%c
)

set /a MINOR+=1

set NOVA_SNAPSHOT=!MAJOR!.!MINOR!.0-SNAPSHOT

echo Nova versao: !NOVA_SNAPSHOT!

mvn versions:set -DnewVersion=!NOVA_SNAPSHOT! -DgenerateBackupPoms=false

REM ======================================================
REM 10 - COMMIT ABERTURA SNAPSHOT *
REM ======================================================

echo.
echo [10] Commit abertura da nova versao SNAPSHOT

git add .

if /I "%EXEC_COMMITS%"=="TRUE" (
    git commit -m "abertura da versao !NOVA_SNAPSHOT!"
) else (
    echo Commit SNAPSHOT ignorado
)

REM ======================================================
REM 11 - VOLTAR PARA DEVELOP
REM ======================================================

echo.
echo [11] Voltando para DEVELOP

git checkout develop

REM ======================================================
REM 12 - VERIFICAR SNAPSHOT ATUAL NA DEVELOP
REM ======================================================

echo.
echo [12] Lendo versao SNAPSHOT atual

for /f "delims=" %%V in ('powershell -NoProfile -Command ^
 "[xml]$xml = Get-Content '%POM%'; $xml.project.version"') do set DEV_VERSAO=%%V

echo Versao atual develop: %DEV_VERSAO%

REM ======================================================
REM 13 - GERAR NOVA SNAPSHOT PARA DEVELOP
REM ======================================================

echo.
echo [13] Gerando nova SNAPSHOT para develop

for /f "tokens=1,2,3 delims=." %%a in ("%DEV_VERSAO:-SNAPSHOT=%") do (
    set MAJOR=%%a
    set MINOR=%%b
    set PATCH=%%c
)

set /a MINOR+=1

set NOVA_DEV=!MAJOR!.!MINOR!.0-SNAPSHOT

echo Nova versao develop: !NOVA_DEV!

mvn versions:set -DnewVersion=!NOVA_DEV! -DgenerateBackupPoms=false

REM ======================================================
REM 14 - COMMIT SNAPSHOT DEVELOP *
REM ======================================================

echo.
echo [14] Commit abertura da versao develop

git add .

if /I "%EXEC_COMMITS%"=="TRUE" (
    git commit -m "abertura da versao !NOVA_DEV!"
) else (
    echo Commit develop ignorado
)

echo.
echo ============================================
echo PROCESSO FINALIZADO
echo ============================================

pause
```
