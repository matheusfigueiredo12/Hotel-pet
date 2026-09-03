const express = require('express');
const crypto = require('crypto');
const store = require('./store');
const { calcDiariasAteAgora, calcDiariasTotaisPrevistas } = require('./calc');

const router = express.Router();

const VALID_SPECIES = ['Cachorro', 'Gato'];
const DATE_REGEX = /^\d{4}-\d{2}-\d{2}$/;

function withComputedFields(animal) {
  return {
    ...animal,
    diariasAteAgora: calcDiariasAteAgora(animal.entryDate),
    diariasTotaisPrevistas: calcDiariasTotaisPrevistas(
      animal.entryDate,
      animal.expectedExitDate
    ),
  };
}

function validateAnimal(body, { partial = false } = {}) {
  const errors = [];
  const fields = [
    'tutorName',
    'tutorContact',
    'species',
    'breed',
    'entryDate',
  ];

  for (const field of fields) {
    if (!partial || body[field] !== undefined) {
      if (
        body[field] === undefined ||
        body[field] === null ||
        String(body[field]).trim() === ''
      ) {
        errors.push(`O campo "${field}" é obrigatório.`);
      }
    }
  }

  if (body.species !== undefined && !VALID_SPECIES.includes(body.species)) {
    errors.push(`O campo "species" deve ser "Cachorro" ou "Gato".`);
  }

  if (body.entryDate !== undefined && !DATE_REGEX.test(body.entryDate)) {
    errors.push(`O campo "entryDate" deve estar no formato AAAA-MM-DD.`);
  }

  if (
    body.expectedExitDate !== undefined &&
    body.expectedExitDate !== null &&
    body.expectedExitDate !== '' &&
    !DATE_REGEX.test(body.expectedExitDate)
  ) {
    errors.push(`O campo "expectedExitDate" deve estar no formato AAAA-MM-DD.`);
  }

  return errors;
}

// GET /api/animals - lista todos os animais hospedados
router.get('/', (req, res) => {
  const animals = store.load();
  res.json(animals.map(withComputedFields));
});

// GET /api/animals/:id - detalhe de um animal
router.get('/:id', (req, res) => {
  const animals = store.load();
  const animal = animals.find((a) => a.id === req.params.id);
  if (!animal) {
    return res.status(404).json({ error: 'Animal não encontrado.' });
  }
  res.json(withComputedFields(animal));
});

// POST /api/animals - inclui um novo animal
router.post('/', (req, res) => {
  const errors = validateAnimal(req.body);
  if (errors.length > 0) {
    return res.status(400).json({ errors });
  }

  const animals = store.load();
  const newAnimal = {
    id: crypto.randomUUID(),
    tutorName: req.body.tutorName,
    tutorContact: req.body.tutorContact,
    species: req.body.species,
    breed: req.body.breed,
    entryDate: req.body.entryDate,
    expectedExitDate: req.body.expectedExitDate || null,
  };

  animals.push(newAnimal);
  store.save(animals);
  res.status(201).json(withComputedFields(newAnimal));
});

// PUT /api/animals/:id - edita um animal existente
router.put('/:id', (req, res) => {
  const errors = validateAnimal(req.body);
  if (errors.length > 0) {
    return res.status(400).json({ errors });
  }

  const animals = store.load();
  const index = animals.findIndex((a) => a.id === req.params.id);
  if (index === -1) {
    return res.status(404).json({ error: 'Animal não encontrado.' });
  }

  const updatedAnimal = {
    ...animals[index],
    tutorName: req.body.tutorName,
    tutorContact: req.body.tutorContact,
    species: req.body.species,
    breed: req.body.breed,
    entryDate: req.body.entryDate,
    expectedExitDate: req.body.expectedExitDate || null,
  };

  animals[index] = updatedAnimal;
  store.save(animals);
  res.json(withComputedFields(updatedAnimal));
});

// DELETE /api/animals/:id - exclui um animal
router.delete('/:id', (req, res) => {
  const animals = store.load();
  const index = animals.findIndex((a) => a.id === req.params.id);
  if (index === -1) {
    return res.status(404).json({ error: 'Animal não encontrado.' });
  }

  const [removed] = animals.splice(index, 1);
  store.save(animals);
  res.json(withComputedFields(removed));
});

module.exports = router;
