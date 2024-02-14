import '../provider/post_provider.dart';
import '/src/model/estado_provider.dart';

class ProviderModel {
  Failure? failure;

  void setFailure(Failure failure) {
    failure = failure;
  }

  EstadoProvider _estado = EstadoProvider.initial;
  EstadoProvider get estado => _estado;
  void setEstado(EstadoProvider estado) {
    _estado = estado;
  }

  reiniciar() {
    setEstado(EstadoProvider.initial);
  }
}
