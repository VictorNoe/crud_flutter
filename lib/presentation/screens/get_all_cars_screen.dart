import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/car_model.dart';
import '../../data/repository/car_repository.dart';
import '../cubit/car_cubit.dart';
import '../cubit/car_state.dart';

class CarListView extends StatelessWidget {
  const CarListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car List', style: TextStyle(fontSize: 18, color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: BlocProvider(
        create: (context) => CarCubit(
          carRepository: RepositoryProvider.of<CarRepository>(context),
        ),
        child: const CarListScreen(),
      ),
    );
  }
}

class CarListScreen extends StatefulWidget {
  const CarListScreen({super.key});

  @override
  _CarListScreenState createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CarListScreen> {
  late CarCubit carCubit;

  @override
  void initState() {
    super.initState();
    carCubit = BlocProvider.of<CarCubit>(context);
    carCubit.fetchAllCar(); // Fetch cars when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<CarCubit, CarState>(
              builder: (context, state) {
                if (state is CarLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CarSuccess) {
                  final cars = state.car;
                  return ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: cars.length,
                    itemBuilder: (context, index) {
                      final car = cars[index];
                      return Card(
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: Icon(Icons.directions_car, color: Colors.deepPurple),
                          title: Text(
                            car.marca,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Modelo: ${car.modelo}'),
                              Text('Velocidad Máxima: ${car.velocidadMaxima} km/h'),
                              Text('Autonomía: ${car.autonomia} km'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.deepPurple),
                                onPressed: () {
                                  _showUpdateCarDialog(context, car, carCubit);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  carCubit.deleteCar(car.id.toString());
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is CarError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                return const Center(child: Text('Press the button to fetch cars'));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _showCreateCarDialog(context, carCubit);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Agregar auto', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateCarDialog(BuildContext context, CarCubit carCubit) {
    final marcaController = TextEditingController();
    final modeloController = TextEditingController();
    final velocidadMaximaController = TextEditingController();
    final autonomiaController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Añadir auto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: marcaController,
                decoration: InputDecoration(labelText: 'Marca'),
              ),
              TextField(
                controller: modeloController,
                decoration: InputDecoration(labelText: 'Modelo'),
              ),
              TextField(
                controller: velocidadMaximaController,
                decoration: InputDecoration(labelText: 'Velocidad Máxima'),
              ),
              TextField(
                controller: autonomiaController,
                decoration: InputDecoration(labelText: 'Autonomía'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Añadir'),
              onPressed: () {
                final newCar = CarModel(
                  marca: marcaController.text,
                  modelo: modeloController.text,
                  velocidadMaxima: velocidadMaximaController.text,
                  autonomia: autonomiaController.text,
                );
                carCubit.createCar(newCar);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showUpdateCarDialog(BuildContext context, CarModel car, CarCubit carCubit) {
    final marcaController = TextEditingController(text: car.marca);
    final modeloController = TextEditingController(text: car.modelo);
    final velocidadMaximaController = TextEditingController(text: car.velocidadMaxima);
    final autonomiaController = TextEditingController(text: car.autonomia);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Actualizar auto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: marcaController,
                decoration: InputDecoration(labelText: 'Marca'),
              ),
              TextField(
                controller: modeloController,
                decoration: InputDecoration(labelText: 'Modelo'),
              ),
              TextField(
                controller: velocidadMaximaController,
                decoration: InputDecoration(labelText: 'Velocidad Máxima'),
              ),
              TextField(
                controller: autonomiaController,
                decoration: InputDecoration(labelText: 'Autonomía'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Actualizar'),
              onPressed: () {
                final updatedCar = CarModel(
                  id: car.id,
                  marca: marcaController.text,
                  modelo: modeloController.text,
                  velocidadMaxima: velocidadMaximaController.text,
                  autonomia: autonomiaController.text,
                );
                carCubit.updateUser(updatedCar);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}