resource "aws_key_pair" "app_server" {
  key_name   = "prod-mindbio-server"
  public_key = file("${path.root}/shared/keys/prod-mindbio-server.pub")
}
