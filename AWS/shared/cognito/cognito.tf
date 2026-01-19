# Pool
resource "aws_cognito_user_pool" "pool" {
  name = "${var.environment}-${var.project_name}"

  # Password strength and security policy
  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  # Sign-in configuration: Users will sign in using their email
  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  # Standard attributes definition
  schema {
    attribute_data_type      = "String"
    name                     = "email"
    required                 = true
    mutable                  = true
  }

}


# Client Configuration
resource "aws_cognito_user_pool_client" "client" {
  name         = "${var.app_name}"
  user_pool_id = aws_cognito_user_pool.pool.id

  # Authentication flows allowed for the application
  explicit_auth_flows = [
    "ALLOW_USER_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",       # For direct username/password auth
    "ALLOW_ADMIN_USER_PASSWORD_AUTH", # To keep sessions alive
    "ALLOW_USER_SRP_AUTH"             # Secure Remote Password (standard)
  ]

  generate_secret = true 
}