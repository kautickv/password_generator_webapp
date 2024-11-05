from common.CommonUtility import CommonUtility
from utils.CryptoDotComExchangeManager import CryptoDotComExchangeManager

def handleGetPortfolio(event):
    
    try:
        # Initialize CommonUtility Class
        common_utility = CommonUtility()
        # Create Exchange manager class
        cryptoExchange = CryptoDotComExchangeManager()

        # Get current BTC price
        return cryptoExchange.getCrrentPriceForTicker("BTC", "USD")
    except Exception as e:
        print(f"handleGetTrading(): ${e}")
        return common_utility.buildResponse(500, "A server error occurred. Please try again later")