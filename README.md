Terraform script which creates a complete environment Setup.

Manual steps,
1)create a VPC and specify it in vpc.tf file,
2)create a s3 bucket and update it in the bootstrap.tf,
3)internet gateway must be hosted to the created Vpc for public access,
4)check route table and subnet associations for public access.

************Will be completely automated in the future************
