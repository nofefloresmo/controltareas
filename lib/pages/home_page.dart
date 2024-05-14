import 'package:flutter/material.dart';
import '../models/tarea.dart';
import '../models/materia.dart';
import '../controllers/tareaDB.dart';
import '../controllers/materiaDB.dart';
import '../controllers/conexion.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión Académica',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [TareaPage(), MateriaPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(_selectedIndex == 0 ? "Lista de Tareas" : "Lista de Materias"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text('Tec Tepic'),
              accountEmail: Text('tecnologico@tecnm.mx'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/logo/tec.png'),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/fondo/header.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('Tareas'),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Materias'),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}

class TareaPage extends StatefulWidget {
  @override
  _TareaPageState createState() => _TareaPageState();
}

class _TareaPageState extends State<TareaPage> {
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _fechaEntregaController = TextEditingController();
  String? _selectedMateriaId;

  List<Tarea> _tareas = [];
  List<Materia> _materias = [];

  @override
  void initState() {
    super.initState();
    _loadData();
    // Conexion.deleteDB();
  }

  Future<void> _loadData() async {
    List<Materia> resultadoMaterias = await MateriaDB.getMaterias();
    List<Tarea> resultadoTareas = await TareaDB.getTareas();
    setState(() {
      _materias = resultadoMaterias;
      if (_materias.isNotEmpty) {
        _selectedMateriaId = _materias.first.idMateria;
      }
      _tareas = resultadoTareas;
    });
  }

  Future<void> _showAddTaskDialog() async {
    if (_materias.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Por favor, añade materias antes de crear tareas.")));
      return;
    }

    _descripcionController.clear();
    _fechaEntregaController.clear();

    var result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Agregar nueva tarea"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _descripcionController,
                  decoration: const InputDecoration(labelText: "Descripción"),
                ),
                TextField(
                  controller: _fechaEntregaController,
                  decoration:
                      const InputDecoration(labelText: "Fecha de Entrega"),
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: "Materia"),
                  value: _selectedMateriaId,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedMateriaId = newValue;
                    });
                  },
                  items: _materias
                      .map<DropdownMenuItem<String>>((Materia materia) {
                    return DropdownMenuItem<String>(
                      value: materia.idMateria,
                      child: Text(materia.nombre),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_descripcionController.text.isEmpty ||
                    _fechaEntregaController.text.isEmpty ||
                    _selectedMateriaId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Todos los campos son obligatorios.")));
                  return;
                } else {
                  Navigator.pop(context, true);
                }
              },
              child: const Text("Agregar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancelar"),
            ),
          ],
        );
      },
    );

    if (result == true) {
      try {
        final newTarea = Tarea(
          idMateria: _selectedMateriaId!,
          fEntrega: _fechaEntregaController.text,
          descripcion: _descripcionController.text,
        );
        await TareaDB.insertTarea(newTarea);
        _loadData();
        _descripcionController.clear();
        _fechaEntregaController.clear();
      } catch (e) {
        print('Error al insertar tarea: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error al insertar tarea: $e'),
        ));
      }
    }
  }

  void _addNewTask() async {
    try {
      final newTarea = Tarea(
        idMateria: _selectedMateriaId!,
        fEntrega: _fechaEntregaController.text,
        descripcion: _descripcionController.text,
      );
      await TareaDB.insertTarea(newTarea);
      _loadData();
      _descripcionController.clear();
      _fechaEntregaController.clear();
    } catch (e) {
      print('Error al insertar tarea: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al insertar tarea: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _tareas.length,
        itemBuilder: (context, index) {
          final tarea = _tareas[index];
          return Dismissible(
            key: Key(tarea.idTarea.toString()),
            onDismissed: (direction) async {
              await TareaDB.deleteTarea(tarea.idTarea!);
              setState(() {
                _tareas.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Tarea eliminada")),
              );
            },
            background: Stack(
              alignment: Alignment.centerRight,
              children: <Widget>[
                Container(color: Colors.red),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
              ],
            ),
            child: ListTile(
              title: Text(tarea.descripcion),
              subtitle: Text("Fecha de Entrega: ${tarea.fEntrega}"),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        tooltip: 'Agregar Tarea',
        child: Icon(Icons.add),
      ),
    );
  }
}

class MateriaPage extends StatefulWidget {
  @override
  _MateriaPageState createState() => _MateriaPageState();
}

class _MateriaPageState extends State<MateriaPage> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _semestreController = TextEditingController();
  final TextEditingController _docenteController = TextEditingController();

  List<Materia> _materias = [];

  @override
  void initState() {
    super.initState();
    _loadMaterias();
  }

  void _loadMaterias() async {
    _materias = await MateriaDB.getMaterias();
    setState(() {});
  }

  void _showAddMateriaDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Agregar nueva materia"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: "Nombre"),
              ),
              TextField(
                controller: _semestreController,
                decoration: const InputDecoration(labelText: "Semestre"),
              ),
              TextField(
                controller: _docenteController,
                decoration: const InputDecoration(labelText: "Docente"),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                _addNewMateria();
                Navigator.of(context).pop();
              },
              child: const Text("Agregar"),
            ),
          ],
        );
      },
    );
  }

  void _addNewMateria() async {
    final newMateria = Materia(
      idMateria: DateTime.now().millisecondsSinceEpoch.toString(),
      nombre: _nombreController.text,
      semestre: _semestreController.text,
      docente: _docenteController.text,
    );
    await MateriaDB.insertMateria(newMateria);
    _loadMaterias();
    _nombreController.clear();
    _semestreController.clear();
    _docenteController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _materias.length,
        itemBuilder: (context, index) {
          final materia = _materias[index];
          return Dismissible(
            key: Key(materia.idMateria),
            onDismissed: (direction) async {
              await MateriaDB.deleteMateria(materia.idMateria);
              setState(() {
                _materias.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Materia eliminada")),
              );
            },
            background: Container(color: Colors.red),
            child: ListTile(
              title: Text(materia.nombre),
              subtitle: Text(
                  "Semestre: ${materia.semestre}, Docente: ${materia.docente}"),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMateriaDialog,
        tooltip: 'Agregar Materia',
        child: const Icon(Icons.add),
      ),
    );
  }
}
