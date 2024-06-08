import requests
from bs4 import BeautifulSoup

def scrape_article(url):
    # Define custom headers to mimic a browser request
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
    }

    # Send a GET request to the URL with custom headers
    response = requests.get(url, headers=headers)

    # Check if the request was successful (status code 200)
    if response.status_code == 200:
        # Parse the HTML content of the webpage
        soup = BeautifulSoup(response.content, "html.parser")

        # Find all paragraphs within the article
        paragraphs = soup.find_all("p")

        # Extract text from each paragraph
        if paragraphs:
            # Join text from all paragraphs
            article_text = "\n".join([p.get_text() for p in paragraphs])
            return article_text
        else:
            return "Paragraphs not found."
    else:
        return f"Failed to fetch the webpage. Status code: {response.status_code}"

# List of article URLs
article_urls = [
    # "https://medium.com/@peckishhuman/ai-doctor-167c1a098137",
    "https://medium.com/illumination/stock-market-basics-for-beginner-by-investtherapy-b3a5f5615115",
    "https://medium.com/coinmonks/the-elegance-of-the-nft-provenance-hash-solution-823b39f99473",
    "https://medium.com/perpetual-protocol/what-is-eip-4844-2debc9b1ebcb",
    # Add more URLs here
]

# Scrape content from each article
for url in article_urls:
    print(f"Scraping content from article: {url}")
    article_content = scrape_article(url)
    print("Article Content:")
    print(article_content)
    print("-------------------------------------")
