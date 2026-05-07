#!/usr/bin/env python

import json
import requests
import sys

def get_weather_data(city=""):
    try:
        # Use HTTP for reliability, add headers to mimic a browser request
        headers = {
            'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
        }
        response = requests.get(f"http://wttr.in/{city}?format=j1", headers=headers, timeout=15)
        response.raise_for_status()  # Raise an exception for bad status codes
        return response.json()
    except (requests.exceptions.RequestException, json.JSONDecodeError) as e:
        print(f"Error fetching weather: {e}", file=sys.stderr)
        return None

def main():
    weather_data = get_weather_data("Bangalore") # Change "London" to your city e.g. "New York" or "Tokyo"

    if weather_data:
        temp_c = weather_data['current_condition'][0]['temp_C']
        feels_like_c = weather_data['current_condition'][0]['FeelsLikeC']
        description = weather_data['current_condition'][0]['weatherDesc'][0]['value']

        # You can customize the output format here
        output = {
            "text": f"{temp_c}° ",
            "tooltip": f"Feels like: {feels_like_c}°C\n{description}",
            "class": "weather"
        }
        print(json.dumps(output))
    else:
        # Fallback output in case of an error
        output = {
            "text": "N/A",
            "tooltip": "Weather data unavailable",
            "class": "weather-error"
        }
        print(json.dumps(output))

if __name__ == "__main__":
    main()

