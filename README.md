# Desafio SRE

## Caminho escolhido para resolução do desafio

Levando em consideração o cenário e os requisitos, o caminho que decidi seguir foi utilizar a plataforma do GitHub para armazenar o projeto utilizando os gitActions para gerar os workflows para mim. Para a Infraestrutura como Código (IaC), optei por utilizar o Terraform, pois é uma das ferramentas de infraestrutura de código nas quais possuo bastante experiência. Em relação aos recursos na AWS, optei por utilizar o Fargate junto com o RDS e outros recursos que dão suporte a eles.

## Pré-Requisitos

* **Terraform - v1.7.4**
* **Aws Cli - 2.15.21**
* **Docker -  24.0.5**
* **Github**

## Topologia

![sre drawio](https://github.com/Galactros/desafio-sre/assets/6877766/dbda2b6e-4490-4dae-8309-2a3cc338a24f)


## Ferrramentas utilizadas

* [Terraform](https://www.terraform.io/)
* [Github](https://github.com/Galactros/desafio-sre)
* [Amazon Web Services](https://aws.amazon.com/pt/)
* Terraform Modules: [Elastic Container Service](https://registry.terraform.io/modules/terraform-aws-modules/ecs/aws/latest), [Relational Database Service](https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/latest), [Route53](https://registry.terraform.io/modules/terraform-aws-modules/route53/aws/latest), [AWS Certificate Manager](https://registry.terraform.io/modules/terraform-aws-modules/acm/aws/latest) , [Application Load Balancer](https://registry.terraform.io/modules/terraform-aws-modules/alb/aws/latest), [Virtual Private Cloud](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
* [Godaddy Domain](https://www.godaddy.com/pt-br)
* [Metabase Open Source](https://github.com/metabase/metabase)

## Como executar o metabase local

* Instalar docker [Windows](https://docs.docker.com/desktop/install/windows-install/) ou [Linux](https://docs.docker.com/desktop/install/linux-install/)
* Executar o docker compose na raiz do repositório
* ``` docker compose up -d ```

## Como criar o ambiente do metabase na Aws utilizando o cli local

* Instalar [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
* Instalar [Aws Cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
* Configurar o aws cli: ``` aws configure ```

#### Criando os arquivos de estado para o terraform

* Vá para o diretorio infra/metabase-tfstate
* Execute o comando: ``` terraform init -upgrade ```
*  ``` terraform apply ```
* Desta forma os estados do terraform serão salvos em um bucket para os demais terraforms

#### Criando o Ecr para armazenar as imagens do metabase

* Vá para o diretorio infra/metabase-ecr
* Execute o comando: ``` terraform init -upgrade ```
*  ``` terraform apply ```

#### Construindo e enviado imagem do metabase para o Ecr

* Faça o login em seu Ecr trocando os valores da **region** e **registry account**: ``` aws ecr get-login-password --region region | docker login --username AWS --password-stdin aws_account_id.dkr.ecr.region.amazonaws.com ```
* Construa a imagem a ser enviada para o Ecr na raiz do repositório trocando os valores da **region** e **registry account**: ``` docker build -t aws_account_id.dkr.ecr.region.amazonaws.com/ecr-desafio-sre:latest . ```
* Envie a imagem para o Ecr: ``` docker push aws_account_id.dkr.ecr.region.amazonaws.com/ecr-desafio-sre:latest ```

#### Subindo todo ambiente do metabase

* Vá para o diretorio infra/metabase-fargate
* Execute o comando: ``` terraform init -upgrade ```
*  ``` terraform apply ```
* Ps: Para que essa etapa seja feita com sucesso será necessaria a configuração dos servidores de nomes. Caso haja falha na execução do apply execute novamente apos configuração do dns para que o mesmo seja concretizado.

#### Configure os servidores de nomes no dominio privado

* Pegue os servidores de nomes no route53
* Configure no dominio privado e aguarde alguns minutos
* Após isso basta acessar via o dominio configurado

## Fluxo básico de alterações no projeto

```mermaid
---
title: Git flow
---
gitGraph
   commit
   branch homolog
   branch production
   branch feature1
   checkout feature1
   commit
   commit
   checkout main
   merge feature1
   branch feature2
   checkout feature2
   commit
   commit
   checkout main
   merge feature2
   checkout homolog
   merge main
   checkout production
   merge homolog
   checkout main
   merge production
   branch feature3
   checkout feature3
   commit
   commit
   checkout main
   merge feature3
```
