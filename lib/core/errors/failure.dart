import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class Failure extends Equatable {
  final String message;
  final String id;

  Failure({required this.message, String? id}) : id = id ?? const Uuid().v4();

  @override
  List<Object?> get props => [message, id];
}
