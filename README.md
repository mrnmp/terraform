# initilize terraform

terraform init

# check what resoruce going to be deployed

terraform plan

# to create actuall resource 

terraform apply

# to check terraform state

terraform state list

# check specific resoruce-name , terraform show -- output all resouces

terraform state show aws_vpc."name"


# delete
# auto-approve to avoid confirmation

terraform destroy -auto-approve  

# formate the tf files: 
terraform fmt

# delete stack
terraform destroy

