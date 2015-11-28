# -*- coding: utf-8 -*- 

import os
import sys
import urllib2
import lxml.html
from bs4 import BeautifulSoup

ROOT = os.path.abspath(os.path.dirname(__file__))
IMGDIR = ROOT.replace("src/yamashita/scraping", "data/rugby/goromaru/")

def imgdownload(url):
    img = urllib2.urlopen(url)
    localname = IMGDIR + url.split("/")[-1]
    localfile = open(localname, "wb")
    localfile.write(img.read())
    img.close()
    localfile.close()


if __name__ == '__main__':

    url = "http://life-time-value.com/rugby/2015/09/23/post-88/" 

    html = urllib2.urlopen(url)
    soup = BeautifulSoup(html)

    i = 0
    imglist = []
    for item in soup.find_all("img"):
        if "src" in str(item):
            tar = str(item).split("alt=\"")[-1].split("\"")[0]
            imgurl = str(item).split("src=\"")[-1].split("\"")[0]
            imgname = imgurl.split("/")[-1]
            if not imgname in imglist:
                imglist.append(imgname)
                imgdownload(imgurl)            
