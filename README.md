# ONG Conecta Vidas

Projeto acadêmico fictício para a disciplina **Projeto Integrador Extensionista II — Atividade 1**.

## Tecnologias

- Vite+ com interface **Vanilla JavaScript**
- API **Node.js + Express**
- Integração entre página web e API por proxy do Vite+

## Requisitos

- Node.js atualizado (recomendado: versão 22 ou superior)
- npm

## Como rodar

1. No terminal, dentro da pasta do projeto, instale as dependências:

   ```bash
   npm install
   ```

2. Crie seu arquivo de ambiente a partir do modelo:

   **Windows (PowerShell):**
   ```powershell
   Copy-Item .env.example .env
   ```

   **Linux / macOS:**
   ```bash
   cp .env.example .env
   ```

3. Em um **primeiro terminal**, execute a API:

   ```bash
   npm run api
   ```

4. Em um **segundo terminal**, execute o site:

   ```bash
   npm run dev
   ```

5. Acesse **http://localhost:5173** no navegador. A página deverá mostrar **Status da API: ok** e a data e hora retornadas pelo servidor.

## Endpoint

`GET http://localhost:3001/api/health`

Exemplo de resposta:

```json
{
  "status": "ok",
  "timestamp": "2026-11-05T13:00:00.000Z"
}
```

O campo `timestamp` é gerado dinamicamente a cada requisição.

## Estrutura

```text
ong-conecta-vidas/
├── .env.example
├── .gitignore
├── index.html
├── package.json
├── README.md
├── vite.config.ts
├── server/
│   └── index.js
└── src/
    ├── main.js
    └── style.css
```

**Atenção:** o arquivo `.env` é privado e foi incluído no `.gitignore`. O arquivo `.env.example` pode ser publicado.

## Entrega da atividade

- Link público do repositório no GitHub.
- Captura de tela real de `http://localhost:5173` com barra de endereço visível, **Status da API: ok**, data e hora.
- Pelo menos 3 commits no histórico Git (este projeto contém 4).

## Observação

A ONG Conecta Vidas é uma identidade fictícia utilizada para demonstração acadêmica.
