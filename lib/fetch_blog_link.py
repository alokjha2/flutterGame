import requests
from bs4 import BeautifulSoup
import urllib.parse

def fetch_google_search_results(query, num_results=10):
    search_url = "https://www.google.com/search"
    params = {
        "q": "mba",
        "num": num_results
    }
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
    }
    
    response = requests.get(search_url, params=params, headers=headers)
    response.raise_for_status()
    return response.text

def parse_search_results(html_content):
    soup = BeautifulSoup(html_content, "lxml")
    blog_links = []
    
    for item in soup.find_all('div', class_='g'):
        link_tag = item.find('a')
        if link_tag:
            url = link_tag['href']
            parsed_url = urllib.parse.urlparse(url)
            if 'url' in parsed_url.query:
                url = urllib.parse.parse_qs(parsed_url.query)['url'][0]
            blog_links.append(url)
    
    return blog_links

def get_mba_blog_links():
    query = "MBA blog"
    html_content = fetch_google_search_results(query)
    blog_links = parse_search_results(html_content)
    return blog_links

# Example usage
mba_blog_links = get_mba_blog_links()
for idx, link in enumerate(mba_blog_links, 1):
    print(f"{idx}. {link}")
