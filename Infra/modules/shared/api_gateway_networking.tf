# Create a REST API gateway in AWS
resource "aws_api_gateway_rest_api" "root_api_gateway" {
  name        = "${var.app_name}_api_gateway"
  description = "REST API gateway for ${var.app_name} app."
}

## AUTH RESOURCE
##------------------------------------------------------------------------------------
# create a new resource called "auth" inside api gateway
module "auth_resource" {
  source = "../../modules/api_gateway/api_gateway_resource"
  parent_resource_id = aws_api_gateway_rest_api.root_api_gateway.root_resource_id
  path_part = "auth"
  rest_api_id = aws_api_gateway_rest_api.root_api_gateway.id
}

## CREDS RESOURCE
##------------------------------------------------------------------------------------
# Create a new resource called "creds" inside inside auth resource
module "creds_resource" {
  source = "../../modules/api_gateway/api_gateway_resource"
  parent_resource_id = module.auth_resource.resource_id
  path_part = "creds"
  rest_api_id = aws_api_gateway_rest_api.root_api_gateway.id
}

# Create a GET Creds method inside "creds" resource
module "get_creds_method" {
  source = "../../modules/api_gateway/api_gateway_method"
  rest_api_id = aws_api_gateway_rest_api.root_api_gateway.id
  authorization = "NONE"
  http_method = "GET"
  resource_id = module.creds_resource.resource_id
  resource_options_method = module.creds_resource.options_method_id
  resource_options_http_method = module.creds_resource.options_http_method
}

# Configure GET /auth/creds to invoke auth lambda
module "get_creds_lambda_integration" {
  source = "../../modules/api_gateway/method_lambda_integration"

  statement_id = "AllowGetCredsLambdaInvoke"
  function_name = module.auth_lamda_function.function_name
  source_arn = "${aws_api_gateway_rest_api.root_api_gateway.execution_arn}/*/${module.get_creds_method.http_method}/auth/creds"
  http_method = module.get_creds_method.http_method
  resource_id = module.creds_resource.resource_id
  rest_api_id = aws_api_gateway_rest_api.root_api_gateway.id
  lambda_invoke_arn = module.auth_lamda_function.invoke_arn
}

## VERIFY RESOURCE
##------------------------------------------------------------------------------------
# Create a new resource called "verify" inside inside auth resource
module "verify_resource" {
  source = "../../modules/api_gateway/api_gateway_resource"
  parent_resource_id = module.auth_resource.resource_id
  path_part = "verify"
  rest_api_id = aws_api_gateway_rest_api.root_api_gateway.id
}

# Create a POST method inside "verify" resource
module "post_verify_method" {
  source = "../../modules/api_gateway/api_gateway_method"
  rest_api_id = aws_api_gateway_rest_api.root_api_gateway.id
  authorization = "NONE"
  http_method = "POST"
  resource_id = module.verify_resource.resource_id
  resource_options_method = module.verify_resource.options_method_id
  resource_options_http_method = module.verify_resource.options_http_method
}

# Configure POST /auth/verify to invoke auth lambda
module "post_verify_lambda_integration" {
  source = "../../modules/api_gateway/method_lambda_integration"

  statement_id = "AllowPostVerifyLambdaInvoke"
  function_name = module.auth_lamda_function.function_name
  source_arn = "${aws_api_gateway_rest_api.root_api_gateway.execution_arn}/*/${module.post_verify_method.http_method}/auth/verify"
  http_method = module.post_verify_method.http_method
  resource_id = module.verify_resource.resource_id
  rest_api_id = aws_api_gateway_rest_api.root_api_gateway.id
  lambda_invoke_arn = module.auth_lamda_function.invoke_arn
}

## LOGIN RESOURCE
##------------------------------------------------------------------------------------
# Create a new resource called "login" inside inside auth resource
module "login_resource" {
  source = "../../modules/api_gateway/api_gateway_resource"
  parent_resource_id = module.auth_resource.resource_id
  path_part = "login"
  rest_api_id = aws_api_gateway_rest_api.root_api_gateway.id
}

