@echo off
git init
git add .
git commit -m "Entrega: Aplicacion ToDo List en Flutter con Firebase"
git branch -M main
rem Ignoramos el error si no existe origin
git remote remove origin 2>nul
git remote add origin https://github.com/manuelmarcanoc/ToDoList.git
git push -u origin main
