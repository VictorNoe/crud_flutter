import 'package:equatable/equatable.dart';
import '../../data/models/car_model.dart';

abstract class CarState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CarInitial extends CarState{}

class CarLoading extends CarState{}

class CarSuccess extends CarState{
  final List<CarModel> car;

  CarSuccess({required this.car});

  @override
  List<Object?> get props => [car];
}

class CarError extends CarState{
  final String message;

  CarError({required this.message});

  @override
  List<Object?> get props => [message];
}