# denis-play-backend/Dockerfile

FROM python:3.11-slim

WORKDIR /app

# 1) Copia apenas o requirements para cache
COPY requirements.txt /app/

# 2) Instala gnupg e curl para adicionar repositórios
RUN apt-get update && apt-get install -y --no-install-recommends gnupg curl && rm -rf /var/lib/apt/lists/*

# 3) Adiciona repositório oficial do k6
RUN curl -s https://dl.k6.io/key.gpg | apt-key add - && \
    echo "deb https://dl.k6.io/deb stable main" > /etc/apt/sources.list.d/k6.list

# 4) Instala CLI tools necessárias (exceto Nikto)
RUN apt-get update && apt-get install -y --no-install-recommends \
    nmap \
    hydra \
    sqlmap \
    curl \
    apache2-utils \
    jmeter \
    k6 \
    default-jre-headless \
    nodejs \
    npm \
    iputils-ping \
    netcat-openbsd \
    git \
  && rm -rf /var/lib/apt/lists/*

# 5) Instala Nikto via clone (pois não há pacote Debian)
RUN git clone https://github.com/sullo/nikto.git /opt/nikto && \
    ln -s /opt/nikto/program/nikto.pl /usr/local/bin/nikto

# 6) Instala dependências Python
RUN pip install --no-cache-dir -r requirements.txt

# 7) Copia todo o código do backend
COPY . /app

# 8) Comando para iniciar o serviço
CMD ["python", "app.py"]
