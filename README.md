# Terraform e Nginx
| Programa | Versão |
| ------ | ------ |
| Terraform | v1.0.7 |
| Docker | v20.10.11 |

# Imagem Nginx
| Arquivo | Conteúdo |
| ------ | ------ |
| Dockerfile | Cria uma imagem personalizada do Nginx. Ela se baseia na imagem [nginx:alpine](https://hub.docker.com/layers/nginx/library/nginx/alpine/images/sha256-682e85d8b92ed22dba0f8432d0ff9fa7c5c8d2f78b0bacb06e4d83b2881313c4?context=explore). |
| index.html |  Cria um botão que redireciona para o site do Clicksign. |
| push.sh | O arquivo push.sh é uma forma de facilitar em dar push em imagens para o DockerHub. Contém duas variavéis que podem ser mudadas para colocar no seu próprio DockerHub. |

![Build Status](https://raw.githubusercontent.com/robertasolimandonofreo/ecs-terraform-nginx/main/imagens/push.png)
# Terraform
O segunda passo foi criar a infra com o Terraform que consiste num cluster ECS Fargate rodando uma imagem criada anteriormente. 
| Arquivo | Conteúdo |
| ------ | ------ |
| provider.tf | A primeira etapa foi criar o arquivo para o provedor Terraform. Este arquivo é usado para inicializar o provedor da AWS. |
| variables-auth.tf | Cria as variáveis de autenticação da AWS. |
| variables-app.tf | Cria as variáveis do aplicativo. |
| network.tf | Cria todos os componentes de rede necessários: VPC, Sub-redes, Gateway de Internet (usado para fornecer acesso à Internet para sub-redes públicas) e Rotas para a Internet. Ele cria os seguintes recursos: aws_vpc, aws_subnet, aws_internet_gateway, aws_route_table |
| ecs-cluster-variables.tf | Variáveis do cluster do ECS  O tipo de instância EC2 é t3.medium e o número de instância é 1. |
| ecs-cluster.tf | Cria o cluster do ECS. Na primeira parte do arquivo ele cria o recurso do cluster ecs "aws_ecs_cluster", obtém os dados ecs ami mais recentes, substitui a variável de imagem ecs ami "aws_ecs_ami_override", cria uma instância ec2 para o recurso de execução de cluster ecs "aws_instance" e cria grupos de segurança e regras de segurança para o recurso de cluster ecs "aws_security_group". |
| ecs-cluster-policies.tf | Políticas de cluster do ECS. |
| cluster_user_data.sh | Este arquivo é usado para configurar a partição do disco rígido das instâncias do EC2. |
| nginx-variables.tf | Variáveis do Nginx. |
| nginx.json | Informações do contêiner do aplicativo Nginx, usado para configurar o container Nginx Fargate. |
| nginx-container.tf | Container Nginx. Contém o template do container, recurso de definição de tarefa do ECS "aws_ecs_task_definition" e o recurso de serviço ECS "aws_ecs_service".  |
| nginx-segurity.tf | Grupos de segurança Nginx. Contém o tráfego para o cluster do ECS a partir do recurso ALB "aws_security_group" "aws-ecs-tasks".  |
| nginx-alb.tf  | Balanceador de carga do aplicativo Nginx. Ele redireciona todo o tráfego do ALB para o recurso do grupo de destino.  |
| terraform.tfvars | Atualiza credenciais da AWS e outras configurações do acesso ao aplicativo.|

![Build Status](https://raw.githubusercontent.com/robertasolimandonofreo/ecs-terraform-nginx/main/imagens/terraform.png)

## Como implantar o cluster na AWS
1. Crie um usuário do IAM e atualize o arquivo terraform.tfvars com as credenciais. 
2. Atualize as configurações de ARN e ID de recurso do Amazon ECS
3. Gere e baixe um par de chaves EC2 (arquivo .pem). 

## Executar o Terraform
1. Clone o seguinte repositório GitHub https://github.com/robertasolimandonofreo/ecs-terraform-nginx.git
2. Execute o comando terraform init na linha de comando, na mesma pasta em que seu código está localizado.
3. Em seguida, execute o comando terraform apply na linha de comando para iniciar a construção da infraestrutura.

# Grafana
| Arquivo | Conteúdo |
| ------ | ------ |
| datasource-conf | Ele provisiona o CloudWatch, para pegar métricas da AWS e passar para o Grafana. É necessário colocar sua acesskey e sua secretkey no arquivo.
| dashboards-conf | Ele provisiona os dashbords para a pasta DevOps. |
| grafana.ini | Arquivo principal do grafana, coloquei algumas configurações de porta, ip e nome da instância. |
| ecs.json | Dashboard para coletar métricas do ECS. |
| ecs2.json | Dashboard para coletar métricas do EC2. |
| elb.json | Dashboard para coletar métricas do ELB. |
| .env | User e senha admin do Grafana. |
|docker-compose.yml | Sobe o container do Grafana. |
| Dockerfile | Cria uma imagem personalizada do Grafana. |

Agora execute o comando "docker-compose up" dentro da pasta, e já podemos ver no http://localhost:3000/ as métricas coletadas.
![Build Status](https://raw.githubusercontent.com/robertasolimandonofreo/ecs-terraform-nginx/main/imagens/dash.png)
![Build Status](https://raw.githubusercontent.com/robertasolimandonofreo/ecs-terraform-nginx/main/imagens/ecs.png)
![Build Status](https://raw.githubusercontent.com/robertasolimandonofreo/ecs-terraform-nginx/main/imagens/data.png)
# Jenkins
Para facilitar e constuir toda nossa infra, sem precisar seguir os passos anteriores, criei uma imagem personalizada do Jenkins e uma pipeline.
| Arquivo | Conteúdo |
| ------ | ------ |
| default-user.groovy | Cria o user e a senha localizada no Dockerfile |
|docker-compose.yml | Sobe o container do Jenkins. |
| Dockerfile | Cria uma imagem personalizada do Jenkins. |
| jenkins-plugins | Instala os plugins que está na lista. |


O arquivo Jenkinsfile segue os seguintes passos:
1. Clona esse repositório.
2. Build na imagem do nginx e coloca no DockerHub.
3. Aplica o cluster ECS Fargate utilizando o Terraform.
4. Inicia o Grafana e provisiona todos os recursos necessários.

Após executar o Jenkinsfile, já temos todos os serviços necessários para visualizar o site.
![Build Status](https://raw.githubusercontent.com/robertasolimandonofreo/ecs-terraform-nginx/main/imagens/jenkins.png)

Serviço | Usuário | Senha |
| ------ | ------ | ------ |
| Grafana | admin | admin |
| Jenkins | admin | admin |

Arquivos necessários para adicionar sua credencial AWS e Região: 
> grafana > conf > provisioning > datasources > conf.yaml

> terraform > terraform.tfvars

Comandos utilizados:
```git clone https://github.com/robertasolimandonofreo/ecs-terraform-nginx.git
cd ecs-terraform-nginx
cd nginx
docker build -t webserver .
./push.sh
cd ..
cd terraform 
terraform init
terraform apply
cd ..
cd grafana
docker-compose up
cd ..
cd jenkins
docker-compose up 
```
