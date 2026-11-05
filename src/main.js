import './style.css';

const app = document.querySelector('#app');

app.innerHTML = `
  <main class="shell">
    <header class="topbar">
      <div class="brand"><span class="brand-icon" aria-hidden="true">✳</span> Conecta Vidas</div>
      <span class="course">Projeto Integrador Extensionista II</span>
    </header>
    <section class="hero" aria-labelledby="titulo">
      <div class="eyebrow">ONG • Tecnologia com propósito</div>
      <h1 id="titulo">Conectando pessoas.<br/><em>Transformando vidas.</em></h1>
      <p>Uma iniciativa fictícia de apoio comunitário, criada para demonstrar a integração entre uma interface web e uma API Express.</p>
    </section>
    <section class="status-card" aria-labelledby="status-titulo">
      <div class="card-heading"><span class="card-icon" aria-hidden="true">↗</span><div><h2 id="status-titulo">Monitoramento do sistema</h2><p>Resposta em tempo real do endpoint <code>GET /api/health</code></p></div></div>
      <div class="status-line"><span class="light" id="status-light" aria-hidden="true"></span><strong id="status-message" role="status" aria-live="polite">Verificando API...</strong></div>
      <dl><div><dt>Data e hora</dt><dd id="status-date">Aguardando resposta...</dd></div><div><dt>Endereço da API</dt><dd><code>/api/health</code></dd></div></dl>
      <button type="button" id="refresh">Atualizar status <span aria-hidden="true">↻</span></button>
    </section>
    <footer>Conecta Vidas © 2026 · Projeto acadêmico demonstrativo</footer>
  </main>
`;

const message = document.querySelector('#status-message');
const date = document.querySelector('#status-date');
const light = document.querySelector('#status-light');

async function verificarApi() {
  message.textContent = 'Verificando API...';
  light.className = 'light';
  try {
    const resposta = await fetch('/api/health', { cache: 'no-store' });
    if (!resposta.ok) throw new Error(`HTTP ${resposta.status}`);
    const dados = await resposta.json();
    if (dados.status !== 'ok' || !dados.timestamp) throw new Error('Resposta da API inválida');
    message.textContent = `Status da API: ${dados.status}`;
    date.textContent = new Date(dados.timestamp).toLocaleString('pt-BR', { dateStyle: 'full', timeStyle: 'medium' });
    light.className = 'light online';
  } catch (erro) {
    message.textContent = 'Status da API: indisponível';
    date.textContent = 'Não foi possível obter a data e hora da API.';
    light.className = 'light offline';
    console.error('Erro ao consultar a API:', erro);
  }
}

document.querySelector('#refresh').addEventListener('click', verificarApi);
verificarApi();
