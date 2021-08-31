sections = [
    "Первые блюда",
    "Выпечка",
    "Горячие блюда",
    "Холодные закуски",
    "Горячие закуски",
    "Салаты",
    "Гарниры и соусы"
]

parts = [
    ['img src="', '" width'],
    ['<a href="/">', '</a></span>'],
    ['<span class="field-content">', '</span> </div>'],
    ['<div class="field-content">', '</div> </div>']
]

root = "https://hinkalicity.ru/"
download_folder = "../assets/images/"

from pathlib import Path

from os import path
import re

import requests

items = []

for section in sections:
    items.append({
        "name" : section,
        "items" : []
    })
    with open(path.join("menus", section), "r") as f:
        menu = f.readlines()

    for i in range(len(menu)//5):
        img_src = re.search(f"{parts[0][0]}(.*){parts[0][1]}", menu[5*i]).group(1)
        name = re.search(f"{parts[1][0]}(.*){parts[1][1]}", menu[5*i + 1]).group(1)
        price = re.search(f"{parts[3][0]}(.*){parts[3][1]}", menu[5*i + 3]).group(1)
        items[-1]["items"].append({
            "name" : name,
            "imageUrl" : str(Path("assets/images", Path(img_src).name)),
            "price" : int(price.split()[0]) 
        })

        url = root + img_src

        # r = requests.get(url, allow_redirects=True)
        # open(Path(download_folder, Path(img_src).name), "wb").write(r.content)

import json

with open("menu.json", "w") as f:
    json.dump(items, f, ensure_ascii=False)ешь