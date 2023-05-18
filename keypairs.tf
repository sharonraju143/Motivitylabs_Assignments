resource "aws_key_pair" "projectkey" {
  key_name   = "project"
  public_key = file(var.PUB_KEY_PATH)
}
