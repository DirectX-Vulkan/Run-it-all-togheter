@echo off

echo [32m[1mBenchmark setup...[0m
echo.

set /p NAME=Whats your name (reference-name)?(default:pc_name):
set /p GRAPH=Console or Graphs data (c/g)?(default:g):
set SHOWGRAPH=1==1

set RUNTIME=30
set OBJ[0].model=cat.obj
set OBJ[0].texture=cat.jpg
set OBJ[1].model=suzanne.obj
set OBJ[1].texture=suzanne.png
set OBJ[2].model=viking_room.obj
set OBJ[2].texture=viking_room.png

IF "%RUNTIME%"=="" (set RUNTIME=10)
IF "%NAME%"=="" (set NAME="pc_name")
IF "%GRAPH:~0,1%"=="c" (set SHOWGRAPH=1==2)

echo.
echo Benchmark parameters: runtime: %RUNTIME% seconds, reference-name: %NAME%
echo Diagnostic parameters: %GRAPH%



echo.
echo.|set /p="[93mBenchmark starting in: "
timeout /t 1 /nobreak > NUL
echo.|set /p="2"
timeout /t 1 /nobreak > NUL
echo.|set /p="-1 [0m"
timeout /t 1 /nobreak > NUL
echo.
echo Objects:

FOR /L %%i IN (0 1 2) DO (
	call echo  %%i %%OBJ[%%i].model%% %%OBJ[%%i].texture%%
	
	set MODEL=%%OBJ[%%i].model%%
	set TEXTURE=%%OBJ[%%i].texture%%

	call echo  %%i %%MODEL%% %TEXTURE%

	echo.
	echo [32m[1mStarting DirectX benchmark[0m

	echo 

	DirectX.exe %NAME% %RUNTIME% models/%OBJ[%%i].model% textures/%OBJ[%%i].texture%
	IF "%errorlevel%"=="0" (
		echo Benchmark DirectX ran succesfully
	) ELSE (
		echo [91m[1mBenchmark DirectX exited with exitcode %errorlevel%[0m
	)

	echo.
	echo [32m[1mStarting Vulkan benchmark[0m

	Vulkan.exe %NAME% %RUNTIME% models/%OBJ[%%i].model% textures/%OBJ[%%i].texture%
	IF "%errorlevel%"=="0" (
		echo Benchmark Vulkan ran succesfully
	) ELSE (
		echo [91m[1mBenchmark Vulkan exited with exitcode %errorlevel%[0m
	)
)

echo.
echo [32m[1mStarting Diagonstic service benchmark[0m
IF %SHOWGRAPH%  (
	Graphs.exe 
) ELSE (
	Graphs.exe -c
)

IF "%errorlevel%"=="0" (		
	echo Diagnostic service exited succesfully (0)
) ELSE (
	echo [91m[1mDiagnostic service exited with exitcode %errorlevel%[0m
)

pause
