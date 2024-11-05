# Create an IAM role to assign to auth lambda function
resource "aws_iam_role" "auth_lambda_exec_role" {
  name = "${var.app_name}-auth-lambda-function_exec"

  assume_role_policy = jsonencode({
   "Version" : "2012-10-17",
   "Statement" : [
     {
       "Effect" : "Allow",
       "Principal" : {
         "Service" : "lambda.amazonaws.com"
       },
       "Action" : "sts:AssumeRole"
     },
   ]
  })
}
# Attach basic execution policy to the above role
resource "aws_iam_role_policy_attachment" "auth_role_basic_exec_attachment" {
  role       = aws_iam_role.auth_lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
# Attach Auth DynamoDB access policy
resource "aws_iam_role_policy_attachment" "auth_dynamodb_policy_attachment" {
  role     = aws_iam_role.auth_lambda_exec_role.name
  policy_arn = aws_iam_policy.auth_dynamodb_policy.arn
}
# Attach SSM read access policy
resource "aws_iam_role_policy_attachment" "auth_role_ssm_policy_attachment" {
  role      = aws_iam_role.auth_lambda_exec_role.name
  policy_arn = aws_iam_policy.ssm_read_policy.arn
}
# Attach KMS decrypt access policy
resource "aws_iam_role_policy_attachment" "auth_role_kms_decrypt_policy_attachment" {
  role      = aws_iam_role.auth_lambda_exec_role.name
  policy_arn = aws_iam_policy.kms_decrypt_policy.arn
}

# Attach EC2 Network Interface Access Policy
resource "aws_iam_role_policy_attachment" "auth_ec2_network_interface_policy_attachment" {
  role      = aws_iam_role.auth_lambda_exec_role.name
  policy_arn = aws_iam_policy.ec2_network_interface_policy.arn
}

##--------------------------------------------------------------------------------------------------------------------------------
## CREATE A ROLE FOR BOOKMARKMANAGER LAMBDA FUNCTION
##--------------------------------------------------------------------------------------------------------------------------------
resource "aws_iam_role" "bookmarkmanager_lambda_exec_role" {
  name = "${var.app_name}-bookmarkmanager-lambda-function_exec"

  assume_role_policy = jsonencode({
   "Version" : "2012-10-17",
   "Statement" : [
     {
       "Effect" : "Allow",
       "Principal" : {
         "Service" : "lambda.amazonaws.com"
       },
       "Action" : "sts:AssumeRole"
     },
   ]
  })
}
# Attach basic execution policy to the above role
resource "aws_iam_role_policy_attachment" "bookmarkmanager_role_basic_exec_attachment" {
  role       = aws_iam_role.bookmarkmanager_lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
# Attach BookmarksManager DynamoDB access policy
resource "aws_iam_role_policy_attachment" "Bookmarkmanager_dynamodb_policy_attachment" {
  role      = aws_iam_role.bookmarkmanager_lambda_exec_role.name
  policy_arn = aws_iam_policy.bookmarkmanager_dynamodb_policy.arn
}
# Attach SSM read access policy
resource "aws_iam_role_policy_attachment" "bookmarkmanager_role_ssm_policy_attachment" {
  role      = aws_iam_role.bookmarkmanager_lambda_exec_role.name
  policy_arn = aws_iam_policy.ssm_read_policy.arn
}
# Attach KMS decrypt access policy
resource "aws_iam_role_policy_attachment" "bookmarkmanager_role_kms_decrypt_policy_attachment" {
  role      = aws_iam_role.bookmarkmanager_lambda_exec_role.name
  policy_arn = aws_iam_policy.kms_decrypt_policy.arn
}
# Attach Access to invoke Auth Lambda
resource "aws_iam_role_policy_attachment" "bookmarkmanager_invoke_auth_lambda_policy_attachment" {
  role      = aws_iam_role.bookmarkmanager_lambda_exec_role.name
  policy_arn = aws_iam_policy.invoke_auth_lambda_policy.arn
}
# Attach EC2 Network Interface Access Policy
resource "aws_iam_role_policy_attachment" "bookmarkmanager_ec2_network_interface_policy_attachment" {
  role      = aws_iam_role.bookmarkmanager_lambda_exec_role.name
  policy_arn = aws_iam_policy.ec2_network_interface_policy.arn
}

##--------------------------------------------------------------------------------------------------------------------------------
## CREATE A ROLE FOR HOME LAMBDA FUNCTION
##--------------------------------------------------------------------------------------------------------------------------------
resource "aws_iam_role" "home_lambda_exec_role" {
  name = "${var.app_name}-home-lambda-function_exec"

  assume_role_policy = jsonencode({
   "Version" : "2012-10-17",
   "Statement" : [
     {
       "Effect" : "Allow",
       "Principal" : {
         "Service" : "lambda.amazonaws.com"
       },
       "Action" : "sts:AssumeRole"
     },
   ]
  })
}
# Attach basic execution policy to the above role
resource "aws_iam_role_policy_attachment" "home_role_basic_exec_attachment" {
  role       = aws_iam_role.home_lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
# Attach SSM read access policy
resource "aws_iam_role_policy_attachment" "home_role_ssm_policy_attachment" {
  role      = aws_iam_role.home_lambda_exec_role.name
  policy_arn = aws_iam_policy.ssm_read_policy.arn
}
# Attach KMS decrypt access policy
resource "aws_iam_role_policy_attachment" "home_role_kms_decrypt_policy_attachment" {
  role      = aws_iam_role.home_lambda_exec_role.name
  policy_arn = aws_iam_policy.kms_decrypt_policy.arn
}
# Attach Access to invoke Auth Lambda
resource "aws_iam_role_policy_attachment" "home_invoke_auth_lambda_policy_attachment" {
  role      = aws_iam_role.home_lambda_exec_role.name
  policy_arn = aws_iam_policy.invoke_auth_lambda_policy.arn
}
# Attach EC2 Network Interface Access Policy
resource "aws_iam_role_policy_attachment" "home_ec2_network_interface_policy_attachment" {
  role      = aws_iam_role.home_lambda_exec_role.name
  policy_arn = aws_iam_policy.ec2_network_interface_policy.arn
}

##--------------------------------------------------------------------------------------------------------------------------------
## CREATE A ROLE FOR JSON_VIEWER LAMBDA FUNCTION
##--------------------------------------------------------------------------------------------------------------------------------
resource "aws_iam_role" "json_viewer_lambda_exec_role" {
  name = "${var.app_name}-json-viewer-lambda-function_exec"

  assume_role_policy = jsonencode({
   "Version" : "2012-10-17",
   "Statement" : [
     {
       "Effect" : "Allow",
       "Principal" : {
         "Service" : "lambda.amazonaws.com"
       },
       "Action" : "sts:AssumeRole"
     },
   ]
  })
}
# Attach basic execution policy to the above role
resource "aws_iam_role_policy_attachment" "json_viewer_role_basic_exec_attachment" {
  role       = aws_iam_role.json_viewer_lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
# Attach SSM read access policy
resource "aws_iam_role_policy_attachment" "json_viewer_role_ssm_policy_attachment" {
  role      = aws_iam_role.json_viewer_lambda_exec_role.name
  policy_arn = aws_iam_policy.ssm_read_policy.arn
}
# Attach KMS decrypt access policy
resource "aws_iam_role_policy_attachment" "json_viewer_role_kms_decrypt_policy_attachment" {
  role      = aws_iam_role.json_viewer_lambda_exec_role.name
  policy_arn = aws_iam_policy.kms_decrypt_policy.arn
}
# Attach Access to invoke Auth Lambda
resource "aws_iam_role_policy_attachment" "json_viewer_invoke_auth_lambda_policy_attachment" {
  role      = aws_iam_role.json_viewer_lambda_exec_role.name
  policy_arn = aws_iam_policy.invoke_auth_lambda_policy.arn
}
#Attach Read/Write access to json_viewer S3 Bucket
resource "aws_iam_role_policy_attachment" "json_viewer_s3_bucket_policy_attachment" {
  role      = aws_iam_role.json_viewer_lambda_exec_role.name
  policy_arn = aws_iam_policy.jsonviewer_s3_policy.arn
}
# Attach EC2 Network Interface Access Policy
resource "aws_iam_role_policy_attachment" "json_viewer_ec2_network_interface_policy_attachment" {
  role      = aws_iam_role.json_viewer_lambda_exec_role.name
  policy_arn = aws_iam_policy.ec2_network_interface_policy.arn
}

##--------------------------------------------------------------------------------------------------------------------------------
## CREATE A ROLE FOR PORTFOLIO LAMBDA FUNCTION
##--------------------------------------------------------------------------------------------------------------------------------
resource "aws_iam_role" "portfolio_lambda_exec_role" {
  name = "${var.app_name}-portfolio-lambda-function_exec"

  assume_role_policy = jsonencode({
   "Version" : "2012-10-17",
   "Statement" : [
     {
       "Effect" : "Allow",
       "Principal" : {
         "Service" : "lambda.amazonaws.com"
       },
       "Action" : "sts:AssumeRole"
     },
   ]
  })
}
# Attach basic execution policy to the above role
resource "aws_iam_role_policy_attachment" "portfolio_role_basic_exec_attachment" {
  role       = aws_iam_role.portfolio_lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
# Attach SSM read access policy
resource "aws_iam_role_policy_attachment" "portfolio_role_ssm_policy_attachment" {
  role      = aws_iam_role.portfolio_lambda_exec_role.name
  policy_arn = aws_iam_policy.ssm_read_policy.arn
}
# Attach KMS decrypt access policy
resource "aws_iam_role_policy_attachment" "portfolio_role_kms_decrypt_policy_attachment" {
  role      = aws_iam_role.portfolio_lambda_exec_role.name
  policy_arn = aws_iam_policy.kms_decrypt_policy.arn
}
# Attach Access to invoke Auth Lambda
resource "aws_iam_role_policy_attachment" "portfolio_invoke_auth_lambda_policy_attachment" {
  role      = aws_iam_role.portfolio_lambda_exec_role.name
  policy_arn = aws_iam_policy.invoke_auth_lambda_policy.arn
}
# Attach Crypto Asset DynamoDB read/write access policy
resource "aws_iam_role_policy_attachment" "portfolio_dynamodb_policy_attachment" {
  role      = aws_iam_role.portfolio_lambda_exec_role.name
  policy_arn = aws_iam_policy.crypto_assets_dynamodb_policy.arn
}
# Attach EC2 Network Interface Access Policy
resource "aws_iam_role_policy_attachment" "portfolio_ec2_network_interface_policy_attachment" {
  role      = aws_iam_role.portfolio_lambda_exec_role.name
  policy_arn = aws_iam_policy.ec2_network_interface_policy.arn
}

