class Exercise {
  final String id;
  final String name;
  final List<String> muscleGroup;
  final String equipment;
  final String difficulty;
  final String description;
  final List<String> cues;
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
    this.defaultReps = 10,
    this.defaultRest = 60,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      // ✅ Fix: handle both String and List for muscleGroup
      muscleGroup: json['muscleGroup'] is String
          ? [json['muscleGroup']]
          : List<String>.from(json['muscleGroup'] ?? []),
      equipment: json['equipment'] ?? '',
      difficulty: json['difficulty'] ?? '',
      description: json['description'] ?? '',
      // ✅ Fix: handle both String and List for cues
      cues: json['cues'] is String
          ? [json['cues']]
          : List<String>.from(json['cues'] ?? []),
      mediaUrl: json['mediaUrl'] ?? '',
      isVideo: json['isVideo'] ?? false,
      defaultReps: json['defaultReps'] ?? 10,
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
