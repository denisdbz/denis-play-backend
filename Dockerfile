# denis-play-backend/Dockerfile

FROM python:3.11-slim

WORKDIR /app
COPY . /app

# Instala Java, JMeter e ferramentas CLI usadas pelos plays
RUN apt-get update && apt-get install -y --no-install-recommends \
    default-jre-headless \
    jmeter \
    nmap \
    hydra \
    sqlmap \
    curl \
    iputils-ping \
    netcat-openbsd \
 && rm -rf /var/lib/apt/lists/*

# Instala dependências Python
RUN pip install --no-cache-dir -r requirements.txt

# Comando padrão
CMD ["python", "app.py"]
