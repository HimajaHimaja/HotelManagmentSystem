@echo off
echo  = = = = =  x  = = = = =
echo - P R O J E C T   H M S -
echo  = = = = =  x  = = = = =

echo - - - - - - - - - - - - - - - - -
set /p msg=Commit message: 
echo - - - - - - - - - - - - - - - - -

echo - - - - - - - - - - - - - - - - -
git add .
echo - - - - - - - - - - - - - - - - -
git commit -m "%msg%"

echo Commit is Completed
echo Push Status [Not Checked]

echo.
echo Done.
