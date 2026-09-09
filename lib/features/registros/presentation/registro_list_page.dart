import 'package:flutter/material.dart';

import 'package:projeto/features/registros/domain/registro_campo.dart';
import 'package:projeto/features/registros/domain/registro_repository.dart';
import 'registro_form_page.dart';

class RegistroListPage extends StatefulWidget {
  const RegistroListPage({
    super.key,
    required this.repository,
  });

  final RegistroRepository repository;

  @override
  State<RegistroListPage> createState() => _RegistroListPageState();
}

class _RegistroListPageState extends State<RegistroListPage> {
  late Future<List<RegistroCampo>> _registrosFuture;

  @override
  void initState() {
    super.initState();
    _registrosFuture = widget.repository.listar();
  }

  Future<void> _recarregar() async {
    setState(() {
      _registrosFuture = widget.repository.listar();
    });
    await _registrosFuture;
  }

  Future<void> _abrirFormulario([
    RegistroCampo? registro,
  ]) async {
    final alterou = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) {
          return RegistroFormPage(
            repository: widget.repository,
            registro: registro,
          );
        },
      ),
    );

    if (alterou == true) {
      await _recarregar();
    }
  }

  Future<void> _confirmarExclusao(
      RegistroCampo registro,
      ) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir registro?'),
          content: Text(
            'O registro "${registro.titulo}" será removido.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmou != true) {
      return;
    }

    try {
      await widget.repository.remover(registro.id);
      await _recarregar();
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível excluir o registro.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Campo'),
        actions: [
          IconButton(
            onPressed: _recarregar,
            tooltip: 'Atualizar',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<List<RegistroCampo>>(
        future: _registrosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return _ErrorState(
              onRetry: _recarregar,
            );
          }

          final registros = snapshot.data ?? const <RegistroCampo>[];

          if (registros.isEmpty) {
            return _EmptyState(
              onCreate: () => _abrirFormulario(),
            );
          }

          return RefreshIndicator(
            onRefresh: _recarregar,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                16,
                12,
                16,
                88,
              ),
              itemCount: registros.length,
              separatorBuilder: (_, __) {
                return const SizedBox(height: 8);
              },
              itemBuilder: (context, index) {
                final registro = registros[index];

                return Card(
                  child: ListTile(
                    onTap: () {
                      _abrirFormulario(registro);
                    },
                    title: Text(registro.titulo),
                    subtitle: Text(
                      '${registro.categoriaNome ?? "Sem categoria"} - '
                          '${_formatarData(registro.dataVisita)}',
                    ),
                    leading: CircleAvatar(
                      child: Icon(
                        _iconeSituacao(registro.situacao),
                      ),
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'editar') {
                          _abrirFormulario(registro);
                        }

                        if (value == 'excluir') {
                          _confirmarExclusao(registro);
                        }
                      },
                      itemBuilder: (context) {
                        return const [
                          PopupMenuItem(
                            value: 'editar',
                            child: Text('Editar'),
                          ),
                          PopupMenuItem(
                            value: 'excluir',
                            child: Text('Excluir'),
                          ),
                        ];
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirFormulario,
        icon: const Icon(Icons.add),
        label: const Text('Novo'),
      ),
    );
  }

  String _formatarData(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');

    return '$dia/$mes/${data.year}';
  }

  IconData _iconeSituacao(
      SituacaoRegistro situacao,
      ) {
    return switch (situacao) {
      SituacaoRegistro.pendente => Icons.schedule,
      SituacaoRegistro.emAndamento => Icons.construction,
      SituacaoRegistro.concluida => Icons.check,
    };
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.onCreate,
  });

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.assignment_outlined,
              size: 72,
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum registro cadastrado',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Cadastre a primeira visita técnica. Os dados serão salvos no aparelho.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add),
              label: const Text('Criar registro'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.onRetry,
  });

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 72,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            const Text(
              'Não foi possível carregar os registros.',
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}