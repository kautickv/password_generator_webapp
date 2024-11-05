from common.CommonUtility import CommonUtility
from utils.CryptoDotComExchangeManager import CryptoDotComExchangeManager


def handleAutoPortfolio(event):
    try:
            # Initialize CommonUtility Class
            common_utility = CommonUtility()
            # Create Exchange manager class
            cryptoExchange = CryptoDotComExchangeManager()

            # Get All asset balance
            print(cryptoExchange.getCryptoComBalancesInUSD())
    except Exception as e:
        print(f"handleGetTrading(): ${e}")
        return common_utility.buildResponse(500, "(handleAutoTrading) A server error occurred. Please try again later")