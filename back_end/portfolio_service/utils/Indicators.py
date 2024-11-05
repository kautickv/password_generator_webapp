import statistics

class Indicators():

    crypto_data = None
    timeframe = None

    def __init__(self, data, timeframe):
        # Data is an array of time series candlestick data.
        # It contains:
        # t - end time of candlestick (unix timestap)
        # o - Open price
        # h - High price
        # l - Low price
        # c - Close price
        # v - Volume in crypto terms

        # timeframe indicates the length of each candlestick. E.g 5m,1D,etc..
        self.crypto_data = data
        self.timeframe = timeframe


    def calculate_ema(self, period):

        ##
        # PURPOSE: This function will compute the Exponential Moving Average based on the number of period specified
        # INPUT: The number of period
        # OUTPUT: An array with the exponential moving average
        
        try:
            closing_prices = [float(item['c']) for item in self.crypto_data]
    
            # Ensure we have enough data
            if len(closing_prices) < period:
                raise ValueError("Not enough data to calculate EMA")

            # Start with a simple moving average for the initial EMA value
            ema_values = [sum(closing_prices[:period]) / period]
            
            multiplier = 2 / (period + 1)

            # Calculate the EMA values
            for i in range(period, len(closing_prices)):
                ema_today = (closing_prices[i] - ema_values[-1]) * multiplier + ema_values[-1]
                ema_values.append(ema_today)
            
            # Extracting timestamps starting from the 'period' to match the EMA values.
            timestamps = [entry['t'] for entry in self.crypto_data][period-1:]
            
            # Pairing EMA values with their associated timestamps
            ema_with_time = [{'t': timestamp, 'ema': ema} for timestamp, ema in zip(timestamps, ema_values)]
            
            return ema_with_time
        except Exception as e:
            print(f"calculate_ema():{e}")
            raise Exception(f"Error: {e}")
        
    
    def calculate_rsi(self, period=14):
        
        try:
            if len(self.crypto_data) < period:
                raise ValueError("Not enough data to calculate RSI")

            closing_prices = [float(item['c']) for item in self.crypto_data]
            gains = []
            losses = []

            for i in range(1, len(closing_prices)):
                delta = closing_prices[i] - closing_prices[i-1]
                gains.append(max(delta, 0))
                losses.append(max(-delta, 0))

            avg_gain = sum(gains[:period]) / period
            avg_loss = sum(losses[:period]) / period

            rs = avg_gain / avg_loss if avg_loss != 0 else 0
            rsi = [100 - (100 / (1 + rs))]

            for i in range(period, len(closing_prices) - 1):
                avg_gain = (avg_gain * (period - 1) + gains[i]) / period
                avg_loss = (avg_loss * (period - 1) + losses[i]) / period
                rs = avg_gain / avg_loss if avg_loss != 0 else 0
                rsi.append(100 - (100 / (1 + rs)))

            timestamps = [entry['t'] for entry in self.crypto_data][period:]
            rsi_with_time = [{'t': timestamp, 'rsi': value} for timestamp, value in zip(timestamps, rsi)]
            
            return rsi_with_time
            
        except Exception as e:
            print(f"calculate_rsi(): {e}")
            raise Exception(f"Error: {e}")
        
    
    def calculate_volume_ema(self, period=14):

        try:
            volumes = [float(item['v']) for item in self.crypto_data]
    
            # Ensure we have enough data
            if len(volumes) < period:
                raise ValueError("Not enough data to calculate EMA for volume")

            # Start with a simple moving average for the initial EMA value
            ema_values = [sum(volumes[:period]) / period]
            
            multiplier = 2 / (period + 1)

            # Calculate the EMA values
            for i in range(period, len(volumes)):
                ema_today = (volumes[i] - ema_values[-1]) * multiplier + ema_values[-1]
                ema_values.append(ema_today)
            
            # Extracting timestamps starting from the 'period' to match the EMA values.
            timestamps = [entry['t'] for entry in self.crypto_data][period-1:]
            
            # Pairing EMA values with their associated timestamps
            volume_ema_with_time = [{'t': timestamp, 'volume_ema': ema} for timestamp, ema in zip(timestamps, ema_values)]
            
            return volume_ema_with_time

        except Exception as e:
            print(f"calculate_volume_ema(): {e}")
            raise Exception(f"Error: {e}")
        
    
    def calculate_bollinder_bands(self, period=20, factor=2):
        # Period: Is the period used to compute the SMA for the middle band
        # Factor: This value determines the width of the Bollinger Bands. The upper and lower bands are set a specified number of standard deviations away from the middle band. 
        try:
            closing_prices = [float(item['c']) for item in self.crypto_data]
    
            if len(closing_prices) < period:
                raise ValueError("Not enough data to calculate Bollinger Bands")

            upper_bands = []
            middle_bands = []
            lower_bands = []

            for i in range(period-1, len(closing_prices)):
                middle_band = sum(closing_prices[i-period+1:i+1]) / period
                std_dev = statistics.stdev(closing_prices[i-period+1:i+1])
                upper_band = middle_band + factor * std_dev
                lower_band = middle_band - factor * std_dev

                upper_bands.append(upper_band)
                middle_bands.append(middle_band)
                lower_bands.append(lower_band)

            timestamps = [entry['t'] for entry in self.crypto_data][period-1:]
            
            bollinger_data = [{
                't': timestamp,
                'upper_band': upper,
                'middle_band': middle,
                'lower_band': lower
            } for timestamp, upper, middle, lower in zip(timestamps, upper_bands, middle_bands, lower_bands)]
            
            return bollinger_data
        except Exception as e:
            print(f"calculate_bollinder_bands(): {e}")
            raise Exception(f"Error: {e}")
