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
        title: const Text('Car List'),
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

class CarListScreen extends StatelessWidget {
  const CarListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final carCubit = BlocProvider.of<CarCubit>(context);

    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            carCubit.fetchAllCar();
          },
          child: const Text('Fetch Cars'),
        ),
        Expanded(
          child: BlocBuilder<CarCubit, CarState>(
            builder: (context, state) {
              if (state is CarLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CarSuccess) {
                final cars = state.car;
                return ListView.builder(
                  itemCount: cars.length,
                  itemBuilder: (context, index) {
                    final car = cars[index];
                    return ListTile(
                      title: Text(car.marca),
                      subtitle: Text(car.modelo),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _showUpdateCarDialog(context, car, carCubit);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              carCubit.deleteCar(car.id.toString());
                            },
                          ),
                        ],
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
        ElevatedButton(
          onPressed: () {
            _showCreateCarDialog(context, carCubit);
          },
          child: const Text('Add Car'),
        ),
      ],
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
          title: Text('Create Car'),
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
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Create'),
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
          title: Text('Update Car'),
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
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Update'),
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
