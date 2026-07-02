# Bastion Host

resource "aws_instance" "bastion" {

  ami = var.ami_id

  key_name = var.key_name

  instance_type = var.instance_type

  subnet_id = aws_subnet.public.id

  vpc_security_group_ids = [
    aws_security_group.kafka_sg.id
  ]

  associate_public_ip_address = true

  tags = {
    Name = "Kafka-Bastion"
    Role = "bastion"
  }
}



# Kafka Broker 1

resource "aws_instance" "kafka1" {

  ami = var.ami_id

  instance_type = var.instance_type

  key_name = var.key_name

  subnet_id = aws_subnet.private_a.id

  vpc_security_group_ids = [
    aws_security_group.kafka_sg.id
  ]

  user_data = file("user-data.sh")

  tags = {
    Name = "Kafka-Broker-1"
    Role = "kafka"
  }
}




# Kafka Broker 2

resource "aws_instance" "kafka2" {

  ami = var.ami_id

  instance_type = var.instance_type

  key_name = var.key_name

  subnet_id = aws_subnet.private_b.id

  vpc_security_group_ids = [
    aws_security_group.kafka_sg.id
  ]

  user_data = file("user-data.sh")

  tags = {
    Name = "Kafka-Broker-2"
    Role = "kafka"
  }
}





# Kafka Broker 3

resource "aws_instance" "kafka3" {

  ami = var.ami_id

  instance_type = var.instance_type

  key_name = var.key_name

  subnet_id = aws_subnet.private_c.id

  vpc_security_group_ids = [
    aws_security_group.kafka_sg.id
  ]

  user_data = file("user-data.sh")

  tags = {
    Name = "Kafka-Broker-3"
    Role = "kafka"
  }
}


