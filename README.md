# Denis Play Backend

Backend para execução de testes reais do portfólio profissional do Denis.

## Como executar localmente

```bash
pip install -r requirements.txt
python app.py
```

## Como fazer deploy

```bash
flyctl auth login
./deploy.sh
```

---

API pública após deploy:
GET /run/play-01-nmap-recon