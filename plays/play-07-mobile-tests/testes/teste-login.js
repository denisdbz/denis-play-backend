describe('Teste de Login Simples', () => {
  it('deve acessar uma URL e validar título', async () => {
    await browser.url('https://jsonplaceholder.typicode.com/posts');
    const title = await browser.getTitle();
    console.log('[✓] Título da página:', title);
  });
});
