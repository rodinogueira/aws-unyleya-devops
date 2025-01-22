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
  | Frontend ENI      |                         | Backend ENI      |          
  +------------------+                         +------------------+          
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
