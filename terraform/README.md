# Configuração de VPC na AWS

## 1. Criar a VPC
**O que é:** Uma rede virtual isolada no ambiente da AWS.

### Passos:
1. Vá para o console da AWS.
2. Acesse **VPC > Criar VPC**.
3. Especifique:
   - **Nome**.
   - **Faixa de CIDR** (exemplo: `10.0.0.0/16`).

---

## 2. Criar um Gateway de Internet
**O que é:** Um recurso para permitir que a VPC se conecte à internet.

### Passos:
1. Acesse **Gateways de Internet**.
2. Clique em **Criar Gateway de Internet**.
3. Nomeie o gateway e clique em **Criar**.
4. **Anexe o Gateway de Internet à VPC:**
   - Após criado, selecione o gateway > **Ações > Anexar à VPC**.

---

## 3. Criar Subnets
**O que é:** Divisões lógicas dentro da VPC para organizar recursos.

### Passos:
1. Acesse **Subnets**.
2. Clique em **Criar Subnet**.
3. Escolha a **VPC associada**.
4. Especifique:
   - **Nome da subnet**.
   - **Zona de Disponibilidade** (opcional).
   - **Faixa de CIDR** (exemplo: `10.0.1.0/24` para subnets públicas e privadas).

---

## 4. Configurar a Tabela de Rotas
**O que é:** Define como o tráfego será roteado dentro e fora da VPC.

### Passos:
1. Acesse **Tabelas de Rotas**.
2. Verifique a tabela de rotas associada à subnet.
3. Adicione uma rota:
   - **Destino:** `0.0.0.0/0` (internet).
   - **Target:** Gateway de Internet.

---

## 5. Criar Instâncias EC2 e Interfaces de Rede
**O que é:** As instâncias EC2 usam interfaces de rede (ENIs) para conectar-se às subnets.

### Passos:
1. Acesse **Instâncias EC2 > Lançar Instância**.
2. Escolha:
   - **AMI** (ex.: Amazon Linux, Ubuntu).
   - **Tipo de instância** (ex.: `t2.micro`).
3. **Configuração de rede:**
   - Escolha a **VPC** e a **subnet**.
   - Associe um endereço IP público (para subnets públicas).
4. Conclua a configuração e lance a instância.

---

## 6. Adicionar ENIs (Opcional)
Você pode criar ENIs adicionais e anexá-las a instâncias EC2 se necessário.

### Passos:
1. Acesse **Interfaces de Rede > Criar Interface de Rede**.
2. Especifique:
   - **Subnet**.
   - **Endereço IP privado** (opcional).
3. Após criado, **anexar à instância EC2**.

---

## 7. Testar a Conexão
1. Certifique-se de que a configuração do **grupo de segurança** (firewall) permite tráfego de entrada e saída.
2. Teste acessando a instância EC2 via SSH (se aplicável).

---

## Resumo
- A VPC e o gateway de internet criam a estrutura básica da rede.
- Subnets dividem a rede em públicas (com acesso à internet) e privadas (isoladas).
- Instâncias EC2 usam interfaces de rede (ENIs) para se conectar a essas subnets.


<p align="center">
<pre>
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
|   Public Subnet      |                     |   Public Subnet     |         
| (Frontend Subnet)    |                     | (Backend Subnet)    |          
| 10.0.1.0/24          |                     | 10.0.2.0/24         |          
+---------------------+                     +---------------------+          
            |                                       |                       
  +------------------+                         +------------------+         
  | Frontend EC2     |                         | Backend EC2      |          
  | (Nginx + React)  |                         | (Node.js + Mongo)|         
  +------------------+                         +------------------+          
            |                                       |                       
       +----------+                               +----------+               
       |  Nginx   |                               |  Node.js |               
       |  Serve   |                               |  App     |               
       +----------+                               +----------+               
            |                                             |                 
            +---------------------------------------------+                 
                                |                                             
                      +---------------------+                                 
                      |  Load Balancer       |                                 
                      +---------------------+                                 
                                |                                             
                                v                                             
                   +-----------------------+                                  
                   |  Target Group Backend |                                 
                   +-----------------------+                                  
                                |                                      
                                v                                   
                        +---------------------+                        
                        | GitHub Actions CI/CD |                        
                        +---------------------+                        
                                |                                      

                         +----------------+                          
                         | Deploy to EC2   |                          
                         | (Frontend Nginx) |                          
                         +----------------+
