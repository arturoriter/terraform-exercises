resource "aws_instance" "app" {
  ami                  = "ami-1e339e71"
  instance_type        = "t2.micro"
  subnet_id            = "${aws_subnet.arturo_test.id}"
  key_name             = "jenkins"
  user_data            = "${data.template_file.cloud-config.rendered}"
  iam_instance_profile = "${aws_iam_instance_profile.test_profile.name}"
  tags {
    Name = "Arturo-Test"
  }
}

data "template_file" "cloud-config" {
  template = "${file("cloud-config.tpl")}"

  vars {
    hostname = "${var.role_ec2}"
    domain = "${var.private_element_in_domain}"
    bucket_name = "${var.bucket_name}"
    lambda_function_name = "${aws_lambda_function.exchange_lambda.function_name}"
    region = "${var.region}"
  }
}

output "private_ip" {
  value = "${aws_instance.app.private_ip}"
}
