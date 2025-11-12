resource "aws_security_group" "this" {
  name        = "${var.env}-${var.name}-sg"
  description = "Minimal egress-only SG for ${var.env}-${var.name}"
  vpc_id      = data.aws_subnet.this.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
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

    user_data = <<EOF
#!/bin/bash
set -euxo pipefail

# Clean stale SSM registration & logs (when launching from an AMI)
systemctl stop amazon-ssm-agent || true
rm -rf /var/lib/amazon/ssm/* /var/log/amazon/ssm/* || true

# Install/refresh SSM agent and start it
if command -v yum >/dev/null 2>&1; then
  yum -y install amazon-ssm-agent || yum -y reinstall amazon-ssm-agent
  systemctl enable --now amazon-ssm-agent
elif command -v apt-get >/dev/null 2>&1; then
  # prefer deb if available; fall back to snap
  apt-get update -y || true
  apt-get install -y amazon-ssm-agent || true
  systemctl enable --now amazon-ssm-agent || (
    snap install amazon-ssm-agent --classic || true
    systemctl enable --now snap.amazon-ssm-agent.amazon-ssm-agent.service
  )
fi
EOF

  user_data_replace_on_change = true

  metadata_options {
    http_tokens = "optional"
  }

  # Root volume
  root_block_device {
    volume_size           = var.volume_size_gb
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = merge(var.tags, { Name = "${var.env}-${var.name}" })
}