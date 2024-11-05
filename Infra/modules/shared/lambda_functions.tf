# CREATE LAMBDA FUNCTION FOR AUTH SERVICE
##----------------------------------------------------------------------------------
# Zip the current backend python script
data "archive_file" "auth_lamda_function_zip" {
  type = "zip"
  #Do delete
  source_dir  = "${path.module}/../../../back_end/auth_service"
  output_path = "${path.module}/../../../auth_service.zip"
}

# Upload zip file to s3 bucket created earlier
resource "aws_s3_object" "auth_lamda_function_object" {
  bucket = module.lambda_zip_s3_bucket.bucket_id

  key    = "auth_service.zip"
  source = data.archive_file.auth_lamda_function_zip.output_path

  etag = filemd5(data.archive_file.auth_lamda_function_zip.output_path)
}

module "auth_lamda_function" {
  source = "../../modules/lambda/functions"

  function_name = "${var.app_name}_auth_service"
  s3_bucket_id = module.lambda_zip_s3_bucket.bucket_id
  s3_bucket_key = aws_s3_object.auth_lamda_function_object.key
  handler_name = "index.lambda_handler"
  source_code_hash = data.archive_file.auth_lamda_function_zip.output_base64sha256
  role_arn = aws_iam_role.auth_lambda_exec_role.arn
  layers_arn = [module.lambda_python_layer.layer_arn]
  environment_variables = {
    "MESSAGE"         = "Terraform sends its regards",
    "USER_TABLE_NAME" = module.auth_dynamodb_table.table_name
  }
  timeout = 15
  memory_size = 128
  # Conditionally pass VPC-related outputs
  private_subnets = var.use_vpc ? module.setup_vpc_network[0].private_subnets : []
  vpc_lambda_security_group = var.use_vpc ? module.setup_vpc_network[0].vpc_lambda_security_group : ""
  use_vpc = var.use_vpc
}
##----------------------------------------------------------------------------------
# CREATE LAMBDA FUNCTION FOR BOOKMARKMANAGER SERVICE
##----------------------------------------------------------------------------------
# Zip the current backend python script
data "archive_file" "bookmarkmanager_lamda_function_zip" {
  type = "zip"

  source_dir  = "${path.module}/../../../back_end/multitab_service"
  output_path = "${path.module}/../../../bookmarkmanager_service.zip"
}

# Upload zip file to s3 bucket created earlier
resource "aws_s3_object" "bookmarkmanager_lamda_function_object" {
  bucket = module.lambda_zip_s3_bucket.bucket_id

  key    = "bookmarkmanager_service.zip"
  source = data.archive_file.bookmarkmanager_lamda_function_zip.output_path

  etag = filemd5(data.archive_file.bookmarkmanager_lamda_function_zip.output_path)
}

module "bookmarkmanager_lamda_function" {
  source = "../../modules/lambda/functions"

  function_name = "${var.app_name}_bookmarkmanager_service"
  s3_bucket_id = module.lambda_zip_s3_bucket.bucket_id
  s3_bucket_key = aws_s3_object.bookmarkmanager_lamda_function_object.key
  handler_name = "index.lambda_handler"
  source_code_hash = data.archive_file.bookmarkmanager_lamda_function_zip.output_base64sha256
  role_arn = aws_iam_role.bookmarkmanager_lambda_exec_role.arn
  layers_arn = [module.lambda_python_layer.layer_arn]
  environment_variables = {
    "MESSAGE"         = "Terraform sends its regards",
    "BOOKMARKS_TABLE_NAME" = module.bookmarks_dynamodb_table.table_name,
    "AUTH_SERVICE_LAMBDA_NAME" = module.auth_lamda_function.function_name
  }
  timeout = 15
  memory_size = 128
  # Conditionally pass VPC-related outputs
  private_subnets = var.use_vpc ? module.setup_vpc_network[0].private_subnets : []
  vpc_lambda_security_group = var.use_vpc ? module.setup_vpc_network[0].vpc_lambda_security_group : ""
  use_vpc = var.use_vpc
}

##----------------------------------------------------------------------------------
# CREATE LAMBDA FUNCTION FOR HOME SERVICE
##----------------------------------------------------------------------------------
# Zip the current backend python script
data "archive_file" "home_lamda_function_zip" {
  type = "zip"

  source_dir  = "${path.module}/../../../back_end/home_service"
  output_path = "${path.module}/../../../home_service.zip"
}

# Upload zip file to s3 bucket created earlier
resource "aws_s3_object" "home_lamda_function_object" {
  bucket = module.lambda_zip_s3_bucket.bucket_id

  key    = "home_service.zip"
  source = data.archive_file.home_lamda_function_zip.output_path

  etag = filemd5(data.archive_file.home_lamda_function_zip.output_path)
}

module "home_lamda_function" {
  source = "../../modules/lambda/functions"