# Create a POST method inside "login" resource
module "post_login_method" {
  source = "../../modules/api_gateway/api_gateway_method"
  rest_api_id = aws_api_gateway_rest_api.root_api_gateway.id
  authorization = "NONE"
  http_method = "POST"
  resource_id = module.login_resource.resource_id
  resource_options_method = module.login_resource.options_method_id
  resource_options_http_method = module.login_resource.options_http_method
}

# Configure POST /auth/login to invoke auth lambda
module "post_login_lambda_integration" {
  source = "../../modules/api_gateway/method_lambda_integration"

  statement_id = "AllowPostLoginLambdaInvoke"
  function_name = module.auth_lamda_function.function_name
  source_arn = "${aws_api_gateway_rest_api.root_api_gateway.execution_arn}/*/${module.post_login_method.http_method}/auth/login"
  http_method = module.post_login_method.http_method
  resource_id = module.login_resource.resource_id
  rest_api_id = aws_api_gateway_rest_api.root_api_gateway.id
  lambda_invoke_arn = module.auth_lamda_function.invoke_arn
}

## LOGOUT RESOURCE
##------------------------------------------------------------------------------------
# Create a new resource called "logout" inside inside auth resource
module "logout_resource" {
  source = "../../modules/api_gateway/api_gateway_resource"
  parent_resource_id = module.auth_resource.resource_id
  path_part = "logout"
  rest_api_id = aws_api_gateway_rest_api.root_api_gateway.id
}

# Create a POST method inside "logout" resource
module "post_logout_method" {
  source = "../../modules/api_gateway/api_gateway_method"
  rest_api_id = aws_api_gateway_rest_api.root_api_gateway.id
  authorization = "NONE"
  http_method = "POST"
  resource_id = module.logout_resource.resource_id
  resource_options_method = module.logout_resource.options_method_id
  resource_options_http_method = module.logout_resource.options_http_method
}

# Configure POST /auth/logout to invoke auth lambda
module "post_logout_lambda_integration" {
  source = "../../modules/api_gateway/method_lambda_integration"

  statement_id = "AllowPostLogoutLambdaInvoke"
  function_name = module.auth_lamda_function.function_name
  source_arn = "${aws_api_gateway_rest_api.root_api_gateway.execution_arn}/*/${module.post_logout_method.http_method}/auth/logout"
  http_method = module.post_logout_method.http_method
  resource_id = module.logout_resource.resource_id
  rest_api_id = aws_api_gateway_rest_api.root_api_gateway.id
  lambda_invoke_arn = module.auth_lamda_function.invoke_arn
}

## BOOKMARKMANAGER RESOURCE
##------------------------------------------------------------------------------------
# Create a new resource called "bookmarkmanager" in root resource
module "bookmarkmanager_resource" {
  source = "../../modules/api_gateway/api_gateway_resource"
  parent_resource_id = aws_api_gateway_rest_api.root_api_gateway.root_resource_id
  path_part = "bookmarkmanager"
  rest_api_id = aws_api_gateway_rest_api.root_api_gateway.id
}

# Create a POST method inside "bookmarkmanager" resource
module "post_bookmarkmanager_method" {
  source = "../../modules/api_gateway/api_gateway_method"
  rest_api_id = aws_api_gateway_rest_api.root_api_gateway.id
  authorization = "NONE"
  http_method = "POST"
  resource_id = module.bookmarkmanager_resource.resource_id
  resource_options_method = module.bookmarkmanager_resource.options_method_id
  resource_options_http_method = module.bookmarkmanager_resource.options_http_method
}

# Configure POST /bookmarkmanager to invoke auth lambda
module "post_bookmarkmanager_lambda_integration" {
  source = "../../modules/api_gateway/method_lambda_integration"

  statement_id = "AllowPostBookmarksManagerLambdaInvoke"
  function_name = module.bookmarkmanager_lamda_function.function_name
  source_arn = "${aws_api_gateway_rest_api.root_api_gateway.execution_arn}/*/${module.post_bookmarkmanager_method.http_method}/bookmarkmanager"
  http_method = module.post_bookmarkmanager_method.http_method
  resource_id = module.bookmarkmanager_resource.resource_id
  rest_api_id = aws_api_gateway_rest_api.root_api_gateway.id
  lambda_invoke_arn = module.bookmarkmanager_lamda_function.invoke_arn
}

