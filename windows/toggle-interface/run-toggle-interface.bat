@setlocal enableextensions
@cd /d "%~dp0"
:: A hack to get net-connect.py to be run as administrator.
:: Create a shortcut that always runs this batch file as administrator
	
C:\Python27\python.exe toggle-interface.py
pause
