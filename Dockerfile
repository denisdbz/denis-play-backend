# denis-play-backend/Dockerfile

FROM python:3.11-slim

WORKDIR /app
COPY . /app

# Instala Java e JMeter (e as outras ferramentas que você já usa)
RUN apt-get update && apt-get install -y --no-install-recommends \
    default-jre-headless \      # Java para o JMeter
    jmeter \                    # o próprio JMeter
    nmap \
    hydra \
    sqlmap \
    curl \
    iputils-ping \
    netcat-openbsd \
  && rm -rf /var/lib/apt/lists/*

# Dependências Python
RUN pip install --no-cache-dir -r requirements.txt

CMD ["python", "app.py"]