# Create a GET method inside "bookmarkmanager" resource
module "get_bookmarkmanager_method" {
  source = "../../modules/api_gateway/api_gateway_method"
  rest_api_id = aws_api_gateway_rest_api.root_api_gateway.id
  authorization = "NONE"
  http_method = "GET"
  resource_id = module.bookmarkmanager_resource.resource_id
  resource_options_method = module.bookmarkmanager_resource.options_method_id
  resource_options_http_method = module.bookmarkmanager_resource.options_http_method
}

# Configure POST /bookmarkmanager to invoke auth lambda
module "get_bookmarkmanager_lambda_integration" {
  source = "../../modules/api_gateway/method_lambda_integration"

  statement_id = "AllowGetBookmarksManagerLambdaInvoke"
  function_name = module.bookmarkmanager_lamda_function.function_name
  source_arn = "${aws_api_gateway_rest_api.root_api_gateway.execution_arn}/*/${module.get_bookmarkmanager_method.http_method}/bookmarkmanager"
  http_method = module.get_bookmarkmanager_method.http_method
  resource_id = module.bookmarkmanager_resource.resource_id
  rest_api_id = aws_api_gateway_rest_api.root_api_gateway.id
  lambda_invoke_arn = module.bookmarkmanager_lamda_function.invoke_arn
}

## HOME RESOURCE
##------------------------------------------------------------------------------------
# Create a new resource called "home" in root resource
module "home_resource" {
  source = "../../modules/api_gateway/api_gateway_resource"
  parent_resource_id = aws_api_gateway_rest_api.root_api_gateway.root_resource_id
  path_part = "home"
  rest_api_id = aws_api_gateway_rest_api.root_api_gateway.id
}

# Create a GET method inside "home" resource
module "get_home_method" {
  source = "../../modules/api_gateway/api_gateway_method"
  rest_api_id = aws_api_gateway_rest_api.root_api_gateway.id
  authorization = "NONE"
  http_method = "GET"
  resource_id = module.home_resource.resource_id
  resource_options_method = module.home_resource.options_method_id
  resource_options_http_method = module.home_resource.options_http_method
}

# Configure POST /home to invoke auth lambda
module "get_home_lambda_integration" {
  source = "../../modules/api_gateway/method_lambda_integration"

  statement_id = "AllowGetHomeLambdaInvoke"
  function_name = module.home_lamda_function.function_name
  source_arn = "${aws_api_gateway_rest_api.root_api_gateway.execution_arn}/*/${module.get_home_method.http_method}/home"
  http_method = module.get_home_method.http_method
  resource_id = module.home_resource.resource_id
  rest_api_id = aws_api_gateway_rest_api.root_api_gateway.id
  lambda_invoke_arn = module.home_lamda_function.invoke_arn
}

## JSON_VIEWER RESOURCE
##------------------------------------------------------------------------------------
# Create a new resource called "json_viewer" in root resource
module "json_viewer_resource" {
  source = "../../modules/api_gateway/api_gateway_resource"
  parent_resource_id = aws_api_gateway_rest_api.root_api_gateway.root_resource_id
  path_part = "json_viewer"
  rest_api_id = aws_api_gateway_rest_api.root_api_gateway.id
}

## /JSON_VIEWER/PROJECTS RESOURCE
##------------------------------------------------------------------------------------
# Create a new resource called "projects" inside json_viewer resource
module "json_viewer_projects_resource" {
  source = "../../modules/api_gateway/api_gateway_resource"
  parent_resource_id = module.json_viewer_resource.resource_id
  path_part = "projects"
  rest_api_id = aws_api_gateway_rest_api.root_api_gateway.id
}

