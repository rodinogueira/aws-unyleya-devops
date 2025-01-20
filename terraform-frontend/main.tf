# Configuração do provedor AWS
provider "aws" {
  region = "us-east-1"
}

# Buscar a AMI mais recente do Amazon Linux 2
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Criar um par de chaves para acesso SSH
resource "aws_key_pair" "ssh_key" {
  key_name   = "my-key"
  public_key = file("~/.ssh/my-key.pub")
}

# Usar uma VPC existente
data "aws_vpc" "main_vpc" {
  id = "vpc-098a8f180f41d5672"  # O ID da VPC existente
}

# Buscar o Internet Gateway existente pela VPC
data "aws_internet_gateway" "main_igw" {
  filter {
    name   = "attachment.vpc-id"
    values = ["vpc-098a8f180f41d5672"]
  }
}

# Criar uma Subnet Pública para o Frontend
resource "aws_subnet" "frontend_subnet" {
  vpc_id                  = data.aws_vpc.main_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "FrontendSubnet"
  }
}

# Criar o Security Group para o Frontend (permitindo HTTP na porta 80)
resource "aws_security_group" "frontend_sg" {
  vpc_id = data.aws_vpc.main_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permite acesso HTTP ao frontend
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "FrontendSecurityGroup"
  }
}

# Criar a instância Frontend
resource "aws_instance" "frontend_instance" {
  ami                   = data.aws_ami.amazon_linux.id
  instance_type         = "t2.micro"
  key_name              = aws_key_pair.ssh_key.key_name
  subnet_id             = aws_subnet.frontend_subnet.id
  vpc_security_group_ids = [aws_security_group.frontend_sg.id]

  tags = {
    Name = "Frontend"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    curl -sL https://rpm.nodesource.com/setup_16.x | sudo bash - 
    sudo yum install -y nodejs

    # Instalar o servidor Nginx para servir a aplicação React
    sudo yum install -y nginx
    sudo systemctl enable nginx
    sudo systemctl start nginx

    # Clonar o repositório do frontend (React)
    git clone https://github.com/rodinogueira/market-place-react.git /home/ec2-user/frontend
    cd /home/ec2-user/frontend

    # Instalar dependências e criar o build do React
    npm install
    npm run build

    # Copiar o build para o diretório do Nginx
    sudo cp -r build/* /usr/share/nginx/html/

    echo "Frontend React configurado e servido pelo Nginx."
  EOF
}

# Criar a rota para permitir acesso externo à VPC (via Internet Gateway)
resource "aws_route_table" "public_route_table" {
  vpc_id = data.aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.main_igw.id  # Usar o Internet Gateway existente
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

# Associar a tabela de rotas à Subnet Pública
resource "aws_route_table_association" "frontend_subnet_assoc" {
  subnet_id      = aws_subnet.frontend_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}
