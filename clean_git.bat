@echo off
git rm -r --cached "android/app/google-services.json"
git rm -r --cached "lib/firebase_options.dart"
git commit --amend -m "Entrega: Aplicacion ToDo List en Flutter con Firebase"
git push -u origin main --force
