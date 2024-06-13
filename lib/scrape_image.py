


import os
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin

# Function to download an image from a given URL
def download_image(img_url, save_path):
    try:
        img_data = requests.get(img_url).content
        with open(save_path, 'wb') as img_file:
            img_file.write(img_data)
        print(f"Successfully downloaded {img_url}")
    except Exception as e:
        print(f"Failed to download {img_url}. Error: {str(e)}")

# Function to scrape images from a given website URL
def scrape_images(url, download_folder):
    response = requests.get(url)
    soup = BeautifulSoup(response.text, 'lxml')
    
    # Ensure the download folder exists
    if not os.path.exists(download_folder):
        os.makedirs(download_folder)

    # Find all image tags
    img_tags = soup.find_all('img')
    
    for img_tag in img_tags:
        img_url = img_tag.get('src')
        
        # If the img_url is relative, convert it to an absolute URL
        img_url = urljoin(url, img_url)

        # Extract the image filename from the URL
        img_filename = os.path.basename(img_url)
        
        # Create the full path for saving the image
        save_path = os.path.join(download_folder, img_filename)
        
        # Download the image
        download_image(img_url, save_path)

# Example usage
website_url = ''
download_folder = 'downloaded_images'
scrape_images(website_url, download_folder)
