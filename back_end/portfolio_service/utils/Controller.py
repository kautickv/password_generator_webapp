from BinanceExchangeManager import BinanceExchangeManager
from Indicators import Indicators

class Controller():

    _binanceExchange = None
    _indicators = None
    _interval = None
    _ticker = None
    _base_currency = None
    _candle_data = None

    def __init__(self, interval, ticker, base_currency):

        try:
            self._interval = interval
            self._ticker = ticker
            self._base_currency = base_currency
            self._binanceExchange = BinanceExchangeManager()
            self._candle_data = self._binanceExchange.getTimeSeriesDataForTicker(self._ticker,self._base_currency, self._interval)
            self._indicators = Indicators(self._candle_data,self._interval)

        except Exception as e:
            print(f"Count not create Controller Object: {e}")
            raise Exception (f"Could not create Controller Object: {e}")

    
    def getEMASignal():
        pass

