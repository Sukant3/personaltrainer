import 'dart:convert';
import '../../core/models/exercise_model.dart';

class ProgramModel {
  final String id;
  String name;
  String description;
  List<Exercise> exercises; // Each exercise is a full object
  String splitType; // e.g., "PPL", "Push", "Pull", "Legs", "Full"

  ProgramModel({
    required this.id,
    required this.name,
    required this.description,
    required this.exercises,
    required this.splitType,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'exercises': exercises.map((e) => e.toJson()).toList(),
        'splitType': splitType,
      };

  factory ProgramModel.fromJson(Map<String, dynamic> json) {
    final exercisesData = json['exercises'];
    List<Exercise> exerciseList = [];

    if (exercisesData is List) {
      exerciseList = exercisesData
          .map((e) => Exercise.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    return ProgramModel(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Untitled',
      description: json['description'] ?? '',
      exercises: exerciseList,
      splitType: json['splitType'] ?? 'Custom',
    );
  }

  static List<ProgramModel> listFromJsonString(String jsonString) {
    final arr = json.decode(jsonString) as List<dynamic>;
    return arr
        .map((e) => ProgramModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  static String listToJsonString(List<ProgramModel> list) {
    final arr = list.map((p) => p.toJson()).toList();
    return json.encode(arr);
  }
}
