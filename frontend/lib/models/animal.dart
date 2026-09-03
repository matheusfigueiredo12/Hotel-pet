class Animal {
  final String? id;
  final String tutorName;
  final String tutorContact;
  final String species; // 'Cachorro' ou 'Gato'
  final String breed;
  final DateTime entryDate;
  final DateTime? expectedExitDate;
  final int? diariasAteAgora;
  final int? diariasTotaisPrevistas;

  Animal({
    this.id,
    required this.tutorName,
    required this.tutorContact,
    required this.species,
    required this.breed,
    required this.entryDate,
    this.expectedExitDate,
    this.diariasAteAgora,
    this.diariasTotaisPrevistas,
  });

  static DateTime _parseDate(String value) {
    return DateTime.parse(value);
  }

  static String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
      id: json['id'] as String?,
      tutorName: json['tutorName'] as String,
      tutorContact: json['tutorContact'] as String,
      species: json['species'] as String,
      breed: json['breed'] as String,
      entryDate: _parseDate(json['entryDate'] as String),
      expectedExitDate: json['expectedExitDate'] != null
          ? _parseDate(json['expectedExitDate'] as String)
          : null,
      diariasAteAgora: json['diariasAteAgora'] as int?,
      diariasTotaisPrevistas: json['diariasTotaisPrevistas'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tutorName': tutorName,
      'tutorContact': tutorContact,
      'species': species,
      'breed': breed,
      'entryDate': _formatDate(entryDate),
      'expectedExitDate':
          expectedExitDate != null ? _formatDate(expectedExitDate!) : null,
    };
  }
}
