module "servico_01" {
  source = "../../modules/aws/ecr"
  name   = "${local.name}-servico-01"
  tags   = local.tags
}

module "servico_02" {
  source = "../../modules/aws/ecr"
  name   = "${local.name}-servico-02"
  tags   = local.tags
}