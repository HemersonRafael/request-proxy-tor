import requests
import time

# Função para fazer uma requisição via proxy Tor
def make_request_via_tor(url):
    session = requests.Session()
    session.proxies = {
        'http': 'socks5h://localhost:9050',
        'https': 'socks5h://localhost:9050'
    }

    try:
        response = session.get(url)
        print("Status Code:", response.status_code)
        print("Resposta:", response.json())
    except Exception as e:
        print("Erro na requisição:", e)

# Teste: Faz várias requisições trocando o IP entre elas
for _ in range(3):
    print("Fazendo requisição...")
    make_request_via_tor("http://httpbin.org/ip")
    time.sleep(60)  # Espera um pouco para que o Tor processe a troca de IP
