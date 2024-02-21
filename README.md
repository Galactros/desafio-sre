# Desafio SRE

## Pré-Requisitos

* **Terraform**
* **Aws Cli Config**
* **Docker**

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

#### Configure os servidores de nomes no dominio privado

* Pegue os servidores de nomes que o terraform irá dar output
* Configure no dominio privado e aguarde alguns minutos
* Após isso basta acessar via o dominio configurado