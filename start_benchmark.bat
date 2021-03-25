@echo off

echo [32m[1mBenchmark setup...[0m
echo.
set /p RUNTIME=How long does the benchmark needs to run (seconds)?(default:10):
set /p NAME=Whats your name (reference-name)?(default:pc_name):
set /p MODEL=Whats the model name?(default:viking_room.obj):
set /p TEXTURE=Whats the texture name?(default:viking_room.png):
set /p GRAPH=Console, graph data or both(a) (c/g/a)?(default:a):

IF "%RUNTIME%"=="" (set RUNTIME=10)
IF "%NAME%"=="" (set NAME="pc_name")
IF "%MODEL%"=="" (set MODEL="viking_room.obj")
IF "%TEXTURE%"=="" (set TEXTURE="viking_room.png")
IF "%GRAPH%"=="" (set GRAPH="a")

echo.
echo Benchmark parameters: runtime: %RUNTIME% seconds, reference-name: %NAME%, model-name: models/%MODEL%, texture-name: textures/%TEXTURE%
echo Diagnostic parameters: %GRAPH%


echo.
echo.|set /p="[93mBenchmark starting in: "
timeout /t 1 /nobreak > NUL
echo.|set /p="3"
timeout /t 1 /nobreak > NUL
echo.|set /p="-2"
timeout /t 1 /nobreak > NUL
echo.|set /p="-1 [0m"
timeout /t 1 /nobreak > NUL

echo.
echo [32m[1mStarting DirectX benchmark[0m

DirectX.exe %NAME% %RUNTIME% models/%MODEL% textures/%TEXTURE%
IF "%errorlevel%"=="0" (
	echo Benchmark DirectX exited succesfully
) ELSE (
	echo [91m[1mBenchmark DirectX exited with exitcode %errorlevel%[0m
)

echo.
echo [32m[1mStarting Vulkan benchmark[0m

Vulkan.exe %NAME% %RUNTIME% models/%MODEL% textures/%TEXTURE%
IF "%errorlevel%"=="0" (
	echo Benchmark Vulkan exited succesfully
) ELSE (
	echo [91m[1mBenchmark Vulkan exited with exitcode %errorlevel%[0m
)

echo.
echo [32m[1mStarting Diagonstic service benchmark[0m
IF "%SHOWGRAPH%"=="g"  (
	Graphs.exe 
) ELSE IF "%SHOWGRAPH%"=="c" (
	Graphs.exe -c
) ELSE (
	Graphs.exe --console
)

IF "%errorlevel%"=="0" (		
	echo Diagnostic service exited succesfully
) ELSE (
	echo [91m[1mDiagnostic service exited with exitcode %errorlevel%[0m
)

pause