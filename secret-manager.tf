resource "aws_secretsmanager_secret" "my-privet-key" {
  name = "my-privet-key"
  recovery_window_in_days = 0
}


resource "aws_secretsmanager_secret_version" "e" {
  secret_id     = aws_secretsmanager_secret.my-privet-key.id
  secret_string = tls_private_key.mykey.private_key_pem
}
