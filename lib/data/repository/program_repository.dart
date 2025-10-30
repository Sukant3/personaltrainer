import 'package:shared_preferences/shared_preferences.dart';
import '../../core/models/program_model.dart';

class ProgramRepository {
  static const _key = 'saved_programs_v1';

  Future<List<ProgramModel>> loadPrograms() async {
    final sp = await SharedPreferences.getInstance();
    final jsonString = sp.getString(_key);
    if (jsonString == null) return [];
    try {
      return ProgramModel.listFromJsonString(jsonString);
    } catch (_) {
      return [];
    }
  }

  Future<void> savePrograms(List<ProgramModel> list) async {
    final sp = await SharedPreferences.getInstance();
    final jsonString = ProgramModel.listToJsonString(list);
    await sp.setString(_key, jsonString);
  }
}
