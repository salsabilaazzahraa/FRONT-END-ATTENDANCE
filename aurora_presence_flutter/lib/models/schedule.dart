// schedule.dart
class Person {
  String email;
  String name;
  String image;

  Person({required this.email, required this.name, required this.image});

  Map<String, dynamic> toJson() => {
    'email': email,
    'name': name,
    'image': image,
  };

  factory Person.fromJson(Map<String, dynamic> json) => Person(
    email: json['email'] ?? '',
    name: json['name'] ?? '',
    image: json['image'] ?? '',
  );
}

class TeamMember {
  final String name;
  final String image;

  TeamMember({required this.name, required this.image});

  Map<String, dynamic> toJson() => {
    'name': name,
    'image': image,
  };

  factory TeamMember.fromJson(Map<String, dynamic> json) => TeamMember(
    name: json['name'] ?? '',
    image: json['image'] ?? '',
  );
}

class Schedule {
  String title;
  String dateStart;
  String dateEnd;
  String timeStart;
  String timeEnd;
  List<Person> teams;
  String office;

  Schedule({
    required this.title,
    required this.dateStart,
    required this.dateEnd,
    required this.timeStart,
    required this.timeEnd,
    required this.teams,
    required this.office,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'dateStart': dateStart,
    'dateEnd': dateEnd,
    'timeStart': timeStart,
    'timeEnd': timeEnd,
    'teams': teams.map((team) => team.toJson()).toList(),
    'office': office,
  };

  factory Schedule.fromJson(Map<String, dynamic> json) {
    var teamsList = (json['teams'] as List?)?.map(
      (team) => Person.fromJson(team as Map<String, dynamic>)
    ).toList() ?? [];

    return Schedule(
      title: json['title'] ?? 'No Title',
      dateStart: json['dateStart'] ?? '',
      dateEnd: json['dateEnd'] ?? '',
      timeStart: json['timeStart'] ?? '',
      timeEnd: json['timeEnd'] ?? '',
      teams: teamsList,
      office: json['office'] ?? 'Unknown Office',
    );
  }
}