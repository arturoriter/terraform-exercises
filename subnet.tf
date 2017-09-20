data "aws_vpc""selected" {
  tags {
    Name= "${var.element_vpc}"
  }
}

resource "aws_subnet" "arturo_test" {
  vpc_id = "${data.aws_vpc.selected.id}"
  cidr_block = "172.31.5.0/24"
  tags {
    Name = "Arturo-Test"
  }
}
