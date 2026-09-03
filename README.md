# Hotel Pet — Controle de Animais Hospedados

Aplicação para controle de animais hospedados em um hotel para pets, com:

- **Back-end**: Node.js + Express (API REST), persistência em arquivo JSON.
- **Front-end**: Flutter, consumindo a API REST.

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

## Como executar o Front-end

Pré-requisito: [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado.

O repositório já contém o código-fonte (`lib/`) e o `pubspec.yaml` do app. Como as
pastas de plataforma (`android/`, `ios/`, `web/` etc.) são geradas pelo próprio
Flutter e variam conforme a máquina, gere-as localmente antes de rodar o app:

```bash
cd frontend
flutter create .        # gera as pastas de plataforma (android, ios, web...)
flutter pub get
flutter run              # escolha o dispositivo/emulador desejado
```

### Apontando o app para o back-end

O endereço da API é definido em `frontend/lib/services/api_service.dart`. Por padrão:

- **Emulador Android**: usa `10.0.2.2` (aponta para o `localhost` da máquina host)
  automaticamente.
- **Web, Desktop ou iOS Simulator**: usa `localhost` automaticamente.
- **Dispositivo físico**: edite o método `_host` em `api_service.dart` e informe o
  IP da máquina onde o back-end está rodando (ex.: `192.168.0.10`), já que
  `localhost` no celular se refere ao próprio celular.

Certifique-se de que o back-end (`npm start`) esteja rodando antes de abrir o app.

## Cálculo automático das diárias

- **Diárias até o momento**: diferença em dias entre a data de entrada e a data
  atual, contando o dia de entrada como a 1ª diária.
- **Diárias totais previstas**: diferença em dias entre a data de entrada e a
  previsão de data de saída (quando informada), com a mesma regra de contagem.
  Se não houver previsão de saída, esse valor não é exibido.
