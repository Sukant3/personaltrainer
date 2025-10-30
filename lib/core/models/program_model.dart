// simple program model used by the UI
import 'dart:convert';

import '../../core/models/exercise_model.dart';

class ProgramModel {
  final String id;
  String name;
  String description;
  List<Exercise> exercises; // references exercise objects for simplicity
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
        'exercises': exercises.map((e) => {
          'id': e.id,
          'name': e.name,
          'muscleGroup': e.muscleGroup,
          'equipment': e.equipment,
          'difficulty': e.difficulty,
          'description': e.description,
          'cues': e.cues,
          'mediaUrl': e.mediaUrl,
          'isVideo': e.isVideo,
          'defaultReps': e.defaultReps,
          'defaultRest': e.defaultRest,
        }).toList(),
        'splitType': splitType,
      };

  factory ProgramModel.fromJson(Map<String, dynamic> json) {
    final exList = (json['exercises'] as List<dynamic>?)
            ?.map((e) => Exercise(
                  id: e['id'] ?? '',
                  name: e['name'] ?? '',
                  muscleGroup: e['muscleGroup'] ?? '',
                  equipment: e['equipment'] ?? '',
                  difficulty: e['difficulty'] ?? '',
                  description: e['description'] ?? '',
                  cues: e['cues'] ?? '',
                  mediaUrl: e['mediaUrl'] ?? '',
                  isVideo: e['isVideo'] ?? false,
                  defaultReps: e['defaultReps'] ?? 8,
                  defaultRest: e['defaultRest'] ?? 60,
                ))
            .toList() ??
        [];

    return ProgramModel(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Untitled',
      description: json['description'] ?? '',
      exercises: exList,
      splitType: json['splitType'] ?? 'Custom',
    );
  }

  static List<ProgramModel> listFromJsonString(String jsonString) {
    final arr = json.decode(jsonString) as List<dynamic>;
    return arr.map((e) => ProgramModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  static String listToJsonString(List<ProgramModel> list) {
    final arr = list.map((p) => p.toJson()).toList();
    return json.encode(arr);
  }
}
