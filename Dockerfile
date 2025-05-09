# denis-play-backend/Dockerfile

FROM python:3.11-slim

WORKDIR /app

# Copia apenas requirements para cache
COPY requirements.txt /app/

# Adiciona chave e repositório do k6
RUN apt-get update && apt-get install -y --no-install-recommends gnupg curl \
  && curl -s https://dl.k6.io/key.gpg | apt-key add - \
  && echo "deb https://dl.k6.io/deb stable main" > /etc/apt/sources.list.d/k6.list

# Instala todas as CLIs que você precisa
RUN apt-get update && apt-get install -y --no-install-recommends \
    nmap \           # Play 01
    hydra \          # Play 02
    sqlmap \         # Play 03
    jmeter \         # Play 04
    curl \           # Play 06 e 10
    apache2-utils \  # ab (Play 06)
    k6 \             # Play 09
    default-jre-headless \  # Java p/ JMeter/Appium
    nodejs npm \     # k6 e outras ferramentas Node
    iputils-ping \   # ping
    netcat-openbsd \ # netcat
    git              # git p/ clonar Nikto
  && rm -rf /var/lib/apt/lists/*

# Clona e instala o Nikto porque não vem no apt
RUN git clone https://github.com/sullo/nikto.git /opt/nikto \
  && ln -s /opt/nikto/program/nikto.pl /usr/local/bin/nikto

# Instala libs Python
RUN pip install --no-cache-dir -r requirements.txt

# Copia seu código
COPY . /app

# Inicia o Flask
CMD ["python", "app.py"]
