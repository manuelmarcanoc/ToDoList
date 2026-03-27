import subprocess
import os

keytool_path = r'C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe'
keystore_path = r'C:\Users\Manuel\.android\debug.keystore'

cmd = [
    keytool_path,
    '-list', '-v',
    '-keystore', keystore_path,
    '-alias', 'androiddebugkey',
    '-storepass', 'android',
    '-keypass', 'android'
]

print(f"Running: {' '.join(cmd)}")

try:
    result = subprocess.run(cmd, capture_output=True, text=True, check=True)
    print("--- SUCCESS ---")
    print(result.stdout)
except subprocess.CalledProcessError as e:
    print("--- ERROR ---")
    print(e.stdout)
    print(e.stderr)
except Exception as e:
    print(f"--- FAILURE ---: {e}")
