

import requests
from bs4 import BeautifulSoup

# Function to scrape content from the given URL
def scrape_content(url):
    try:
        # Send a GET request to the URL
        response = requests.get(url)
        
        # Check if the request was successful
        if response.status_code == 200:
            # Parse the HTML content using BeautifulSoup
            soup = BeautifulSoup(response.text, 'html.parser')
            
            # Find the main content container
            main_content = soup.find('div', class_='clr parentDOM')
            
            # Extract text from the main content
            content_text = main_content.get_text(separator='\n')
            
            return content_text
        else:
            print(f"Failed to fetch content. Status code: {response.status_code}")
            return None
    except Exception as e:
        print(f"An error occurred: {e}")
        return None

# URL of the website to scrape
url = "https://economictimes.indiatimes.com/markets/stocks/live-blog/bse-sensex-today-live-nifty-stock-market-updates-4-june-2024/liveblog/110684661.cms"

# Scrape content from the URL
scraped_content = scrape_content(url)

# Print the scraped content
if scraped_content:
    print(scraped_content)
else:
    print("Failed to scrape content from the provided URL.")
