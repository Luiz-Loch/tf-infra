# TODO:
Módulos que devem ser conferidos e aperfeiçoados.
Deve-se explicar como funciona o módulo, adicionar descrição nas variáveis e saídas, assim de um README.md explicando o funcionamento com exemplo e o que cada variável faz

- Rede:
    - VPC;
    - Subnet;
    - Gateway;
    - NAT gateway;
    - Route table;
- EC2:
    - Instância
    - Load balancer;
        - poder fazer mapeamento de rotas de forma dinâmica
    - Auto Scaling Group (poder fazer usar no cluster ecs)
- ECS:
    - ECR
    - Cluster (ec2 e fargate) (verificar como funciona a criptografia com chave kms)
    - Task defition
    - services
- EKS:
    - Cluster;
    - Node group EC2;
    - Node group Fargate;
- Lambda:
    - Ajustar permissões IAM;
    - Criar log groups e anexar;
    - Generalizar mais e usar os parâmetros necessários;
    - Criar um dicionário com os possíveis modulos/nome de funções?
    - Como armazenar variáveis de ambiente?