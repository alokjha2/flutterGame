

from flask import Flask, request, jsonify
import requests
from bs4 import BeautifulSoup

app = Flask(__name__)

def scrape_article(url):
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
    }
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        soup = BeautifulSoup(response.content, "html.parser")
        paragraphs = soup.find_all("p")
        if paragraphs:
            article_text = "\n".join([p.get_text() for p in paragraphs])
            return article_text
        else:
            return "Paragraphs not found."
    else:
        return f"Failed to fetch the webpage. Status code: {response.status_code}"

@app.route('/scrape', methods=['POST'])
def scrape():
    data = request.json
    url = data.get('url')
    if not url:
        return jsonify({"error": "URL is required"}), 400
    article_content = scrape_article(url)
    return jsonify({"content": article_content})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)

