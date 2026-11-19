class Character {
  final int index;
  final String fullName;
  final String nickname;
  final String hogwartsHouse;
  final String interpretedBy;
  final List<String> children;
  final String image;
  final String birthdate;

  Character({
    required this.index,
    required this.fullName,
    required this.nickname,
    required this.hogwartsHouse,
    required this.interpretedBy,
    required this.children,
    required this.image,
    required this.birthdate,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      index: json['index'] ?? 0,
      fullName: json['fullName'] ?? '',
      nickname: json['nickname'] ?? '',
      hogwartsHouse: json['hogwartsHouse'] ?? 'Unknown',
      interpretedBy: json['interpretedBy'] ?? '',
      children: json['children'] != null
          ? List<String>.from(json['children'].map((x) => x.toString()))
          : [],
      image: json['image'] ?? '',
      birthdate: json['birthdate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'fullName': fullName,
      'nickname': nickname,
      'hogwartsHouse': hogwartsHouse,
      'interpretedBy': interpretedBy,
      'children': children,
      'image': image,
      'birthdate': birthdate,
    };
  }
}
