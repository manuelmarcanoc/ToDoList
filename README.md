# To-Do List (Flutter + Firebase)
Aplicación de Lista de Tareas desarrollada en Flutter con autenticación y persistencia de datos en Firebase (Cloud Firestore y Firebase Auth).

## Características
* **Autenticación**: Registro e inicio de sesión con correo y contraseña. Acceso con Google.
* **Privacidad**: Cada usuario tiene su propia lista de tareas separada en Firestore (`usuaris/{uid}/tasques`).
* **Tiempo Real**: Las tareas se reflejan inmediatamente usando `StreamBuilder`.
* **Funcionalidad CRUD**: Permite agregar nuevas tareas, marcarlas como completadas y eliminarlas.
