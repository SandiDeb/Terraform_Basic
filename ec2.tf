provider "aws" {
	region = "ap-south-1"
}

resource "aws_instance" "nginx" {
	ami 	                 = "ami-5b673c34"
	instance_type 				 = "t2.micro"
	vpc_security_group_ids = ["sg-e8239d84"]
	key_name               = "${aws_key_pair.deep.key_name}"

	connection {
		user 	    = "ec2-user"
		private_key = "${file("dada.pem")}"
	}

	provisioner "file" {
		content = <<EOF
		<!DOCTYPE html>
		<html>
		<head>
		<Title> My Page </Title>
		</head>
		<body>
		<h1> My Page Changing the nginx default page </h1>
		</body>
		</html>

		EOF

		destination = "/home/ec2-user/index.html"
	}

	provisioner "remote-exec" {
		inline = [
		"sudo yum install wget -y",
		"sudo rpm -Uvh https://nginx.org/packages/rhel/7/x86_64/RPMS/nginx-1.8.1-1.el7.ngx.x86_64.rpm",
		"sudo mv /home/ec2-user/index.html /usr/share/nginx/html -f",
		"sudo chown -R root:root /usr/share/nginx/html/index.html",
		"sudo systemctl start nginx",
		]
	}
}

output "aws_instance_public_dns" {
	value = "${aws_instance.nginx.public_dns}"
}
