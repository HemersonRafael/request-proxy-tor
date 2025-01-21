# Use uma imagem base oficial do Python
FROM python:3.10-slim

# Instala o Tor
RUN apt-get update && \
    apt-get install -y tor && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configura o Tor para usar apenas nós do Brasil
RUN echo "SOCKSPort 127.0.0.1:9050" >> /etc/tor/torrc && \
    echo "ControlPort 127.0.0.1:9051" >> /etc/tor/torrc && \
    echo "CookieAuthentication 0" >> /etc/tor/torrc && \
    echo "MaxCircuitDirtiness 60" >> /etc/tor/torrc && \
    echo "HashedControlPassword $(tor --hash-password 'sua_senha_aqui' | tail -n 1)" >> /etc/tor/torrc && \
    echo "ExitNodes {BR}" >> /etc/tor/torrc && \  # Define o Brasil como país de saída
    echo "StrictNodes 1" >> /etc/tor/torrc         # Usa estritamente os nós definidos

# Define o diretório de trabalho
WORKDIR /usr/src/app

# Copia os arquivos do projeto
COPY . .

# Instala as dependências usando Poetry
RUN pip install --no-cache-dir poetry==1.8.3
RUN poetry config virtualenvs.create false
RUN poetry install --no-interaction --verbose

# Torna o script executável
RUN chmod +x script.py

# Comando para iniciar o Tor e o script Python
CMD ["sh", "-c", "service tor start && poetry run python /usr/src/app/script.py"]