  function_name = "${var.app_name}_home_service"
  s3_bucket_id = module.lambda_zip_s3_bucket.bucket_id
  s3_bucket_key = aws_s3_object.home_lamda_function_object.key
  handler_name = "index.lambda_handler"
  source_code_hash = data.archive_file.home_lamda_function_zip.output_base64sha256
  role_arn = aws_iam_role.home_lambda_exec_role.arn
  layers_arn = [module.lambda_python_layer.layer_arn]
  environment_variables = {
    "MESSAGE"         = "Terraform sends its regards",
    "BOOKMARKS_TABLE_NAME" = module.bookmarks_dynamodb_table.table_name,
    "AUTH_SERVICE_LAMBDA_NAME" = module.auth_lamda_function.function_name
  }
  timeout = 15
  memory_size = 128
  # Conditionally pass VPC-related outputs
  private_subnets = var.use_vpc ? module.setup_vpc_network[0].private_subnets : []
  vpc_lambda_security_group = var.use_vpc ? module.setup_vpc_network[0].vpc_lambda_security_group : ""
  use_vpc = var.use_vpc
}

##----------------------------------------------------------------------------------
# CREATE LAMBDA FUNCTION FOR JSON_VIEWER SERVICE
##----------------------------------------------------------------------------------
# Zip the current backend python script
data "archive_file" "json_viewer_lamda_function_zip" {
  type = "zip"
  source_dir  = "${path.module}/../../../back_end/json_viewer_service"
  output_path = "${path.module}/../../../json_viewer_service.zip"
}

# Upload zip file to s3 bucket created earlier
resource "aws_s3_object" "json_viewer_lamda_function_object" {
  bucket = module.lambda_zip_s3_bucket.bucket_id

  key    = "json_viewer_service.zip"
  source = data.archive_file.json_viewer_lamda_function_zip.output_path

  etag = filemd5(data.archive_file.json_viewer_lamda_function_zip.output_path)
}

module "json_viewer_lamda_function" {
  source = "../../modules/lambda/functions"

  function_name = "${var.app_name}_json_viewer_service"
  s3_bucket_id = module.lambda_zip_s3_bucket.bucket_id
  s3_bucket_key = aws_s3_object.json_viewer_lamda_function_object.key
  handler_name = "index.lambda_handler"
  source_code_hash = data.archive_file.json_viewer_lamda_function_zip.output_base64sha256
  role_arn = aws_iam_role.json_viewer_lambda_exec_role.arn
  layers_arn = [module.lambda_python_layer.layer_arn]
  environment_variables = {
    "MESSAGE"         = "Terraform sends its regards",
    "AUTH_SERVICE_LAMBDA_NAME" = module.auth_lamda_function.function_name,
    "S3_BUCKET_NAME" = module.json_viewer_s3_bucket.bucket_name
  }
  timeout = 15
  memory_size = 128
  # Conditionally pass VPC-related outputs
  private_subnets = var.use_vpc ? module.setup_vpc_network[0].private_subnets : []
  vpc_lambda_security_group = var.use_vpc ? module.setup_vpc_network[0].vpc_lambda_security_group : ""
  use_vpc = var.use_vpc
}

##----------------------------------------------------------------------------------
# CREATE LAMBDA FUNCTION FOR PORTFOLIO SERVICE
##----------------------------------------------------------------------------------
# Zip the current backend python script
data "archive_file" "portfolio_lamda_function_zip" {
  type = "zip"
  source_dir  = "${path.module}/../../../back_end/portfolio_service"
  output_path = "${path.module}/../../../portfolio_service.zip"
}

# Upload zip file to s3 bucket created earlier
resource "aws_s3_object" "portfolio_lamda_function_object" {
  bucket = module.lambda_zip_s3_bucket.bucket_id

  key    = "portfolio_service.zip"
  source = data.archive_file.portfolio_lamda_function_zip.output_path

  etag = filemd5(data.archive_file.portfolio_lamda_function_zip.output_path)
}

module "portfolio_lamda_function" {
  source = "../../modules/lambda/functions"

  function_name = "${var.app_name}_portfolio_service"
  s3_bucket_id = module.lambda_zip_s3_bucket.bucket_id
  s3_bucket_key = aws_s3_object.portfolio_lamda_function_object.key
  handler_name = "index.lambda_handler"
  source_code_hash = data.archive_file.portfolio_lamda_function_zip.output_base64sha256
  role_arn = aws_iam_role.portfolio_lambda_exec_role.arn
  layers_arn = [module.lambda_python_layer.layer_arn]
  environment_variables = {
    "MESSAGE"         = "Terraform sends its regards",
    "AUTH_SERVICE_LAMBDA_NAME" = module.auth_lamda_function.function_name,
    "CRYPTO_TABLE_NAME" = module.crypto_assets_dynamodb_table.table_name
  }
  timeout = 15
  memory_size = 128
  # Conditionally pass VPC-related outputs
  private_subnets = var.use_vpc ? module.setup_vpc_network[0].private_subnets : []
  vpc_lambda_security_group = var.use_vpc ? module.setup_vpc_network[0].vpc_lambda_security_group : ""
  use_vpc = var.use_vpc
}