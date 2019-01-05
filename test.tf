// shared/main.tf
/*
 * Create internet gateway for VPC
 */
resource "aws_internet_gateway" "internet_gateway" {
 vpc_id = "${aws_vpc.vpc.id}"
}

/*
 * Create NAT gateway and allocate Elastic IP for it
 */
resource "aws_eip" "gateway_eip" {}

resource "aws_nat_gateway" "nat_gateway" {
 allocation_id = "${aws_eip.gateway_eip.id}"
 subnet_id     = "${aws_subnet.public_subnet.0.id}"
 depends_on    = ["aws_internet_gateway.internet_gateway"]
}

/*
 * Routes for private subnets to use NAT gateway
 */
resource "aws_route_table" "nat_route_table" {
 vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route" "nat_route" {
 route_table_id         = "${aws_route_table.nat_route_table.id}"
 destination_cidr_block = "0.0.0.0/0"
 nat_gateway_id         = "${aws_nat_gateway.nat_gateway.id}"
}

resource "aws_route_table_association" "private_route" {
 count          = "${length(var.aws_zones)}"
 subnet_id      = "${element(aws_subnet.private_subnet.*.id, count.index)}"
 route_table_id = "${aws_route_table.nat_route_table.id}"
}

/*
 * Routes for public subnets to use internet gateway
 */
resource "aws_route_table" "igw_route_table" {
 vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route" "igw_route" {
 route_table_id         = "${aws_route_table.igw_route_table.id}"
 destination_cidr_block = "0.0.0.0/0"
 gateway_id             = "${aws_internet_gateway.internet_gateway.id}"
}

resource "aws_route_table_association" "public_route" {
 count          = "${length(var.aws_zones)}"
 subnet_id      = "${element(aws_subnet.public_subnet.*.id, count.index)}"
 route_table_id = "${aws_route_table.igw_route_table.id}"
}

/*
 * Create DB Subnet Group for private subnets
 */
resource "aws_db_subnet_group" "db_subnet_group" {
 name       = "db-subnet"
 subnet_ids = ["${aws_subnet.private_subnet.*.id}"]
}