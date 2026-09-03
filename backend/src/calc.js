const MS_PER_DAY = 24 * 60 * 60 * 1000;

function parseDateOnly(dateStr) {
  const [year, month, day] = dateStr.split('-').map(Number);
  return new Date(Date.UTC(year, month - 1, day));
}

function daysBetween(startDateStr, endDateStr) {
  const start = parseDateOnly(startDateStr);
  const end = parseDateOnly(endDateStr);
  return Math.round((end - start) / MS_PER_DAY);
}

function todayDateStr() {
  const now = new Date();
  return new Date(Date.UTC(now.getFullYear(), now.getMonth(), now.getDate()))
    .toISOString()
    .slice(0, 10);
}

// A diária do dia de entrada já conta como 1, por isso soma-se 1 à diferença de dias.
function calcDiariasAteAgora(entryDate) {
  const today = todayDateStr();
  const diff = daysBetween(entryDate, today) + 1;
  return diff < 1 ? 1 : diff;
}

function calcDiariasTotaisPrevistas(entryDate, expectedExitDate) {
  if (!expectedExitDate) return null;
  const diff = daysBetween(entryDate, expectedExitDate) + 1;
  return diff < 1 ? 1 : diff;
}

module.exports = {
  calcDiariasAteAgora,
  calcDiariasTotaisPrevistas,
};
