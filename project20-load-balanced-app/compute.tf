data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_instance" "web" {
  count = 2

  ami                         = data.aws_ssm_parameter.al2023_ami.value
  instance_type               = var.instance_type
  subnet_id                   = local.subnet_ids[count.index]
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true

  user_data_replace_on_change = true
  user_data                   = <<-USERDATA
    #!/bin/bash
    set -euxo pipefail
    dnf install -y nginx

    INSTANCE_ID=$(curl -s http://169.254.169.254/latest/api/token \
      -X PUT -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" | \
      xargs -I TOKEN curl -s -H "X-aws-ec2-metadata-token: TOKEN" \
      http://169.254.169.254/latest/meta-data/instance-id)

    AZ=$(curl -s http://169.254.169.254/latest/api/token \
      -X PUT -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" | \
      xargs -I TOKEN curl -s -H "X-aws-ec2-metadata-token: TOKEN" \
      http://169.254.169.254/latest/meta-data/placement/availability-zone)

    HOSTNAME=$(hostname)

    cat > /usr/share/nginx/html/index.html <<HTML
    <!doctype html>
    <html lang="en">
    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <title>Project 20 - Load Balanced App</title>
      <style>
        body { font-family: Arial, sans-serif; background:#f4f7fb; margin:0; display:grid; place-items:center; min-height:100vh; }
        .card { background:white; width:min(720px,88vw); padding:36px; border-radius:18px; box-shadow:0 12px 35px rgba(0,0,0,.12); border-top:8px solid #ff9900; }
        h1 { color:#232f3e; margin-top:0; }
        .server { font-size:1.5rem; color:#0972d3; font-weight:700; }
        code { background:#eef2f6; padding:4px 8px; border-radius:6px; }
        .note { margin-top:24px; color:#52606d; }
      </style>
    </head>
    <body>
      <main class="card">
        <h1>Project 20: Application Load Balancer</h1>
        <p>Request served successfully by:</p>
        <p class="server">Web Server ${count.index + 1}</p>
        <p>Instance ID: <code>$INSTANCE_ID</code></p>
        <p>Availability Zone: <code>$AZ</code></p>
        <p>Hostname: <code>$HOSTNAME</code></p>
        <p class="note">Refresh several times or run the provided curl loop to demonstrate traffic distribution.</p>
      </main>
    </body>
    </html>
    HTML

    systemctl enable --now nginx
  USERDATA

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name = "${var.project_name}-web-${count.index + 1}"
  }
}
