import json
from common.CommonUtility import CommonUtility
from handlers.handlePostPortfolio import handlePostPortfolio
from handlers.handleGetPortfolio import handleGetPortfolio
from handlers.handleAutoPortfolio import handleAutoPortfolio

def lambda_handler(event, context):

    print(event)
    try:
        #initialise CommonUtility Class
        common_utility = CommonUtility()
        if "httpMethod" in event:
            ## Check if user is authenticated
            code = common_utility.getAuthorizationCode(event)
            if code is None:
                return common_utility.buildResponse(401, "Unauthorized")
            else:
                ## VerifyAuthStatus will also return the user details associated with JWT Token
                user_details = common_utility.verifyAuthStatus(code)
                if user_details == None:
                    return common_utility.buildResponse(401, "Unauthorized")
        
            http_method = event['httpMethod']
            path = event['path']
            # Parse the JSON body
            body = event.get('body', '{}')
            body_params = json.loads(body) if body else {}

            if http_method == 'POST' and path =='/trading':
                
                return handlePostPortfolio(body_params)
            
            elif http_method == 'GET' and path =='/trading':

                query_params = event.get('queryStringParameters', {})
                return handleGetPortfolio(query_params)
            else:
                return common_utility.buildResponse(404, "Resource not found")
        
        # Check if triggered by EventBridge
        elif "source" in event and event["source"] == "aws.events":
            params = event.get('detail', {})
            action = params.get('action', None)
            if action == "auto":
                return handleAutoPortfolio(event)
            else:
                return "Unknown parameters"
    
    except Exception as e:
        print(f"An error occurred: ${e}")
        return common_utility.buildResponse(500, "Server error. Try again later")