import 'dart:io';

void main() async {
  final keytoolPat = r'C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe';
  final keystorePath = r'C:\Users\Manuel\.android\debug.keystore';
  
  print('Iniciando extracción con: $keytoolPat');
  print('Ruta del KeyStore: $keystorePath');

  try {
    final result = await Process.run(keytoolPat, [
      '-list',
      '-v',
      '-keystore', keystorePath,
      '-alias', 'androiddebugkey',
      '-storepass', 'android',
      '-keypass', 'android'
    ]);

    if (result.exitCode == 0) {
      print('--- RESULTADO ---');
      print(result.stdout);
    } else {
      print('--- ERROR ---');
      print(result.stderr);
      print('Exit code: ${result.exitCode}');
    }
  } catch (e) {
    print('Error ejecutando el proceso: $e');
  }
}