</pre>
</p>


Cultura DevOps
A cultura DevOps é um conjunto de práticas que visa integrar e automatizar os processos entre os desenvolvedores de software e os profissionais de operações de TI. O objetivo é melhorar a colaboração entre esses dois grupos e permitir um desenvolvimento e uma entrega de software mais rápidos e eficientes. O DevOps enfatiza a comunicação, automação, monitoramento e a colaboração entre equipes de diferentes áreas, a fim de criar um ciclo contínuo de feedback e melhoria.

Princípios Fundamentais do DevOps:
Colaboração: Redefine as fronteiras entre desenvolvimento e operações, promovendo um ambiente de colaboração contínua.
Automação: Automatiza o máximo de processos possível para reduzir erros manuais e acelerar as entregas.
Integração contínua e entrega contínua (CI/CD): A prática de integrar e testar código de forma contínua, e entregar de forma automática em ambientes de produção.
Monitoramento contínuo: O monitoramento constante do desempenho dos sistemas e aplicativos para detectar problemas rapidamente.

As 3 Maneiras do DevOps:

Fluxo:
O fluxo se concentra em garantir que as entregas de software sejam feitas de forma contínua e eficiente. Isso é alcançado através da automação do pipeline de desenvolvimento, evitando gargalos e permitindo uma entrega constante.
Exemplo: Uma equipe que usa Containers (como Docker) e Kubernetes para garantir que as aplicações sejam desenvolvidas e entregues de forma rápida e sem interrupções.

Feedback:

O feedback contínuo é essencial para que as equipes ajustem rapidamente suas estratégias e soluções. Isso é realizado por meio de testes automatizados e monitoramento constante, que permitem identificar problemas antes que se tornem críticos.
Exemplo: Equipes que usam Testes Automatizados e Monitoramento para detectar erros em tempo real e ajustar o código ou infraestrutura imediatamente.

Aprendizado Contínuo:

O aprendizado contínuo está relacionado ao processo de sempre buscar melhorar as práticas e o processo. Isso envolve avaliar os resultados, realizar retrospectivas e aplicar as lições aprendidas nas iterações futuras.
Exemplo: Equipes que realizam Retrospectivas Regulares e analisam falhas ou sucessos para melhorar as práticas de desenvolvimento.

2. Criação de um Infográfico

Estrutura do Infográfico

|--------------------------------------------|
|              Cultura DevOps                |
|  A cultura DevOps visa integrar e otimizar  |
|  processos entre desenvolvimento e         |
|  operações para uma entrega mais rápida e  |
|  eficiente de software.                    |
|--------------------------------------------|
|  Fluxo                                      |
|  - Automação de CI/CD e entrega contínua    |
|  - Uso de containers, como Docker e        |
|    Kubernetes                              |
|  [Ícone de fluxo contínuo]                  |
|--------------------------------------------|
|  Feedback                                   |
|  - Testes automatizados e monitoramento    |
|  - Detecção de erros em tempo real         |
|  [Ícone de feedback]                        |
|--------------------------------------------|
|  Aprendizado Contínuo                      |
|  - Melhoria contínua baseada em análises   |
|    de dados e retrospectivas               |
|  [Ícone de evolução/ciclo]                 |
|--------------------------------------------|
|  Exemplos Práticos:                        |
|  Netflix, Amazon, Spotify                  |
|--------------------------------------------|

3. Reflexão
Após a criação do infográfico e da apresentação, faça uma reflexão pessoal sobre como a cultura DevOps e suas 3 maneiras podem ser aplicadas no seu ambiente de trabalho ou em projetos futuros. Algumas ideias que você pode incluir no relatório:

Como Aplicar DevOps em Meu Trabalho:
Fluxo: Automatizar processos de integração e entrega contínua para acelerar o desenvolvimento de novos recursos e reduzir erros manuais.
Feedback: Implementar testes automatizados e monitoramento para obter feedback constante sobre a qualidade do código e da infraestrutura.
Aprendizado Contínuo: Adotar a prática de retrospectivas regulares, onde a equipe analisa o que foi bem e o que pode ser melhorado, garantindo o aprendizado contínuo e a evolução das práticas de desenvolvimento.

