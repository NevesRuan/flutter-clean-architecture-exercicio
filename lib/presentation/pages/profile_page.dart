import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/session_viewmodel.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<SessionViewModel>().fetchCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meu Perfil')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Sem dados'));
          }
          final data = snapshot.data!;
          final image = data['image'] as String? ?? '';
          final firstName = data['firstName'] as String? ?? '';
          final lastName = data['lastName'] as String? ?? '';
          final username = data['username'] as String? ?? '';
          final email = data['email'] as String? ?? '';
          final gender = data['gender'] as String? ?? '';
          final phone = data['phone'] as String? ?? '';
          final age = data['age']?.toString() ?? '';

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: CircleAvatar(
                  radius: 56,
                  backgroundImage:
                      image.isNotEmpty ? NetworkImage(image) : null,
                  child: image.isEmpty ? const Icon(Icons.person, size: 56) : null,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  '$firstName $lastName'.trim(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _Field(label: 'Usuário', value: username),
              _Field(label: 'E-mail', value: email),
              if (gender.isNotEmpty) _Field(label: 'Gênero', value: gender),
              if (phone.isNotEmpty) _Field(label: 'Telefone', value: phone),
              if (age.isNotEmpty) _Field(label: 'Idade', value: age),
            ],
          );
        },
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final String value;
  const _Field({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 16)),
          const Divider(),
        ],
      ),
    );
  }
}
