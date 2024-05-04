class Materia {
  String idMateria;
  String nombre;
  String semestre;
  String docente;

  Materia({
    required this.idMateria,
    required this.nombre,
    required this.semestre,
    required this.docente,
  });

  factory Materia.fromJson(Map<String, dynamic> json) {
    return Materia(
      idMateria: json['idMateria'],
      nombre: json['nombre'],
      semestre: json['semestre'],
      docente: json['docente'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idMateria': idMateria,
      'nombre': nombre,
      'semestre': semestre,
      'docente': docente,
    };
  }
}
