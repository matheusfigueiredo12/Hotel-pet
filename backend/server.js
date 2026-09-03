const express = require('express');
const cors = require('cors');
const animalsRouter = require('./src/animalsRouter');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.use('/api/animals', animalsRouter);

app.get('/', (req, res) => {
  res.json({ status: 'ok', message: 'API Hotel Pet no ar.' });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Servidor rodando em http://0.0.0.0:${PORT}`);
});
