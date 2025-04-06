import 'package:fpdart/fpdart.dart';

import '../errors/failure.dart';

abstract class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}
