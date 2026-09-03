import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/animal.dart';
import '../services/api_service.dart';

class AnimalFormScreen extends StatefulWidget {
  final Animal? animal;

  const AnimalFormScreen({super.key, this.animal});

  bool get isEditing => animal != null;

  @override
  State<AnimalFormScreen> createState() => _AnimalFormScreenState();
}

class _AnimalFormScreenState extends State<AnimalFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  static final _dateFormat = DateFormat('dd/MM/yyyy');

  late final TextEditingController _tutorNameController;
  late final TextEditingController _tutorContactController;
  late final TextEditingController _breedController;

  String _species = 'Cachorro';
  DateTime _entryDate = DateTime.now();
  DateTime? _expectedExitDate;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final animal = widget.animal;
    _tutorNameController = TextEditingController(text: animal?.tutorName);
    _tutorContactController = TextEditingController(text: animal?.tutorContact);
    _breedController = TextEditingController(text: animal?.breed);
    _species = animal?.species ?? 'Cachorro';
    _entryDate = animal?.entryDate ?? DateTime.now();
    _expectedExitDate = animal?.expectedExitDate;
  }

  @override
  void dispose() {
    _tutorNameController.dispose();
    _tutorContactController.dispose();
    _breedController.dispose();
    super.dispose();
  }

  Future<void> _pickEntryDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _entryDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _entryDate = picked);
    }
  }

  Future<void> _pickExpectedExitDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expectedExitDate ?? _entryDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _expectedExitDate = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final animal = Animal(
      id: widget.animal?.id,
      tutorName: _tutorNameController.text.trim(),
      tutorContact: _tutorContactController.text.trim(),
      species: _species,
      breed: _breedController.text.trim(),
      entryDate: _entryDate,
      expectedExitDate: _expectedExitDate,
    );

    try {
      if (widget.isEditing) {
        await _apiService.updateAnimal(widget.animal!.id!, animal);
      } else {
        await _apiService.createAnimal(animal);
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Editar Animal' : 'Novo Animal'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _tutorNameController,
              decoration: const InputDecoration(
                labelText: 'Nome do Tutor',
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Informe o nome do tutor.'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _tutorContactController,
              decoration: const InputDecoration(
                labelText: 'Contato do Tutor',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Informe o contato do tutor.'
                  : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _species,
              decoration: const InputDecoration(
                labelText: 'Espécie',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Cachorro', child: Text('Cachorro')),
                DropdownMenuItem(value: 'Gato', child: Text('Gato')),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _species = value);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _breedController,
              decoration: const InputDecoration(
                labelText: 'Raça',
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Informe a raça.'
                  : null,
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Data de entrada'),
              subtitle: Text(_dateFormat.format(_entryDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickEntryDate,
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Previsão de data de saída'),
              subtitle: Text(
                _expectedExitDate != null
                    ? _dateFormat.format(_expectedExitDate!)
                    : 'Não informada',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_expectedExitDate != null)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      tooltip: 'Remover previsão',
                      onPressed: () =>
                          setState(() => _expectedExitDate = null),
                    ),
                  const Icon(Icons.calendar_today),
                ],
              ),
              onTap: _pickExpectedExitDate,
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(widget.isEditing ? 'Salvar alterações' : 'Incluir animal'),
            ),
          ],
        ),
      ),
    );
  }
}
