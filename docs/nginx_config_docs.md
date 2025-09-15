# **Documentação Detalhada do Arquivo de Configuração Nginx**
`nginx/wss13-mvp.conf`

Este documento explica o propósito e a funcionalidade do arquivo de configuração `wss13-mvp.conf` do Nginx, versionado no seu projeto. Ele descreve como este arquivo atua como um **reverse proxy** para a API Node.js do WSS13, habilitando **HTTPS** para o ambiente de desenvolvimento local.

## **1. Objetivo Principal deste Arquivo**

O arquivo `wss13-mvp.conf` tem dois objetivos primordiais:

1.  **Redirecionamento HTTP para HTTPS (Segurança):** Garante que todas as requisições HTTP (porta 80) para `localhost` sejam automaticamente redirecionadas para HTTPS (porta 443), forçando uma comunicação segura.
2.  **Proxy Reverso HTTPS (Acesso Seguro à API):** Permite que sua API Node.js, que roda internamente em `http://localhost:3001`, seja acessada publicamente (localmente, neste caso) através de `https://localhost`. O Nginx atua como um "porteiro", recebendo a requisição segura e a encaminhando internamente para sua API.

## **2. Estrutura do Arquivo**

O arquivo é dividido em dois blocos `server {}` principais:

*   **Bloco 1: Redirecionamento HTTP (porta 80)**
*   **Bloco 2: Proxy Reverso HTTPS (porta 443)**

---

### **2.1. Bloco de Redirecionamento HTTP (Porta 80)**

```nginx
# Este bloco de servidor é responsável por redirecionar todo o tráfego HTTP (porta 80) para HTTPS (porta 443).
server {
    listen 80;          # Nginx escutará por conexões HTTP na porta 80.
    listen [::]:80;     # Para suporte a IPv6.

    server_name localhost; # Define que este bloco de servidor responde a requisições para 'localhost'.
                           # Crucial para testes com certificado autoassinado.

    return 301 https://$host$request_uri; # Redireciona permanentemente (código 301) o cliente
                                          # para a versão HTTPS da URL solicitada.
                                          # Ex: http://localhost/health -> https://localhost/health
}
# Este é o bloco de servidor principal para a sua aplicação via HTTPS (porta 443).
server {
    listen 443 ssl http2;     # Nginx escutará por conexões HTTPS na porta 443.
                              # 'ssl' habilita o SSL/TLS (HTTPS).
                              # 'http2' habilita o protocolo HTTP/2 para melhor performance.
    listen [::]:443 ssl http2; # Para suporte a IPv6.

    server_name localhost; # Define que este bloco de servidor responde a requisições para 'localhost'.
                           # DEVE CORRESPONDER ao 'Common Name' usado na criação do certificado SSL.

    # Aponta para os arquivos do certificado SSL autoassinado que você gerou.
    ssl_certificate /etc/nginx/ssl/nginx.crt;    # Caminho para o arquivo do certificado (público).
    ssl_certificate_key /etc/nginx/ssl/nginx.key; # Caminho para a chave privada do certificado (SEGREDO!).

    # Configurações de segurança SSL/TLS recomendadas para garantir criptografia forte.
    # Estas configurações são importantes para a "firmeza" da sua API.
    ssl_session_timeout 1d;                       # Duração máxima de uma sessão SSL.
    ssl_session_cache shared:SSL:10m;             # Cache para sessões SSL para melhor performance.
    ssl_session_tickets off;                      # Desabilita session tickets para segurança.

    ssl_protocols TLSv1.2 TLSv1.3;                # Define quais versões do protocolo TLS serão aceitas.
                                                  # TLSv1.2 e TLSv1.3 são as versões seguras e atuais.
    ssl_ciphers 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256';
                                                  # Lista de algoritmos de criptografia permitidos,
                                                  # priorizando os mais fortes e seguros.
    ssl_prefer_server_ciphers on;                 # O servidor escolhe o cipher preferido.

    # Adiciona cabeçalhos de segurança HTTP.
    add_header X-Frame-Options "SAMEORIGIN";      # Protege contra ataques de "clickjacking".
    add_header X-Content-Type-Options "nosniff";  # Impede que o navegador "adivinhe" o tipo de conteúdo.
    add_header X-XSS-Protection "1; mode=block";  # Proteção contra ataques XSS.
    add_header Referrer-Policy "no-referrer-when-downgrade"; # Controla o envio de informações de referência.
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload";
                                                  # HSTS: Força o navegador a usar apenas HTTPS para este domínio.

    # Configuração do reverse proxy para sua API Node.js.
    # Sua API ainda roda em HTTP internamente para o Nginx.
    location / {
        proxy_pass http://localhost:3001;          # AQUI! Encaminha todas as requisições recebidas
                                                   # pelo Nginx (https://localhost/) para sua API
                                                   # Node.js rodando em http://localhost:3001.
        proxy_http_version 1.1;                    # Usa HTTP/1.1 para o proxy.
        proxy_set_header Upgrade $http_upgrade;    # Necessário para WebSockets.
        proxy_set_header Connection 'upgrade';     # Necessário para WebSockets.
        proxy_set_header Host $host;               # Passa o cabeçalho 'Host' original para a API.
        proxy_cache_bypass $http_upgrade;          # Impede o cache para requisições de upgrade.
        proxy_set_header X-Real-IP $remote_addr;   # Envia o IP real do cliente para a API.
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; # Envia a cadeia de proxies.
        proxy_set_header X-Forwarded-Proto $scheme; # Indica que a requisição original era HTTPS.
        proxy_set_header X-Forwarded-Host $host;   # Passa o host original (localhost) para a API.
        proxy_set_header X-Forwarded-Port $server_port; # Passa a porta original (443) para a API.
    }
}
sudo cp ~/Projetos/wss13-mvp/nginx/wss13-mvp.conf /etc/nginx/sites-available/
# Opcional: Remova a configuração 'default' para evitar conflitos (boa prática)
sudo rm /etc/nginx/sites-enabled/default
# Crie o link simbólico
sudo ln -s /etc/nginx/sites-available/wss13-mvp /etc/nginx/sites-enabled/


sudo nginx -t                # Verifica erros de sintaxe
sudo systemctl restart nginx # Reinicia o Nginx para aplicar as mudanças

**Para colar no `nano`:** No terminal, use `Ctrl+Shift+V` (ou `Cmd+V` no macOS) para colar o texto.

**4. Salvar e Sair do `nano`:**

*   Pressione `Ctrl+O` (para "Write Out", ou Salvar).
*   Pressione `Enter` para confirmar o nome do arquivo.
*   Pressione `Ctrl+X` (para "Exit", ou Sair).

**5. Adicionar o arquivo ao Git:**

```bash
git add docs/nginx_config_docs.md
