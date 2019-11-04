# basic allow ssh from everywhere group
resource "aws_security_group" "default_sg" {
  name        = "${var.name}"
  description = "Default security group for any instance in ${var.name}"
  vpc_id      = "${module.data_vpc.vpc_id}"

  tags {
    Name = "${var.name}_default_sg"
  }
}

resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]                         # This should be locked down
  security_group_id = "${aws_security_group.default_sg.id}"
}

resource "aws_security_group_rule" "allow_outbound" {
  type        = "egress"
  from_port   = 0
  protocol    = -1
  cidr_blocks = ["0.0.0.0/0"]
  to_port     = 0
  security_group_id = "${aws_security_group.default_sg.id}"
}

# # kafka rules for kafka box
resource "aws_security_group" "kafka_sg" {
  name        = "kafka_security_group"
  description = "Default security group for any instance in kafka_security_group"
  vpc_id      = "${module.data_vpc.vpc_id}"

  tags {
    Name = "${var.name}_kafka_security_group"
  }
}

resource "aws_security_group_rule" "kafka_rule_access_2181" {
  count = "${length(var.ip_address_kafka) > 0 ? length(var.ip_address_kafka) : 0}"
  type              = "ingress"
  from_port         = 2181
  to_port           = 2181
  protocol          = "tcp"
  cidr_blocks       = ["${element(var.ip_address_kafka, count.index)}"]
  security_group_id = "${aws_security_group.kafka_sg.id}"
}

resource "aws_security_group_rule" "kafka_rule_access_9092" {
  count = "${length(var.ip_address_kafka) > 0 ? length(var.ip_address_kafka) : 0}"
  type              = "ingress"
  from_port         = 9092
  to_port           = 9092
  protocol          = "tcp"
  cidr_blocks       = ["${element(var.ip_address_kafka, count.index)}"]
  security_group_id = "${aws_security_group.kafka_sg.id}"
}

# elasticsearch box

resource "aws_security_group" "elasticsearch_sg" {
  name        = "elasticsearch_security_group"
  description = "Default security group for any instance in elasticsearch_security_group"
  vpc_id      = "${module.data_vpc.vpc_id}"

  tags {
    Name = "${var.name}_elasticsearch_security_group"
  }
}

resource "aws_security_group_rule" "elasticsearch_rule_access_9200" {
  count = "${length(var.ip_address_elasticsearch) > 0 ? length(var.ip_address_elasticsearch) : 0}"
  type              = "ingress"
  from_port         = 9200
  to_port           = 9200
  protocol          = "tcp"
  cidr_blocks       = ["${element(var.ip_address_elasticsearch, count.index)}"]
  security_group_id = "${aws_security_group.elasticsearch_sg.id}"
}

resource "aws_security_group_rule" "elasticsearch_rule_access_9300" {
  count = "${length(var.ip_address_elasticsearch) > 0 ? length(var.ip_address_elasticsearch) : 0}"
  type              = "ingress"
  from_port         = 9300
  to_port           = 9300
  protocol          = "tcp"
  cidr_blocks       = ["${element(var.ip_address_elasticsearch, count.index)}"]
  security_group_id = "${aws_security_group.elasticsearch_sg.id}"
}


# cassandra rules for cassandra box

resource "aws_security_group" "cassandra_sg" {
  name        = "cassandra_security_group"
  description = "Default security group for any instance in cassandra_security_group"
  vpc_id      = "${module.data_vpc.vpc_id}"

  tags {
    Name = "${var.name}_cassandra_security_group"
  }
}

resource "aws_security_group_rule" "cassandra_rule_access_9042" {
  count = "${length(var.ip_address_cassandra) > 0 ? length(var.ip_address_cassandra) : 0}"
  type              = "ingress"
  from_port         = 9042
  to_port           = 9042
  protocol          = "tcp"
  cidr_blocks       = ["${element(var.ip_address_cassandra, count.index)}"]
  security_group_id = "${aws_security_group.cassandra_sg.id}"
}

# cassandra rules for cassandra box

resource "aws_security_group" "mongodb_sg" {
  name        = "mongodb_security_group"
  description = "Default security group for any instance in mongodb_security_group"
  vpc_id      = "${module.data_vpc.vpc_id}"

  tags {
    Name = "${var.name}_mongodb_security_group"
  }
}

resource "aws_security_group_rule" "mongodb_rule_access_27017" {
  count = "${length(var.ip_address_mongodb) > 0 ? length(var.ip_address_mongodb) : 0}"
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  cidr_blocks       = ["${element(var.ip_address_mongodb, count.index)}"]
  security_group_id = "${aws_security_group.mongodb_sg.id}"
}

# resource "aws_security_group" "cassandra_sg" {
#   name        = "${var.name}-cassandra"
#   description = "cassandra access"
#   vpc_id      = "${module.data_vpc.vpc_id}"

#   tags {
#     Name = "${var.name}_cassandra_sg"
#   }
# }

# resource "aws_security_group_rule" "allow_cassandra" {
#   from_port = 9042
#   protocol = "tcp"
#   security_group_id = "${aws_security_group.cassandra_sg.id}"
#   to_port = 9042
#   type = "ingress"
#   # everything in the entire data VPC can get to cassandra
#   cidr_blocks = ["${var.vpc_cidr}"]
# }

# resource "aws_security_group" "elasticsearch_sg" {
#   name = "${var.name}-elasticsearch"
#   description = "elasticsearch access rules"
#   vpc_id = "${module.data_vpc.vpc_id}"

#   tags {
#     Name = "${var.name}_elasticsearch_sg"
#   }
  
#   ingress {
#     from_port = 9200
#     to_port = 9200
#     protocol =  "tcp"
#     cidr_blocks = ["${var.vpc_cidr}"]
#   }
  
#   ingress {
#      from_port = 9300
#      to_port = 9300
#      protocol = "tcp"
#      cidr_blocks = ["${var.vpc_cidr}"]
#   }
# }


# # kafka rules for kafka box
# resource "aws_security_group" "kafka_sg" {
#   name        = "${var.name}-kafka"
#   description = "kafka access"
#   vpc_id      = "${module.data_vpc.vpc_id}"

#   tags {
#     Name = "${var.name}_kafka_sg"
#   }
  
#   ingress {
#     from_port = 2181
#     to_port = 2181
#     protocol =  "tcp"
#     cidr_blocks = ["${var.vpc_cidr}"]
#   }
  
#   ingress {
#      from_port = 9092
#      to_port = 9092
#      protocol = "tcp"
#      cidr_blocks = ["${var.vpc_cidr}"]
#   }
# }