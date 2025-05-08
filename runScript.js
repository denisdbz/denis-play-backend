function executarTeste() {
  const logs = document.getElementById('logs');
  const barra = document.querySelector('.barra-preenchida');
  logs.textContent = '';
  barra.style.width = '0%';

  const source = new EventSource('/executar/play-01');
  source.onmessage = function(event) {
    logs.textContent += event.data + '\n';
    logs.scrollTop = logs.scrollHeight;
    barra.style.width = Math.min(100, logs.textContent.length / 5) + '%';
  };
  source.onerror = function() {
    source.close();
  };
}
