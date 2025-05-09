# denis-play-backend/Dockerfile

FROM python:3.11-slim

WORKDIR /app

# 1) Copia só o requirements para otimizar cache
COPY requirements.txt /app/

# 2) Instala gnupg e curl, adiciona repositório do k6
RUN apt-get update && apt-get install -y gnupg curl \
  && curl -s https://dl.k6.io/key.gpg | apt-key add - \
  && echo "deb https://dl.k6.io/deb stable main" > /etc/apt/sources.list.d/k6.list

# 3) Instala todas as ferramentas numa única linha (sem comentários nem \ no final)
RUN apt-get update && apt-get install -y --no-install-recommends nmap hydra sqlmap nikto curl apache2-utils jmeter k6 default-jre-headless nodejs npm iputils-ping netcat-openbsd git && rm -rf /var/lib/apt/lists/*

# 4) Clona o Nikto e expõe o script
RUN git clone https://github.com/sullo/nikto.git /opt/nikto && ln -s /opt/nikto/program/nikto.pl /usr/local/bin/nikto

# 5) Instala dependências Python
RUN pip install --no-cache-dir -r requirements.txt

# 6) Copia o restante do código
COPY . /app

# 7) Inicia o Flask
CMD ["python", "app.py"]
