import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final String uid;
  FirestoreService({required this.uid});

  // Referencia a la subcolección de tareas del usuario actual
  // Ruta: usuaris/{uid}/tasques/
  late final CollectionReference _tasquesCollection = FirebaseFirestore.instance
      .collection('usuaris')
      .doc(uid)
      .collection('tasques');

  // Añadir una nueva tarea
  Future<void> addTasca(String titol) async {
    await _tasquesCollection.add({
      'titol': titol,
      'estaCompletada': false,
      'dataCreacio': FieldValue.serverTimestamp(),
    });
  }

  // Obtener el stream de tareas ordenadas por fecha
  Stream<QuerySnapshot> get tasques {
    return _tasquesCollection
        .orderBy('dataCreacio', descending: true)
        .snapshots();
  }

  // Actualizar el estado de una tarea
  Future<void> updateTascaStatus(String id, bool status) async {
    return await _tasquesCollection.doc(id).update({
      'estaCompletada': status,
    });
  }

  // Borrar una tarea
  Future<void> deleteTasca(String id) async {
    return await _tasquesCollection.doc(id).delete();
  }
}
