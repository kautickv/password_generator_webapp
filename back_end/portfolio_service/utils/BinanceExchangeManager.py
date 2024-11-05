import requests

class BinanceExchangeManager():

    rest_base_url = "https://api.binance.com/api/v3/"

    def __init__(self):
        pass


    def getCrrentPriceForTicker(self, ticker, base_currency):
        ##
        # PURPOSE: This function will return the current usd price for the crypto ticker symbol
        # INPUT: Ticker symbol as string. E.g BTC, ETH and base_currency
        # OUTPUT: A list of a couple of information for current ticker
        ##

        try:
            #send api call
            response = requests.get(f"{self.rest_base_url}ticker/price?symbol={ticker}{base_currency}")
            # View sample response here: https://binance-docs.github.io/apidocs/spot/en/#symbol-order-book-ticker
            if (response.status_code == 200):
                ticker_data = response.json()
                return ticker_data
            else:
                raise Exception("(Binance)Could not get ticker price")
        except Exception as e:
            print(f"getCurrentPriceForTicker(): {e}")
            raise Exception(f"(Binance)Could not get ticker price from Binance: {e}")
        
    
    def getTimeSeriesDataForTicker(self, ticker, base_currency, candleTimeFrame):
        ##  
        # PURPOSE: Get the candle stick open and closing price for the specified time frame
        # INPUT: Ticker symbol as string. E.g BTC, ETH compared to base_currency, and 
        #        candleTimeFrame, e.g 5m, 1h, 1D, 1M (Only specific timeframe works. Look up docs)
        # OUTPUT: A list of elements containing multiple info. Look up docs.
        # Docs: https://binance-docs.github.io/apidocs/spot/en/#kline-candlestick-data
        ##
        try:
            #send api call
            response = requests.get(f"{self.rest_base_url}klines?symbol={ticker}{base_currency}&interval={candleTimeFrame}")
            if (response.status_code == 200):
                ticker_data = response.json()
                ticker_data_list=[]
                # transforming data to be same format as crypto.com
                for candle in ticker_data:
                    ticker_data_list.append({
                        "t":candle[6], # open time for candle unix timestamp of candle
                        "o":candle[1], #  Open price
                        "h": candle[2], # high price
                        "l": candle[3], # Low price
                        "c": candle[4], # close price
                        "v": candle[5], # Volume
                        "n": candle[8], # Number of trades in interval.
                    })
                    
                return ticker_data_list
            else:
                raise Exception("(Crypto.com)Could not get ticker price")
        except Exception as e:
            print(f"getTimeSeriesDataForTicker(): ${e}")
            raise Exception(f"(Crypto.com)Could not get ticker candlestick for {ticker}")