# Create a GET method inside "projects" resource
module "get_projects_method" {
  source = "../../modules/api_gateway/api_gateway_method"
  rest_api_id = aws_api_gateway_rest_api.root_api_gateway.id
  authorization = "NONE"
  http_method = "GET"
  resource_id = module.json_viewer_projects_resource.resource_id
  resource_options_method = module.json_viewer_projects_resource.options_method_id
  resource_options_http_method = module.json_viewer_projects_resource.options_http_method
}

# Configure GET /json_viwer/projects to invoke json_viewer lambda
module "get_json_viewer_projects_lambda_integration" {
  source = "../../modules/api_gateway/method_lambda_integration"

  statement_id = "AllowGetJsonViewerProjectsLambdaInvoke"
  function_name = module.json_viewer_lamda_function.function_name 
  source_arn = "${aws_api_gateway_rest_api.root_api_gateway.execution_arn}/*/${module.get_projects_method.http_method}/json_viewer/projects"
  http_method = module.get_projects_method.http_method
  resource_id = module.json_viewer_projects_resource.resource_id
  rest_api_id = aws_api_gateway_rest_api.root_api_gateway.id
  lambda_invoke_arn = module.json_viewer_lamda_function.invoke_arn  
}

# Create a POST method inside "projects" resource
module "post_projects_method" {
  source = "../../modules/api_gateway/api_gateway_method"
  rest_api_id = aws_api_gateway_rest_api.root_api_gateway.id
  authorization = "NONE"
  http_method = "POST"
  resource_id = module.json_viewer_projects_resource.resource_id
  resource_options_method = module.json_viewer_projects_resource.options_method_id
  resource_options_http_method = module.json_viewer_projects_resource.options_http_method
}

# Configure POST /json_viwer/projects to invoke json_viewer lambda
module "post_json_viewer_projects_lambda_integration" {
  source = "../../modules/api_gateway/method_lambda_integration"

  statement_id = "AllowPOSTJsonViewerProjectsLambdaInvoke"
  function_name = module.json_viewer_lamda_function.function_name 
  source_arn = "${aws_api_gateway_rest_api.root_api_gateway.execution_arn}/*/${module.post_projects_method.http_method}/json_viewer/projects"
  http_method = module.post_projects_method.http_method
  resource_id = module.json_viewer_projects_resource.resource_id
  rest_api_id = aws_api_gateway_rest_api.root_api_gateway.id
  lambda_invoke_arn = module.json_viewer_lamda_function.invoke_arn  
}

## /JSON_VIEWER/PROJECTS/JSON RESOURCE
##------------------------------------------------------------------------------------
# Create a new resource called "json" inside json_viewer/projects resource
module "json_viewer_projects_json_resource" {
  source = "../../modules/api_gateway/api_gateway_resource"
  parent_resource_id = module.json_viewer_projects_resource.resource_id
  path_part = "json"
  rest_api_id = aws_api_gateway_rest_api.root_api_gateway.id
}

# Create a POST method inside "/json_viewer/projects/json" resource
module "post_projects_json_method" {
  source = "../../modules/api_gateway/api_gateway_method"
  rest_api_id = aws_api_gateway_rest_api.root_api_gateway.id
  authorization = "NONE"
  http_method = "POST"
  resource_id = module.json_viewer_projects_json_resource.resource_id
  resource_options_method = module.json_viewer_projects_json_resource.options_method_id
  resource_options_http_method = module.json_viewer_projects_json_resource.options_http_method
}

# Configure POST /json_viwer/projects/json to invoke json_viewer lambda
module "post_json_viewer_projects_json_lambda_integration" {
  source = "../../modules/api_gateway/method_lambda_integration"

  statement_id = "AllowPOSTJsonViewerProjectsJsonLambdaInvoke"
  function_name = module.json_viewer_lamda_function.function_name 
  source_arn = "${aws_api_gateway_rest_api.root_api_gateway.execution_arn}/*/${module.post_projects_json_method.http_method}/json_viewer/projects/json"
  http_method = module.post_projects_json_method.http_method
  resource_id = module.json_viewer_projects_json_resource.resource_id
  rest_api_id = aws_api_gateway_rest_api.root_api_gateway.id
  lambda_invoke_arn = module.json_viewer_lamda_function.invoke_arn 
}

