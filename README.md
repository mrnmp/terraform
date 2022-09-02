# This is Terraform tutorial explains basic commands to follow for aws deployment 

# initialize  terraform

terraform init

# check what resource going to be deployed

terraform plan

# to create actual resource 

terraform apply

# to check terraform state

terraform state list

# check specific resource -name , terraform show -- output all resource 

terraform state show aws_vpc."name"


# delete
# auto-approve to avoid confirmation

terraform destroy -auto-approve  

# formate the tf files: 
terraform fmt

# delete stack
terraform destroy

