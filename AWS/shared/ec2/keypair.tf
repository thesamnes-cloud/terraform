resource "aws_key_pair" "app_server" {
  key_name   = "prod-mindbio-server"
    public_key = file("~/.ssh/prod-mindbio-server.pub")
}
