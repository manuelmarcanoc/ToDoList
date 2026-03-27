import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class HomeScreen extends StatefulWidget {
  final String uid;
  const HomeScreen({super.key, required this.uid});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  late final FirestoreService _firestore;
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    _firestore = FirestoreService(uid: widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Tareas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async => await _auth.signOut(),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: 'Nueva tarea...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    if (_controller.text.isNotEmpty) {
                      await _firestore.addTasca(_controller.text);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.tasques,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Padding(padding: const EdgeInsets.all(16), child: Text('Error: ${snapshot.error}', textAlign: TextAlign.center)));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Aún no tienes tareas. ¡Añade una!'));
                }
                var docs = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var data = docs[index].data() as Map<String, dynamic>;
                    return ListTile(
                      leading: Checkbox(
                        value: data['estaCompletada'] ?? false,
                        onChanged: (val) async {
                          await _firestore.updateTascaStatus(docs[index].id, val ?? false);
                        },
                      ),
                      title: Text(
                        data['titol'],
                        style: TextStyle(
                          decoration: data['estaCompletada'] == true 
                              ? TextDecoration.lineThrough 
                              : TextDecoration.none,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async => await _firestore.deleteTasca(docs[index].id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
