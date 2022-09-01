data "aws_ami" "tf_ububtu_ami" {
  most_recent = true

  # getting from aws ami seach
  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}