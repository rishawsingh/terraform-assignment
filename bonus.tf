# 1. phpmyadmin is already installed on EC2 instance.
# 2. Install Certbot and get SSL certificate from Let's Encrypt
resource "null_resource" "certbot" {
  depends_on = [aws_eip.wordpress_eip]

  provisioner "local-exec" {
    command = <<-EOF
      sudo yum install -y certbot python3-certbot-apache
      sudo certbot --apache --non-interactive --agree-tos --email admin@example.com -d example.com
    EOF
  }
}

# Create Route53 record for the domain
resource "aws_route53_record" "wordpress_record" {
  zone_id = "ZXXXXXXXXXXXXX"
  name    = "example.com"
  type    = "A"

  alias {
    name                   = aws_eip.wordpress_eip.public_ip
    zone_id                = aws_eip.wordpress_eip.zone_id
    evaluate_target_health = false
  }
}
