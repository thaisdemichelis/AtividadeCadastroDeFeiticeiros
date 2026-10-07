import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/missao.dart';
import '../../services/auth_service.dart';
import '../../services/missao_service.dart';

class PaginaCentral extends StatefulWidget {
  const PaginaCentral({super.key});

  @override
  State<PaginaCentral> createState() => _PaginaCentralState();
}

class _PaginaCentralState extends State<PaginaCentral> {
  final AuthService _auth = AuthService();
  final MissaoService _service = MissaoService();
  final TextEditingController _controller = TextEditingController();
  int _grau = 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    final titulo = _controller.text.trim();
    if (titulo.isEmpty) return;
    _controller.clear();
    await _service.cadastrar(titulo, _grau);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Central Jujutsu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: _auth.sair,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage:
                  user.photoURL != null ? NetworkImage(user.photoURL!) : null,
              child: user.photoURL == null ? const Icon(Icons.person) : null,
            ),
            const SizedBox(height: 12),
            const Text('Bem-vindo,'),
            Text(
              user.displayName ?? '',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(user.email ?? ''),
            const Divider(height: 32),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Título da missão',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Grau:'),
                const SizedBox(width: 12),
                DropdownButton<int>(
                  value: _grau,
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('1')),
                    DropdownMenuItem(value: 2, child: Text('2')),
                    DropdownMenuItem(value: 3, child: Text('3')),
                    DropdownMenuItem(value: 4, child: Text('4')),
                  ],
                  onChanged: (valor) {
                    if (valor != null) setState(() => _grau = valor);
                  },
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _cadastrar,
                  child: const Text('Cadastrar missão'),
                ),
              ],
            ),
            const Divider(height: 32),
            Expanded(
              child: StreamBuilder<List<Missao>>(
                stream: _service.listarMissoes(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Erro ao carregar as missões.'),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final missoes = snapshot.data!;
                  if (missoes.isEmpty) {
                    return const Center(
                      child: Text('Nenhuma missão cadastrada.'),
                    );
                  }
                  return ListView.builder(
                    itemCount: missoes.length,
                    itemBuilder: (context, index) {
                      final missao = missoes[index];
                      return ListTile(
                        leading: Checkbox(
                          value: missao.concluida,
                          onChanged: (valor) => _service.atualizarConcluida(
                            missao.id!,
                            valor ?? false,
                          ),
                        ),
                        title: Text(
                          missao.titulo,
                          style: TextStyle(
                            decoration: missao.concluida
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        subtitle: Text('Grau ${missao.grau}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          tooltip: 'Excluir',
                          onPressed: () => _service.excluir(missao.id!),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
