# AWS Unyleya DevOps

Este script do Terraform cria a infraestrutura necessária para implementar uma arquitetura básica de aplicação de front-end e back-end na AWS. Ele cria os recursos essenciais, como VPC, sub-redes, grupos de segurança, instâncias EC2, e um balanceador de carga (Load Balancer). Vou descrever cada parte do processo e, em seguida, fornecer um gráfico para ilustrar a arquitetura.

## Descrição do Funcionamento:

### Provedor AWS:

Configura o provedor AWS para usar a região `us-east-1`.

### AMI (Amazon Machine Image) do Amazon Linux 2:

Obtém a AMI mais recente do Amazon Linux 2 para ser usada nas instâncias EC2.

### Chave SSH:

Cria um par de chaves para permitir o acesso SSH às instâncias.

### VPC (Virtual Private Cloud):

Cria uma VPC com o bloco CIDR `10.0.0.0/16`.

### Sub-redes:

Cria duas sub-redes públicas: uma para o backend (`public_subnet`) e uma para o frontend (`frontend_subnet`).

### Internet Gateway (IGW):

Cria um gateway de internet para permitir o tráfego externo da internet para a VPC. Este IGW é associado às sub-redes públicas.

### Tabelas de Roteamento:

Define uma tabela de rotas pública que direciona o tráfego para o Internet Gateway.

### Grupos de Segurança (Security Groups):

- **Backend Security Group**: Permite o tráfego SSH (porta 22), Node.js (porta 3000) e MongoDB (porta 27017).
- **Frontend Security Group**: Permite o tráfego SSH (porta 22) e HTTP (porta 80) para o frontend.

### Instâncias EC2:

- **Instância Backend**: Cria uma instância EC2 para o backend, instala Node.js e MongoDB, e executa a aplicação backend.
- **Instância Frontend**: Cria uma instância EC2 para o frontend, instala o Nginx e serve a aplicação React.

### Load Balancer:

Cria um Application Load Balancer (ALB) para distribuir o tráfego HTTP para as instâncias do backend. O Load Balancer é configurado com um listener HTTP na porta 80.

### Target Group:

O backend é adicionado ao Target Group do Load Balancer para que o tráfego seja direcionado corretamente.

## Arquitetura da Infraestrutura:


                         +----------------------+
                         |    Internet Gateway  |
                         +----------------------+
                                    |
                                    |
                          +---------------------+
                          |    VPC (10.0.0.0/16) |
                          +---------------------+
                                    |
                +-------------------+-------------------+
                |                                       |
    +---------------------+                     +---------------------+
    |   Public Subnet      |                     |  Public Subnet      |
    | (Frontend Subnet)    |                     | (Backend Subnet)    |
    +---------------------+                     +---------------------+
                |                                       |
      +------------------+                         +------------------+
      | Frontend EC2     |                         | Backend EC2      |
      | (Nginx + React)  |                         | (Node.js + Mongo)|
      +------------------+                         +------------------+
                |                                       |
           +----------+                               +----------+
           |  Nginx   |                               |  Node.js |
           |  Serve   |                               |  App    |
           +----------+                               +----------+
                |
       +---------------------+
       | Load Balancer       |
       +---------------------+
                |
                v
    +-----------------------+
    |  Target Group Backend |
    +-----------------------+


## Explicação do Fluxo:

### Usuário Acessa o Frontend:

- O tráfego HTTP do usuário chega ao Load Balancer.
- O Load Balancer redireciona o tráfego para o backend, que está no Target Group.

### Backend:

- O backend é acessado pelo Load Balancer e está configurado para rodar um servidor Node.js com MongoDB.

### Frontend:

- O frontend (React) é servido pelo Nginx, que está configurado na instância EC2 do frontend.
- O frontend se comunica com o backend para obter os dados necessários.

### Comunicando-se com a Internet:

- Ambos os recursos (frontend e backend) têm a capacidade de se comunicar com a Internet, permitindo o acesso ao aplicativo.

Este diagrama simplificado ilustra a infraestrutura que o Terraform provisiona, garantindo que o backend e o frontend estejam configurados corretamente para trabalhar juntos na AWS.

