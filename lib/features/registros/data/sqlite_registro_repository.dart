import 'package:projeto/features/registros/domain/categoria.dart';
import 'package:projeto/features/registros/domain/registro_campo.dart';
import 'package:projeto/features/registros/domain/registro_repository.dart';
import 'registro_dao.dart';

class SqliteRegistroRepository implements RegistroRepository {
  const SqliteRegistroRepository(this._dao);

  final RegistroDao _dao;

  @override
  Future<List<RegistroCampo>> listar() {
    return _dao.Listar();
  }

  @override
  Future<RegistroCampo?> buscarPorId(String id) {
    return _dao.buscarPorId(id);
  }

  @override
  Future<List<Categoria>> listarCategorias() {
    return _dao.ListarCategorias();
  }

  @override
  Future<void> inserir(RegistroCampo registro) {
    return _dao.inserir(registro);
  }

  @override
  Future<void> atualizar(RegistroCampo registro) {
    return _dao.atualizar(registro);
  }

  @override
  Future<void> remover(String id) {
    return _dao.remover(id);
  }
}

