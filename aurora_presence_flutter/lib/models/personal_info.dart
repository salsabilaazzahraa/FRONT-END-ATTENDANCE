class PersonalInfo {
  final String name;
  final String phoneNumber;
  final String email;
  final String dob;
  final String gender;
  final String address;
  final String emergencyPhone;
  final String employeeID;
  final String department;
  final String position;

  PersonalInfo({
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.dob,
    required this.gender,
    required this.address,
    required this.emergencyPhone,
    required this.employeeID,
    required this.department,
    required this.position,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'dob': dob,
      'gender': gender,
      'address': address,
      'emergencyPhone': emergencyPhone,
      'employeeID': employeeID,
      'department': department,
      'position': position,
    };
  }

  static PersonalInfo fromMap(Map<String, dynamic> map) {
    return PersonalInfo(
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      email: map['email'] ?? '',
      dob: map['dob'] ?? '',
      gender: map['gender'] ?? '',
      address: map['address'] ?? '',
      emergencyPhone: map['emergencyPhone'] ?? '',
      employeeID: map['employeeID'] ?? '',
      department: map['department'] ?? '',
      position: map['position'] ?? '',
    );
  }
}