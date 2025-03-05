import pandas as pd
import requests
from lxml import html

# URL of the speeches and remarks page
URL = "https://obamawhitehouse.archives.gov/briefing-room/speeches-and-remarks"

# Headers to mimic a browser visit
HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
}

def fetch_speeches(url)->dict[str, str]:
    response = requests.get(url, headers=HEADERS)
    if response.status_code != 200:
        print(f"Failed to fetch data, status code: {response.status_code}")
        return []
    
    tree = html.fromstring(response.content)
    
    # Base path containing articles
    articles_xpath = "//*[@id='content-start']/div[2]/div/div[1]/div[1]//h3/a"
    articles = tree.xpath(articles_xpath)
    
    speeches = []
    for article in articles:
        heading = article.text_content().strip()
        link = article.get("href")
        if link and not link.startswith("http"):
            link = f"https://obamawhitehouse.archives.gov{link}"
        speeches.append({"heading": heading, "link": link})
    
    return speeches


def fetch_speech(url:str)->dict:
    response = requests.get(url, headers=HEADERS)
    if response.status_code != 200:
        print(f"Failed to fetch data, status code: {response.status_code}")
        return ""

    tree = html.fromstring(response.content)

    # Fetch the content of the speech
    content_xpath = "//*[@id='content-start']/div[3]/div/div/div/p[3]"
    content_raw = tree.xpath(content_xpath)
    content =  content_raw[0].text_content().strip()

    # Fetch the date of the speech
    date_xpath = '//*[@id="press_article_date_created"]'
    date_raw = tree.xpath(date_xpath)
    date = date_raw[0].text_content().strip()

    heading_xpath='//*[@id="content-start"]/div[2]/h1'
    heading_raw = tree.xpath(heading_xpath)
    heading = heading_raw[0].text_content().strip()

    return {
        "heading": heading,
        "date": date,
        "content": content,
    }

def convert_speeches_to_df(speeches: list[dict])->pd.DataFrame:
  return pd.DataFrame(speeches)

def main():
    speeches = fetch_speeches(URL)
    speech_list = []
    for speech in speeches:
        speech_dict = fetch_speech(speech["link"])
        speech_list.append(speech_dict)

    df = convert_speeches_to_df(speech_list)
    df.to_csv("white_house_speeches.csv", index=False)

if __name__ == "__main__":
    main()
