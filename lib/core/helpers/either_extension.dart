import 'package:fpdart/fpdart.dart';

extension EitherExtension<L, R> on Either<L, R> {
  R? getR() => fold<R?>((_) => null, (r) => r);
  L? getL() => fold<L?>((l) => l, (_) => null);
}
