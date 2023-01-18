source "amazon-ebs" "region1" {

  region = var.regions.region1   
  access_key = var.access_key
  secret_key = var.secret_key
  ami_name = local.image-name
  source_ami  = var.ami[var.regions.region1]
  instance_type = "t2.micro"
  ssh_username = "ec2-user"
  tags = {
    Name = local.image-name
    project = var.project
    env =  var.environment
  }  
}

source "amazon-ebs" "region2" {

  region = var.regions.region2
  access_key = var.access_key
  secret_key = var.secret_key
  ami_name = local.image-name
  source_ami  = var.ami[var.regions.region2]
  instance_type = "t2.micro"
  ssh_username = "ec2-user"
  tags = {
    Name = local.image-name
    project = var.project
    env =  var.environment
  }
}

build {

  sources = ["source.amazon-ebs.region1","source.amazon-ebs.region2"]
  provisioner "shell" {
    script = "./userdata.sh"
    execute_command  = "sudo {{.Path}}"
  }

}
