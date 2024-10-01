resource "aws_instance" "test-server" {
  ami = " ami-0083e0c040551216d "
  instance_type = "t2.micro"
  key_name = "live"
  vpc_security_group_ids = ["sg-0624c6a8b6420566d"]
  connection {
     type = "ssh"
     user = "ubuntu"
     private_key = file("./live.pem")
     host = self.public_ip
     }
  provisioner "remote-exec" {
     inline = ["echo 'wait to start the instance' "]
  }
  tags = {
     Name = "test-server"
     }
  provisioner "local-exec" {
     command = "echo ${aws_instance.test-server.public_ip} > inventory"
     }
  provisioner "local-exec" {
     command = "ansible-playbook /var/lib/jenkins/workspace/Care-Health/terraform-files/ansibleplaybook.yml"
     }
  }
