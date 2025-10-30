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
    this.defaultReps = 10,
    this.defaultRest = 60,
  });
}
