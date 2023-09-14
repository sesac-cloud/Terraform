data "tfe_outputs" "aws_output" {
  organization = var.tc_organization
  workspace    = var.tc_workspace
}