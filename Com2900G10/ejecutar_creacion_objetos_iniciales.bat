@echo off
setlocal enabledelayedexpansion

:: Configuración
set SERVER=lucas\SQLEXPRESS
set DATABASE=master
set SCRIPT_DIR=C:\Users\lucas\OneDrive\Escritorio\repositories\monardop\cadena-supermercado\Com2900G10\Principal

:: Lista de archivos .sql a ejecutar (separados por espacios)
set FILE_LIST=CreationFile.sql

:: Cambiar al directorio donde están los scripts
cd /d "%SCRIPT_DIR%"

:: Iterar sobre los archivos en la lista
for %%f in (%FILE_LIST%) do (
    if exist "%%f" (
        echo Ejecutando %%f...
        sqlcmd -S %SERVER% -d %DATABASE% -E -i "%%f" > resultado.txt 2>&1

        :: Verificar si hubo un error
        findstr /i "Msg " resultado.txt > nul
        if !errorlevel! equ 0 (
            echo Error ejecutando %%f. Verifique el archivo resultado.txt
            goto :error
        ) else (
            echo %%f ejecutado exitosamente.
        )
        echo.
    ) else (
        echo El archivo %%f no existe en %SCRIPT_DIR%.
        goto :error
    )
)

:: Mensaje final
echo Todos los scripts se ejecutaron con exito.
goto :end

:error
echo Hubo un error en la ejecucion de los scripts.
pause

:end
endlocal
pause
