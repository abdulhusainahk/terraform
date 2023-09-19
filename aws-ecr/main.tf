resource "aws_ecr_repository" "ecr" {
  name                 = var.ecr_name
  image_tag_mutability = var.image_tag_mutability
  tags = var.tags
  image_scanning_configuration {
    scan_on_push = var.image_scanning_on_push
  }
}