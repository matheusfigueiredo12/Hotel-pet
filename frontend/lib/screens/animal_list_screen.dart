import 'package:flutter/material.dart';

import '../models/animal.dart';
import '../services/api_service.dart';
import '../widgets/animal_card.dart';
import 'animal_form_screen.dart';

class AnimalListScreen extends StatefulWidget {
  const AnimalListScreen({super.key});

  @override
  State<AnimalListScreen> createState() => _AnimalListScreenState();
}

class _AnimalListScreenState extends State<AnimalListScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Animal>> _animalsFuture;

  @override
  void initState() {
    super.initState();
    _animalsFuture = _apiService.fetchAnimals();
  }

  void _reload() {
    setState(() {
      _animalsFuture = _apiService.fetchAnimals();
    });
  }

  Future<void> _openForm({Animal? animal}) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AnimalFormScreen(animal: animal),
      ),
    );
    if (result == true) {
      _reload();
    }
  }

  Future<void> _confirmDelete(Animal animal) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir registro'),
        content: Text(
          'Deseja realmente excluir o registro de ${animal.breed} '
          '(tutor: ${animal.tutorName})?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed == true && animal.id != null) {
      try {
        await _apiService.deleteAnimal(animal.id!);
        _reload();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registro excluído com sucesso.')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hotel Pet - Animais Hospedados')),
      body: RefreshIndicator(
        onRefresh: () async => _reload(),
        child: FutureBuilder<List<Animal>>(
          future: _animalsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return ListView(
                children: [
                  const SizedBox(height: 80),
                  Icon(Icons.error_outline,
                      size: 48, color: Theme.of(context).colorScheme.error),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'Erro ao carregar animais:\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            }

            final animals = snapshot.data ?? [];
            if (animals.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: 80),
                  Center(child: Text('Nenhum animal hospedado no momento.')),
                ],
              );
            }

            return ListView.builder(
              itemCount: animals.length,
              itemBuilder: (context, index) {
                final animal = animals[index];
                return AnimalCard(
                  animal: animal,
                  onEdit: () => _openForm(animal: animal),
                  onDelete: () => _confirmDelete(animal),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Novo animal'),
      ),
    );
  }
}