## PORTFOLIO RESOURCE
##------------------------------------------------------------------------------------
# Create a new resource called "portfolio" in root resource
module "portfolio_resource" {
  source = "../../modules/api_gateway/api_gateway_resource"
  parent_resource_id = aws_api_gateway_rest_api.root_api_gateway.root_resource_id
  path_part = "portfolio"
  rest_api_id = aws_api_gateway_rest_api.root_api_gateway.id
}

# Create a GET method inside "portfolio" resource
module "get_portfolio_method" {
  source = "../../modules/api_gateway/api_gateway_method"
  rest_api_id = aws_api_gateway_rest_api.root_api_gateway.id
  authorization = "NONE"
  http_method = "GET"
  resource_id = module.portfolio_resource.resource_id
  resource_options_method = module.portfolio_resource.options_method_id
  resource_options_http_method = module.portfolio_resource.options_http_method
}

# Configure GET /portfolio to invoke portfolio lambda
module "get_portfolio_lambda_integration" {
  source = "../../modules/api_gateway/method_lambda_integration"

  statement_id = "AllowGetportfolioLambdaInvoke"
  function_name = module.portfolio_lamda_function.function_name 
  source_arn = "${aws_api_gateway_rest_api.root_api_gateway.execution_arn}/*/${module.get_portfolio_method.http_method}/portfolio"
  http_method = module.get_portfolio_method.http_method
  resource_id = module.portfolio_resource.resource_id
  rest_api_id = aws_api_gateway_rest_api.root_api_gateway.id
  lambda_invoke_arn = module.portfolio_lamda_function.invoke_arn  
}

# Create a POST method inside "portfolio" resource
module "post_portfolio_method" {
  source = "../../modules/api_gateway/api_gateway_method"
  rest_api_id = aws_api_gateway_rest_api.root_api_gateway.id
  authorization = "NONE"
  http_method = "POST"
  resource_id = module.portfolio_resource.resource_id
  resource_options_method = module.portfolio_resource.options_method_id
  resource_options_http_method = module.portfolio_resource.options_http_method
}

# Configure POST /portfolio to invoke json_viewer lambda
module "post_portfolio_lambda_integration" {
  source = "../../modules/api_gateway/method_lambda_integration"

  statement_id = "AllowPOSTportfolioLambdaInvoke"
  function_name = module.portfolio_lamda_function.function_name 
  source_arn = "${aws_api_gateway_rest_api.root_api_gateway.execution_arn}/*/${module.post_portfolio_method.http_method}/portfolio"
  http_method = module.post_portfolio_method.http_method
  resource_id = module.portfolio_resource.resource_id
  rest_api_id = aws_api_gateway_rest_api.root_api_gateway.id
  lambda_invoke_arn = module.portfolio_lamda_function.invoke_arn 
}




## DEPLOY API GATEWAY
##------------------------------------------------------------------------------------
# Deploy the API gateway
resource "aws_api_gateway_deployment" "root_api_gateway_deployment" {
  rest_api_id = aws_api_gateway_rest_api.root_api_gateway.id

  triggers = {
    //Added this to trigger a re-deployment everytime terraform script runs.
    last_modified = timestamp()
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
      module.get_creds_lambda_integration,
      module.post_verify_lambda_integration,
      module.post_login_lambda_integration,
      module.post_logout_lambda_integration,
      module.post_bookmarkmanager_lambda_integration,
      module.get_bookmarkmanager_lambda_integration,
      module.get_home_lambda_integration,
      module.get_json_viewer_projects_lambda_integration,
      module.post_json_viewer_projects_lambda_integration,
      module.post_json_viewer_projects_json_lambda_integration,
      module.get_portfolio_lambda_integration,
      module.post_portfolio_lambda_integration
  ]
}

# Deploy in a staging environment called "dev"
resource "aws_api_gateway_stage" "root_api_gateway_stage" {
  deployment_id = aws_api_gateway_deployment.root_api_gateway_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.root_api_gateway.id
  stage_name    = "dev"
}
