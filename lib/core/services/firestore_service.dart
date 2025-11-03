import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/exercise_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ✅ Get current user id
  String get uid => _auth.currentUser!.uid;

  // -------------------------------------------------------------
  // 🟢 Create user document when they register
  Future<void> createUserDocument(String email, String name) async {
    final userDoc = _db.collection('users').doc(uid);
    final snapshot = await userDoc.get();

    if (!snapshot.exists) {
      await userDoc.set({
        'email': email,
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // -------------------------------------------------------------
  // 🟡 Add Exercise for current user
  Future<void> addExercise(Exercise exercise) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('exercises')
        .doc(exercise.id)
        .set(exercise.toJson());
  }

  // -------------------------------------------------------------
  // 🟠 Get all exercises for the current user
  Stream<List<Exercise>> getUserExercises() {
    return _db
        .collection('users')
        .doc(uid)
        .collection('exercises')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Exercise.fromJson(doc.data()))
            .toList());
  }

  // -------------------------------------------------------------
  // 🔴 Delete an exercise
  Future<void> deleteExercise(String exerciseId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('exercises')
        .doc(exerciseId)
        .delete();
  }
}
