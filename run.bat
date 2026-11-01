@echo off
setlocal EnableExtensions

title Chanh Dien Online - Bear
set "ROOT=%~dp0"
set "LIVE=%~dp0live"

where node >nul 2>nul
if errorlevel 1 (
  echo [LOI] Chua tim thay Node.js. Cai Node.js 20 tro len roi chay lai.
  pause
  exit /b 1
)

where npm >nul 2>nul
if errorlevel 1 (
  echo [LOI] Chua tim thay npm. Cai Node.js 20 tro len roi chay lai.
  pause
  exit /b 1
)

if not exist "%LIVE%\node_modules\ws" (
  echo [1/3] Dang cai dependency cho LIVE...
  pushd "%LIVE%"
  call npm install
  if errorlevel 1 (
    echo [LOI] npm install that bai.
    popd
    pause
    exit /b 1
  )
  popd
)

echo [2/3] Dang kiem tra cong 3000 va khoi dong server LIVE...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr /r ":3000\>" ^| findstr LISTENING') do taskkill /f /pid %%a >nul 2>nul
start "Chanh Dien LIVE" /D "%LIVE%" cmd /k npm start

echo [3/3] Dang mo web tinh tai http://localhost:4173 ...
start "Chanh Dien Web" /D "%ROOT%" cmd /k npx --yes serve . -l 4173

timeout /t 3 /nobreak >nul
start "" "http://localhost:4173"
start "" "http://localhost:3000/live/control.html"

echo.
echo Da mo xong.
echo Web:     http://localhost:4173
echo Control: http://localhost:3000/live/control.html
echo Overlay: http://localhost:3000/live/overlay.html
echo Dong hai cua so server de dung ung dung.
timeout /t 5 /nobreak >nul
endlocal
