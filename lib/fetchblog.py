import requests

def search_medium(topic):
    # Construct the search query URL for Medium
    search_url = f"https://medium.com/search/posts?q={topic}"

    # Send a GET request to the search URL
    response = requests.get(search_url)
    
    # Check if the request was successful
    if response.status_code == 200:
        # Parse the JSON response
        search_results = response.json()

        # Extract URLs of relevant articles
        article_urls = [result['url'] for result in search_results['payload']['references']['Post'].values()]

        return article_urls
    else:
        print("Failed to fetch search results from Medium.")

# Example usage
topic = "caremate"
article_urls = search_medium(topic)
if article_urls:
    print(f"Found {len(article_urls)} articles related to '{topic}' on Medium:")
    for url in article_urls:
        print(url)
else:
    print(f"No articles found on Medium related to '{topic}'.")
