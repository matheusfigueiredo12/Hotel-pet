import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/animal.dart';

class AnimalCard extends StatelessWidget {
  final Animal animal;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AnimalCard({
    super.key,
    required this.animal,
    required this.onEdit,
    required this.onDelete,
  });

  static final _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    final speciesIcon =
        animal.species == 'Cachorro' ? Icons.pets : Icons.cruelty_free;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(speciesIcon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${animal.species} - ${animal.breed}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: 'Editar',
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Excluir',
                  onPressed: onDelete,
                ),
              ],
            ),
            const Divider(),
            _InfoRow(label: 'Tutor', value: animal.tutorName),
            _InfoRow(label: 'Contato do tutor', value: animal.tutorContact),
            _InfoRow(
              label: 'Data de entrada',
              value: _dateFormat.format(animal.entryDate),
            ),
            _InfoRow(
              label: 'Diárias até o momento',
              value: '${animal.diariasAteAgora ?? '-'}',
            ),
            _InfoRow(
              label: 'Previsão de saída',
              value: animal.expectedExitDate != null
                  ? _dateFormat.format(animal.expectedExitDate!)
                  : 'Não informada',
            ),
            _InfoRow(
              label: 'Diárias totais previstas',
              value: animal.diariasTotaisPrevistas != null
                  ? '${animal.diariasTotaisPrevistas}'
                  : 'Não aplicável',
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 170,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
