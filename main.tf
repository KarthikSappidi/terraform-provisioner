resource "aws_key_pair" "mykey" {
    key_name = "karthik-terraform"
    public_key = file("/Users/karthiksappidi/karthik-terraform.pub")  
}

resource "aws_vpc" "myvpc" {
    cidr_block = "10.0.0.0/16"  
}

resource "aws_subnet" "mysubnet" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true  

}

resource "aws_internet_gateway" "myigw" {
    vpc_id = aws_vpc.myvpc.id  
}

resource "aws_route_table" "myrt" {
    vpc_id = aws_vpc.myvpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myigw.id
    }  
}

resource "aws_route_table_association" "myrta" {
    subnet_id = aws_subnet.mysubnet.id
    route_table_id = aws_route_table.myrt.id  
}

resource "aws_security_group" "mysg" {
    name = "skr"
    vpc_id = aws_vpc.myvpc.id

    ingress {
        description = "HTTP from VPC"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "skr-sg"
    }
}

resource "aws_instance" "myinstance" {
    ami = "ami-051f8a213df8bc089"
    instance_type = "t2.medium"
    key_name = aws_key_pair.mykey.key_name
    vpc_security_group_ids = [aws_security_group.mysg.id]
    subnet_id = aws_subnet.mysubnet.id

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = file("/Users/karthiksappidi/karthik-terraform")
      host = self.public_ip
    }

    # File Provisioner to copy a file from local to remote EC2 instance
    provisioner "file" {
        source = "app.py"
        destination = "/home/ec2-user/app.py"
    }

    provisioner "remote-exec" {
        inline = [ 
            "echo 'Hello form remote instance'",
            "sudo yum update -y", # Update package lists (for ubuntu)
            "sudo yum-get install -y python3-pip", # Package installation
            "sudo yum install -y python3-flask", # Installing flask
            "sudo python3 /home/ec2-user/app.py", # Run flask app in the background
         ]
      
    }
}