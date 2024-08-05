import 'package:bloc/bloc.dart';
import '../../data/models/car_model.dart';
import '../../data/repository/car_repository.dart';
import 'car_state.dart';

class CarCubit extends Cubit<CarState> {
  final CarRepository carRepository;

  CarCubit({required this.carRepository}) : super(CarInitial());

  Future<void> createCar(CarModel car) async {
    try {
      emit(CarLoading());
      await carRepository.createCar(car);
      final cars = await carRepository.getAllCar();
      emit(CarSuccess(car: cars));
    } catch (e) {
      emit(CarError(message: e.toString()));
    }
  }

  Future<void> getCar(String id) async {
    try {
      emit(CarLoading());
      final car = await carRepository.getCar(id);
      emit(CarSuccess(car: [car]));
    } catch (e) {
      emit(CarError(message: e.toString()));
    }
  }

  Future<void> updateUser(CarModel car) async {
    try {
      emit(CarLoading());
      await carRepository.updateCar(car);
      final cars = await carRepository.getAllCar();
      emit(CarSuccess(car: cars));
    } catch (e) {
      emit(CarError(message: e.toString()));
    }
  }

  Future<void> deleteCar(String id) async {
    try {
      emit(CarLoading());
      await carRepository.deleteCar(id);
      final cars = await carRepository.getAllCar();
      emit(CarSuccess(car: cars));
    } catch (e) {
      emit(CarError(message: e.toString()));
    }
  }

  Future<void> fetchAllCar() async {
    try {
      emit(CarLoading());
      final cars = await carRepository.getAllCar();
      emit(CarSuccess(car: cars));
    } catch (e) {
      emit(CarError(message: e.toString()));
    }
  }
}