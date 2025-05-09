# denis-play-backend/Dockerfile

FROM python:3.11-slim

WORKDIR /app
COPY . /app

# 1) Instala Java (para rodar o JMeter) + JMeter + outras ferramentas CLI que você precisa
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      default-jre-headless \    # Java pra JMeter
      jmeter \                  # JMeter em modo headless
      nmap \                    # Play 01
      hydra \                   # Play 02
      sqlmap \                  # Play 03
      curl \                    # diversas plays
      iputils-ping \            # Play 07, diagnóstico de rede
      netcat-openbsd &&         # Play 06, sockets
    rm -rf /var/lib/apt/lists/*

# 2) Instala as dependências Python (Flask, flask-cors, etc)
RUN pip install --no-cache-dir -r requirements.txt

# 3) Roda o Flask
CMD ["python", "app.py"]
