import 'package:flutter/material.dart';

import '../../services/auth_service.dart';

class PaginaLogin extends StatefulWidget {
  const PaginaLogin({super.key});

  @override
  State<PaginaLogin> createState() => _PaginaLoginState();
}

class _PaginaLoginState extends State<PaginaLogin> {
  final AuthService _auth = AuthService();
  bool _carregando = false;

  Future<void> _entrar() async {
    setState(() => _carregando = true);
    try {
      await _auth.entrarComGoogle();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível entrar com o Google.')),
      );
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ESCOLA JUJUTSU',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              const Text('Acesso restrito para feiticeiros'),
              const SizedBox(height: 32),
              _carregando
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _entrar,
                      child: const Text('ENTRAR COM GOOGLE'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
