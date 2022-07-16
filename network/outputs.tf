output "vpc_id" {
    value = aws_vpc.myvpc.id
}

output "public_subnet-1_id" {
    value = aws_subnet.public-1.id
}

output "public_subnet-2_id" {
    value = aws_subnet.public-2.id
}

output "private_subnet-1_id" {
    value = aws_subnet.private-1.id
}

output "private_subnet-2_id" {
    value = aws_subnet.private-2.id
}

output "vpc_cidr" {
    value = aws_vpc.myvpc.cidr_block
}