// lib/core/models/exercise_model.dart

class Exercise {
  final String id;
  final String name;
  final String muscleGroup;
  final String equipment;
  final String difficulty;
  final String description;
  final String cues;
  final String mediaUrl;
  final bool isVideo;
  final int defaultReps;
  final int defaultRest;

  Exercise({
    required this.id,
    required this.name,
    required this.muscleGroup,
    required this.equipment,
    required this.difficulty,
    required this.description,
    required this.cues,
    required this.mediaUrl,
    this.isVideo = false,
    this.defaultReps = 8,
    this.defaultRest = 60,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      muscleGroup: json['muscleGroup'] ?? '',
      equipment: json['equipment'] ?? '',
      difficulty: json['difficulty'] ?? 'Beginner',
      description: json['description'] ?? '',
      cues: json['cues'] ?? '',
      mediaUrl: json['mediaUrl'] ?? '',
      isVideo: json['isVideo'] ?? false,
      defaultReps: json['defaultReps'] ?? 8,
      defaultRest: json['defaultRest'] ?? 60,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'muscleGroup': muscleGroup,
        'equipment': equipment,
        'difficulty': difficulty,
        'description': description,
        'cues': cues,
        'mediaUrl': mediaUrl,
        'isVideo': isVideo,
        'defaultReps': defaultReps,
        'defaultRest': defaultRest,
      };
}
