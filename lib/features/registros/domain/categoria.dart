class Categoria {

  const Categoria({
    required this.id,
    required this.nome,
  });

  final int id;

  final String nome;

  factory Categoria.fromMap(Map<String, Object?> map) {

    return Categoria(
          id: map['id'] as int,
          nome: map['nome'] as String
    );
  }
}