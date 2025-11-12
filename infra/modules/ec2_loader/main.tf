resource "aws_security_group" "this" {
  name        = "${var.env}-${var.name}-sg"
  description = "Minimal egress-only SG for ${var.env}-${var.name}"
  vpc_id      = data.aws_subnet.this.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.env}-${var.name}-sg" })
}

data "aws_subnet" "this" {
  id = var.subnet_id
}

resource "aws_iam_instance_profile" "this" {
  name  = "${var.env}-${var.name}-profile"
  role  = var.iam_role_name
}

resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.this.id]
  iam_instance_profile = aws_iam_instance_profile.this.name

  # IMDSv2 required
  metadata_options {
    http_tokens = "required"
  }

  # Root volume
  root_block_device {
    volume_size           = var.volume_size_gb
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = merge(var.tags, { Name = "${var.env}-${var.name}" })
}