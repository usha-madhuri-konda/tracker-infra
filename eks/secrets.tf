resource "aws_secretsmanager_secret" "postgres_password" {
  name                    = "tracker/postgres-password"
  description             = "Password of the tracker Postgres database"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret" "secret_key" {
  name                    = "tracker/secret-key"
  description             = "Flask SECRET_KEY that signs login session cookies"
  recovery_window_in_days = 0
}
