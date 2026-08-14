@echo on
setlocal

set "FORCE_CUDA=1"
set "IGNORE_TORCH_VER=1"
set "TORCH_CUDA_ARCH_LIST=7.5;8.0;8.6;8.9;9.0;10.0;12.0+PTX"

rem CUDA development packages install Windows import libraries under x64.
rem Remove once their activation adds this directory to the linker search path.
set "LIB=%PREFIX%\Library\lib\x64;%LIB%"

rem Remove the PyPI-only name to avoid pip/conda dependency mismatches.
powershell -NoProfile -Command "$files = 'tools/requirements.txt', 'tools/viz_requirements.txt'; foreach ($file in $files) { (Get-Content $file) | Where-Object { $_ -notmatch '^usd-core\s*([<>=].*)?$' } | Set-Content -Encoding ASCII $file }"
if errorlevel 1 exit /b 1

"%PYTHON%" -m pip install . -vv --no-deps --no-build-isolation
if errorlevel 1 exit /b 1
