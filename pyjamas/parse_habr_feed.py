#!/usr/bin/env python3

import requests
import sys
import time
from bs4 import BeautifulSoup

base_url = "https://habr.com/ru/feed/page{}/"
headers = {"User-Agent": "Mozilla/5.0 (compatible; Python script)"}

output_file = sys.argv[1]

existing_links = set()
try:
    with open(output_file, "r", encoding="utf-8") as f:
        for line in f:
            start = line.find("(")
            end = line.find(")")
            if start != -1 and end != -1:
                link = line[start + 1 : end]
                existing_links.add(link)
except FileNotFoundError:
    pass

with open(output_file, "a", encoding="utf-8") as f:
    page = 1
    while True:
        url = base_url.format(page)
        response = requests.get(url, headers=headers)
        if response.status_code != 200:
            print(f"Страница {page} недоступна, завершение.")
            break

        soup = BeautifulSoup(response.text, "html.parser")
        articles = soup.find_all("article")
        if not articles:
            print(f"На странице {page} нет статей, завершение.")
            break

        new_links_found = False
        for article in articles:
            a_tag = article.find("a", class_="tm-title__link")
            if a_tag and "href" in a_tag.attrs:
                link = "https://habr.com" + a_tag["href"]
                if link not in existing_links:
                    title = a_tag.get_text(strip=True)
                    f.write(f"## [{title}]({link})\n\n")
                    existing_links.add(link)
                    new_links_found = True

        print(f"Страница {page} обработана.")
        if not new_links_found:
            print("Новых ссылок не найдено, завершение.")
            break

        page += 1
        time.sleep(2)
