import 'categoria.dart';
import 'registro_campo.dart';

abstract interface class RegistroRepository {
  Future<List<RegistroCampo>> listar();

  Future<RegistroCampo?> buscarPorId(String id);

  Future<List<Categoria>> listarCategorias();

  Future<void> inserir(RegistroCampo registro);

  Future<void> atualizar(RegistroCampo registro);

  Future<void> remover(String id);
}