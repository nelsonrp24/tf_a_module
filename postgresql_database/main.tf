terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

data "aws_subnet_ids" "all" {
  vpc_id = "${var.vpc_id}"
}

module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "${var.vpc_id}"

  engine            = "postgres"
  engine_version    = "9.6.3"
  instance_class    = "db.t2.medium"
  allocated_storage = 5
  storage_encrypted = false
  publicly_accessible = true

  # kms_key_id        = "arm:aws:kms:<region>:<account id>:key/<kms key id>"
  name = "${var.db_name}"

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  username = "${var.username}"

  password = "${var.password}"
  port     = "${var.port}"

  vpc_security_group_ids = ["${aws_security_group.postgres_sg.id}"]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # disable backups to create DB faster
  backup_retention_period = 0

  tags = {
    Owner       = "${var.username}"
    Environment = "${var.env}"
  }

  # DB subnet group
  subnet_ids = ["${data.aws_subnet_ids.all.ids}"]

  # DB parameter group
  family = "postgres9.6"

  # DB option group
  major_engine_version = "9.6"

  # Snapshot name upon DB deletion
  final_snapshot_identifier = "${var.db_name}"

  # Database Deletion Protection
  deletion_protection = false
}
