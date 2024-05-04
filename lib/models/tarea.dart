class Tarea {
  int? idTarea;
  String idMateria;
  String fEntrega;
  String descripcion;

  Tarea(
      {this.idTarea,
      required this.idMateria,
      required this.fEntrega,
      required this.descripcion});

  factory Tarea.fromJson(Map<String, dynamic> json) {
    return Tarea(
      idTarea: json['idTarea'],
      idMateria: json['idMateria'],
      fEntrega: json['fEntrega'],
      descripcion: json['descripcion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idTarea != null) 'idTarea': idTarea,
      'idMateria': idMateria,
      'fEntrega': fEntrega,
      'descripcion': descripcion,
    };
  }
}
