import boto3
import json
import requests
import hmac
import hashlib
import time


class CryptoDotComExchangeManager:
    
    api_access_key = None
    api_secret_key = None
    api_base_url = "https://api.crypto.com/v2/"

    def __init__(self):
        keys = self._get_api_keys()
        self.api_access_key = keys[0]
        self.api_secret_key = keys[1]

    def createOrder(self, ticker, base_currency, side, type, price, quantity=None, notional=None, cliend_oid=None, time_in_force=None, exec_inst=None, trigger_price=None):
        ##
        # PURPOSE: Create an order to BUY or SELL ticker coin compared to base currency
        # INPUT: Mandatory input are: ticker, base_currency, side (BUY or SELL)
        #        type: (LIMIT, MARKET, STOP_LOSS, STOP_LIMIT, TAKE_PROFIT, TAKE_PROFIT_LIMIT)
        # OUTPUT: A list of json elements containing order_id and client_oid
        # Docs: (Highly reccommended)https://exchange-docs.crypto.com/spot/index.html#private-create-order
        ##

        try:
            #construct params dict
            params = {k: v for k, v in locals().items() if v is not None and k != "self"}
            payload = {
                "id":11,
                "method":"private/get-account-summary",
                "api_key": self.api_access_key,
                "params": params,
                "nonce": int(time.time() * 1000),
            }

            # Add digital Signature
            payload['sig'] = self._generateSignedPayload(payload)

            #Send request
            response = requests.post(self.api_base_url + payload['method'], json=payload)

            if response.status_code == 200:
                print(f"Request success")
                ticker_data = response.json()
                if ticker_data["code"] == 0:
                    return ticker_data["result"]
                else:
                    raise Exception(f"Crypto.com returned: {response.text}")
            else:
                raise Exception(f"Could not create order. Error: {response.text}")
        except Exception as e:
            print(f"createOrder(): {e}")
            raise Exception (f"Could not create (Crypto.com)order for {ticker}.")


    def getCoinBalance(self, ticker):
        ##
        # PURPOSE: Get the coin balance in spot account. 
        # INPUT: Ticker symbol as string. E.g BTC, ETH
        # OUTPUT: A list of json elements containing multiple info about balance.
        #         If ticker is ALL, it will return the balances for all coins in the account
        # Docs: https://exchange-docs.crypto.com/spot/index.html#private-get-account-summary
        ##

        try:
            payload = {
                "id":11,
                "method":"private/get-account-summary",
                "api_key": self.api_access_key,
                "params":{
                    "currency":ticker
                },
                "nonce": int(time.time() * 1000),
            }
            if(ticker == "ALL"):
                payload["params"] = {}

            # Add digital Signature
            payload['sig'] = self._generateSignedPayload(payload)

            #Send request
            response = requests.post(self.api_base_url + payload['method'], json=payload)

            if response.status_code == 200:
                print(f"Request success")
                ticker_data = response.json()
                if ticker_data["code"] == 0:
                    return ticker_data["result"]
                else:
                    raise Exception(f"Crypto.com returned: {response.text}")
            else:
                raise Exception(f"(Crypto.com)Could not get account information. Error: {response.text}")
        except Exception as e:
            print(f"getCoinBalance(): {e}")
            raise Exception (f"(Crypto.com)Could not get coin balance for {ticker}.")
    
    def getTimeSeriesDataForTicker(self, ticker, base_currency, candleTimeFrame):
        ##  ---- NOT BEING USED AS DATA IS NOT RELIABLE. USE BINANCE API INSTEAD
        # PURPOSE: Get the candle stick open and closing price for the specified time frame
        # INPUT: Ticker symbol as string. E.g BTC, ETH compared to base_currency, and 
        #        candleTimeFrame, e.g 5m, 1h, 1D, 1M (Only specific timeframe works. Look up docs)
        # OUTPUT: A list of json elements containing multiple info. Look up docs.
        # Docs: https://exchange-docs.crypto.com/spot/index.html#public-get-candlestick
        ##
        try:
            #send api call
            response = requests.get(f"{self.api_base_url}public/get-candlestick?instrument_name={ticker}_{base_currency}&timeframe={candleTimeFrame}")
            if (response.status_code == 200):
                ticker_data = response.json()
                if ticker_data['code'] == 0:
                    return ticker_data['result']['data']
                else:
                    raise Exception(f"Crypto.com returned: {response.text}")
            else:
                raise Exception("(Crypto.com)Could not get ticker price")
        except Exception as e:
            print(f"getTimeSeriesDataForTicker(): ${e}")
            raise Exception(f"(Crypto.com)Could not get ticker candlestick for {ticker}")

    def getCrrentPriceForTicker(self, ticker, base_currency):
        ##--- NOT BEING USED AS DATA IS NOT RELIABLE. USE BINANCE API INSTEAD
        # PURPOSE: This function will return the current usd price for the crypto ticker symbol
        # INPUT: Ticker symbol as string. E.g BTC, ETH and base_currency
        # OUTPUT: A list of a couple of information for current ticker
        ##

        try:
            #send api call
            response = requests.get(f"{self.api_base_url}public/get-ticker?instrument_name={ticker}_{base_currency}")
            print(f"{self.api_base_url}public/get-ticker?instrument_name={ticker}_USD")
            # View sample response here: https://exchange-docs.crypto.com/spot/index.html#public-get-ticker
            if (response.status_code == 200):
                ticker_data = response.json()
                if ticker_data["code"] == 0:
                    return ticker_data['result']['data']
                else:
                    raise Exception(f"Crypto.com returned: {response.text}")
            else:
                raise Exception("(Crypto.com)Could not get ticker price")
        except Exception as e:
            print(f"getCurrentPriceForTicker(): {e}")
            raise Exception(f"(Crypto.com)Could not get ticker price: {e}")


    def getCryptoComBalancesInUSD(self, min_usd_value=0.1):
        ##
        # PURPOSE: Get the balance for all coins in the account, along with their USD equivalents,
        #          filtering out coins without USD prices or with values below a specified minimum.
        # INPUT: min_usd_value is the minimum USD value to include in balance. Defaults to USD $0.1.
        # OUTPUT: A list of dictionaries containing coins and their USD value if available.
        ##

        try:
            # Prepare the payload for retrieving balances
            payload = {
                "id": 11,
                "method": "private/get-account-summary",
                "api_key": self.api_access_key,
                "params": {},  # Empty params to get balances for all coins
                "nonce": int(time.time() * 1000),
            }

            # Add digital signature
            payload['sig'] = self._generateSignedPayload(payload)

            # Send request to get all balances
            response = requests.post(self.api_base_url + payload['method'], json=payload)

            if response.status_code == 200:
                print("Request success")
                balance_data = response.json()
                if balance_data["code"] != 0:
                    raise Exception(f"Crypto.com returned an error: {response.text}")

                # Initialize list to hold balances with USD values
                balances_in_usd = []

                # Process each balance entry
                for account in balance_data["result"]["accounts"]:
                    currency = account['currency']
                    balance = float(account['balance'])

                    # Skip if balance is zero
                    if balance == 0:
                        continue

                    # Get USD price for each currency
                    usd_price = self._getCurrentPriceInUSD(currency)

                    # Calculate USD value and filter by minimum value
                    if usd_price is not None:
                        balance_usd_value = balance * usd_price
                        if balance_usd_value >= min_usd_value:
                            balances_in_usd.append({
                                "currency": currency,
                                "balance": balance,
                                "usd_value": balance_usd_value
                            })

                return balances_in_usd

            else:
                raise Exception(f"(Crypto.com) Could not retrieve account balances. Error: {response.text}")
        
        except Exception as e:
            print(f"getCryptoComBalancesInUSD(): {e}")
            raise Exception(f"(Crypto.com) Could not retrieve balances with USD equivalents. {e}")

    
    def _getCurrentPriceInUSD(self, ticker):
        ##
        # PURPOSE: Helper function to get the USD price for a given ticker.
        # INPUT: Ticker symbol as a string, e.g., BTC, ETH.
        # OUTPUT: Current price in USD for the ticker.
        ##

        try:
            response = requests.get(f"{self.api_base_url}public/get-ticker?instrument_name={ticker}_USD")
                
            if response.status_code == 200:
                price_data = response.json()
                if price_data["code"] == 0:
                    return float(price_data['result']['data'][0]['a'])  # Best ask price in USD
                else:
                    print(f"(Crypto.com) Could not retrieve USD price for {ticker}")
                    return None
            else:
                print(f"(Crypto.com) Could not retrieve USD price for {ticker}")
                return None
            
        except Exception as e:
            print(f"_getCurrentPriceInUSD(): {e}")
            raise Exception(f"(Crypto.com) Could not get USD price for ticker {ticker}")


    def _generateSignedPayload(self, payload):
        ##
        # PURPOSE: Private methods needs a digital signature. This method will generate the 
        #          signed payload and return the signature.
        # INPUT: Takes in the payload object
        # OUTPUT: returns a signature of the payload
        ##

        param_str = ""
        if "params" in payload:
            param_str = self._params_to_str(payload['params'], 0)

        payload_str = payload['method'] + str(payload['id']) + payload['api_key'] + param_str + str(payload['nonce'])

        return hmac.new(
            bytes(str(self.api_secret_key), 'utf-8'),
            msg=bytes(payload_str, 'utf-8'),
            digestmod=hashlib.sha256
            ).hexdigest()
    

    def _params_to_str(self, obj, level):
        ##
        # PURPOSE: This function is used by _generateSignedPayload(). Converts all a dict to str
        # INPUT: Takes in the params dict in payload
        # OUTPUT: returns a a string representation
        ##
        MAX_LEVEL = 3
        if level >= MAX_LEVEL:
            return str(obj)

        return_str = ""
        for key in sorted(obj):
            return_str += key
            if obj[key] is None:
                return_str += 'null'
            elif isinstance(obj[key], list):
                for subObj in obj[key]:
                    return_str += self._params_to_str(subObj, ++level)
            else:
                return_str += str(obj[key])
        return return_str
    
    def _get_api_keys(self):
        ##
        # PURPOSE: This function will read the value of the access and secret from SSM parameter store
        # INPUT: none
        # OUTPUT: An array [access Key, secret Key]
        ##

        try:
            # Create a Boto3 client for SSM
            ssm_client = boto3.client('ssm')
            # Read configuration file
            with open('trading_config.json') as f:
                configs = json.load(f)
            # Retrieve the access key
            response = ssm_client.get_parameter(
                Name=configs['ssm_parameter_paths_crypto.com_keys']['access_key'],
                WithDecryption=True
            )
            # Extract access key
            access_key = response['Parameter']['Value']

            # retrive secret key
            response = ssm_client.get_parameter(
                Name=configs['ssm_parameter_paths_crypto.com_keys']['secret_key'],
                WithDecryption=True
            )
            # Extract Secret key
            secret_key = response['Parameter']['Value']

            return [access_key, secret_key]
        
        except Exception as e:
            print(f"Error in reading crypto.com api keys. Error: {str(e)}")
            raise Exception("Error: " + str(e))