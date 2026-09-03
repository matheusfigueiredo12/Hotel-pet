const fs = require('fs');
const path = require('path');

const DATA_FILE = path.join(__dirname, '..', 'data', 'animals.json');

function load() {
  if (!fs.existsSync(DATA_FILE)) {
    return [];
  }
  const raw = fs.readFileSync(DATA_FILE, 'utf-8');
  if (!raw.trim()) return [];
  return JSON.parse(raw);
}

function save(animals) {
  fs.mkdirSync(path.dirname(DATA_FILE), { recursive: true });
  fs.writeFileSync(DATA_FILE, JSON.stringify(animals, null, 2), 'utf-8');
}

module.exports = { load, save };
