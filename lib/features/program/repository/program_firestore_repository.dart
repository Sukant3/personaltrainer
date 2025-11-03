import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/models/program_model.dart';

class ProgramFirestoreRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Get current user ID
  String get _uid => _auth.currentUser?.uid ?? '';

  // Load programs from Firestore
  Future<List<ProgramModel>> loadPrograms() async {
    if (_uid.isEmpty) return [];

    final snapshot = await _firestore
        .collection('users')
        .doc(_uid)
        .collection('programs')
        .get();

    return snapshot.docs
        .map((doc) => ProgramModel.fromJson(doc.data()))
        .toList();
  }

  // Save or update a single program
  Future<void> saveProgram(ProgramModel program) async {
    if (_uid.isEmpty) return;

    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('programs')
        .doc(program.id)
        .set(program.toJson());
  }

  // Delete a program
  Future<void> deleteProgram(String id) async {
    if (_uid.isEmpty) return;

    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('programs')
        .doc(id)
        .delete();
  }

  // Save multiple programs (used when seeding defaults)
  Future<void> savePrograms(List<ProgramModel> programs) async {
    if (_uid.isEmpty) return;

    final batch = _firestore.batch();
    final userRef = _firestore.collection('users').doc(_uid);

    for (final p in programs) {
      final ref = userRef.collection('programs').doc(p.id);
      batch.set(ref, p.toJson());
    }
    await batch.commit();
  }
}
