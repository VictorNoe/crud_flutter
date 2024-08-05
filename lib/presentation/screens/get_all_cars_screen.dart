import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/car_repository.dart';
import '../cubit/car_cubit.dart';
import '../cubit/car_state.dart';

class CarListView extends StatelessWidget {
  const CarListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
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
    final carCubit = BlocProvider.of<CarCubit>(context); //

    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            carCubit.fetchAllCar();
          },
          child: const Text('Fetch Users'),
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
                    );
                  },
                );
              } else if (state is CarError) {
                return Center(child: Text('Error: ${state.message}'));
              }
              return const Center(child: Text('Press the button to fetch users'));
            },
          ),
        ),
      ],
    );
  }
}
