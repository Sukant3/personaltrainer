import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/models/program_model.dart';

class ProgramRepository {
  static const _key = 'saved_programs_v1';
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser?.uid ?? '';

  /// Loads programs from local cache first, then Firestore.
  /// If Firestore has new data, updates local cache automatically.
  Future<List<ProgramModel>> loadPrograms() async {
    final prefs = await SharedPreferences.getInstance();
    final localJson = prefs.getString(_key);
    List<ProgramModel> localPrograms = [];

    if (localJson != null) {
      try {
        localPrograms = ProgramModel.listFromJsonString(localJson);
      } catch (_) {
        localPrograms = [];
      }
    }

    // Try loading from Firestore (if logged in)
    if (_uid.isNotEmpty) {
      try {
        final snapshot = await _firestore
            .collection('users')
            .doc(_uid)
            .collection('programs')
            .get();

        if (snapshot.docs.isNotEmpty) {
          final cloudPrograms = snapshot.docs
              .map((d) => ProgramModel.fromJson(d.data()))
              .toList();

          // Update local cache with Firestore data
          await savePrograms(cloudPrograms);
          return cloudPrograms;
        } else {
          // If Firestore empty, upload local data if exists
          if (localPrograms.isNotEmpty) {
            await savePrograms(localPrograms);
          }
        }
      } catch (e) {
        print('⚠️ Firestore load error: $e');
      }
    }

    return localPrograms;
  }

  /// Saves list to local + Firestore.
  Future<void> savePrograms(List<ProgramModel> list) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = ProgramModel.listToJsonString(list);
    await prefs.setString(_key, jsonString);

    if (_uid.isNotEmpty) {
      final batch = _firestore.batch();
      final userRef = _firestore.collection('users').doc(_uid);

      for (final p in list) {
        final docRef = userRef.collection('programs').doc(p.id);
        batch.set(docRef, p.toJson());
      }

      await batch.commit();
    }
  }

  /// Adds or updates a single program
  Future<void> saveProgram(ProgramModel program) async {
    final all = await loadPrograms();
    final idx = all.indexWhere((p) => p.id == program.id);
    if (idx != -1) {
      all[idx] = program;
    } else {
      all.add(program);
    }
    await savePrograms(all);
  }

  /// Deletes a program locally and in Firestore
  Future<void> deleteProgram(String id) async {
    final all = await loadPrograms();
    all.removeWhere((p) => p.id == id);

    await savePrograms(all);

    if (_uid.isNotEmpty) {
      await _firestore
          .collection('users')
          .doc(_uid)
          .collection('programs')
          .doc(id)
          .delete();
    }
  }
}
