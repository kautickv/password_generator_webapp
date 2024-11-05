#-------------------------------------------------------------------------------------------
# Create database for multitab/bookmarks feature
module "bookmarks_dynamodb_table" {
  source      = "../../modules/dynamodb"
  name        = "${var.app_name}_bookmarks_table"
  hash_key    = "email"
  region = var.region
  attributes  = [
    { name = "email", type = "S" },
    { name = "config_json", type = "S" },
    { name = "last_modified", type = "S" }
  ]
  global_secondary_indexes = [
    { 
      name            = "ConfigJsonIndex"
      hash_key        = "config_json"
      projection_type = "ALL"
      write_capacity  = 1
      read_capacity   = 1
    },
    { 
      name            = "LastModified"
      hash_key        = "last_modified"
      projection_type = "ALL"
      write_capacity  = 1
      read_capacity   = 1
    }
  ]
}

#-------------------------------------------------------------------------------------------
# Create dynamoDb table for authentication service
#-------------------------------------------------------------------------------------------
# Create database for multitab feature
module "auth_dynamodb_table" {
  source      = "../../modules/dynamodb"
  name        = "${var.app_name}_authentication_table"
  hash_key    = "email"
  region = var.region
  attributes  = [
    { name = "email", type = "S" },
    { name = "first_name", type = "S" },
    { name = "last_name", type = "S" },
    { name = "jwt_token", type = "S" },
    { name = "access_token", type = "S" },
    { name = "refresh_token", type = "S" },
    { name = "last_logout", type = "S" },
    { name = "last_login", type = "S" },
    { name = "login_status", type = "N" }
  ]
  global_secondary_indexes = [
    { 
      name            = "FirstNameIndex"
      hash_key        = "first_name"
      projection_type = "ALL"
      write_capacity  = 1
      read_capacity   = 1
    },
    { 
      name            = "LastNameIndex"
      hash_key        = "last_name"
      projection_type = "ALL"
      write_capacity  = 1
      read_capacity   = 1
    },
    { 
      name            = "JwtTokenIndex"
      hash_key        = "jwt_token"
      projection_type = "ALL"
      write_capacity  = 1
      read_capacity   = 1
    },
    { 
      name            = "AccessTokenIndex"
      hash_key        = "access_token"
      projection_type = "ALL"
      write_capacity  = 1
      read_capacity   = 1
    },
    { 
      name            = "RefreshTokenIndex"
      hash_key        = "refresh_token"
      projection_type = "ALL"
      write_capacity  = 1
      read_capacity   = 1
    },
    { 
      name            = "LastLogoutIndex"
      hash_key        = "last_logout"
      projection_type = "ALL"
      write_capacity  = 1
      read_capacity   = 1
    },
    { 
      name            = "LastLoginIndex"
      hash_key        = "last_login"
      projection_type = "ALL"
      write_capacity  = 1
      read_capacity   = 1
    },
    { 
      name            = "LoginStatus"
      hash_key        = "login_status"
      projection_type = "ALL"
      write_capacity  = 1
      read_capacity   = 1
    }
  ]
}



#-------------------------------------------------------------------------------------------
# Create dynamoDb table for Crypto service
#-------------------------------------------------------------------------------------------

# Create DynamoDB table for crypto assets tracking with multiple GSIs
module "crypto_assets_dynamodb_table" {
  source      = "../../modules/dynamodb"
  name        = "${var.app_name}_crypto_assets_table"
  region      = var.region

  hash_key    = "Date"         # Primary partition key
  
  attributes  = [
    { name = "Date", type = "S" },                # Date of the record (ISO format recommended)
    { name = "Crypto_Code", type = "S" },         # Cryptocurrency code (e.g., BTC, ETH)
    { name = "USD_Price", type = "N" },           # USD price of the crypto at that time
    { name = "Balance", type = "N" },             # Quantity of the cryptocurrency
    { name = "USD_Value", type = "N" }            # Total USD value (Balance * USD_Price)
  ]

  # Define Global Secondary Indexes for each attribute
  global_secondary_indexes = [
    {
      name               = "CryptoCodeIndex"
      hash_key           = "Crypto_Code"          # GSI for Crypto_Code
      projection_type    = "ALL"                  # Include all attributes in the index
      read_capacity      = 1                     # Adjust as needed
      write_capacity     = 1
    },
    {
      name               = "DateIndex"
      hash_key           = "Date"                 # GSI for Date
      projection_type    = "ALL"
      read_capacity      = 1
      write_capacity     = 1
    },
    {
      name               = "USDPriceIndex"
      hash_key           = "USD_Price"            # GSI for USD_Price
      projection_type    = "ALL"
      read_capacity      = 1
      write_capacity     = 1
    },
    {
      name               = "BalanceIndex"
      hash_key           = "Balance"              # GSI for Balance
      projection_type    = "ALL"
      read_capacity      = 1
      write_capacity     = 1
    },
    {
      name               = "USDValueIndex"
      hash_key           = "USD_Value"            # GSI for USD_Value
      projection_type    = "ALL"
      read_capacity      = 1
      write_capacity     = 1
    }
  ]
}
