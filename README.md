# Hotel Pet — Controle de Animais Hospedados

Aplicação para controle de animais hospedados em um hotel para pets, com:

- **Back-end**: Node.js + Express (API REST), persistência em arquivo JSON.
- **Front-end**: Flutter Web, consumindo a API REST — aplicação web para uso no navegador.

## Funcionalidades

Para cada animal hospedado é possível **incluir**, **visualizar**, **editar** e
**excluir** o registro, contendo:

- Nome do Tutor
- Contato do Tutor
- Espécie (Cachorro ou Gato)
- Raça
- Data de entrada
- Diárias até o momento (calculadas automaticamente pelo back-end)
- Previsão de data de saída (opcional)
- Diárias totais previstas (calculadas automaticamente quando há previsão de saída)

## Estrutura do projeto

```
Hotel-pet/
├── backend/     # API REST em Node.js/Express
└── frontend/    # Aplicativo Flutter
```

## Como executar o Back-end

Pré-requisito: Node.js 18+.

```bash
cd backend
npm install
npm start
```

O servidor sobe em `http://localhost:3000`. Endpoints disponíveis:

| Método | Rota                | Descrição                    |
|--------|----------------------|-------------------------------|
| GET    | /api/animals          | Lista todos os animais        |
| GET    | /api/animals/:id      | Detalha um animal              |
| POST   | /api/animals          | Inclui um novo animal          |
| PUT    | /api/animals/:id      | Edita um animal existente      |
| DELETE | /api/animals/:id      | Exclui um animal               |

Os dados são persistidos em `backend/data/animals.json`.

## Como executar o Front-end (navegador)

Pré-requisito: [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado,
com suporte a Web habilitado (`flutter config --enable-web`, já é o padrão em
versões recentes do Flutter).

O repositório já contém o código-fonte (`lib/`) e o `pubspec.yaml` do app. A pasta
`web/` é gerada pelo próprio Flutter e varia conforme a máquina, então gere-a
localmente antes de rodar o app:

```bash
cd frontend
flutter create --platforms=web .   # gera a pasta web/
flutter pub get
flutter run -d chrome               # abre a aplicação no navegador Chrome
```

Para gerar uma versão de produção (arquivos estáticos):

```bash
flutter build web
```

Os arquivos ficam em `frontend/build/web`, podendo ser servidos por qualquer
servidor HTTP estático.

### Apontando o app para o back-end

O endereço da API é definido em `frontend/lib/services/api_service.dart`
(`baseUrl`), apontando por padrão para `http://localhost:3000/api`. Se o
back-end estiver rodando em outra máquina, ajuste esse valor para o endereço
correspondente (ex.: `http://192.168.0.10:3000/api`).

Certifique-se de que o back-end (`npm start`) esteja rodando antes de abrir o app
no navegador — o Express já está configurado com CORS liberado para aceitar
as requisições do Flutter Web.

## Cálculo automático das diárias

- **Diárias até o momento**: diferença em dias entre a data de entrada e a data
  atual, contando o dia de entrada como a 1ª diária.
- **Diárias totais previstas**: diferença em dias entre a data de entrada e a
  previsão de data de saída (quando informada), com a mesma regra de contagem.
  Se não houver previsão de saída, esse valor não é exibido.
