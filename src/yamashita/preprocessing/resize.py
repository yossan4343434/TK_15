# -*- coding: utf-8 -*-

import cv2
import glob

SRC = "/Users/Yamashita/Desktop/github_space/TK_15/data/rugby/goromaru/byhand/"
TAR = "/Users/Yamashita/Desktop/github_space/TK_15/data/rugby/goromaru/pre_goromaru2/"

def resizepic():

    filelist = glob.glob(SRC+"*")
    for src in filelist:
        tar = TAR + src.split("/")[-1]

        img = cv2.imread(src)
        img = cv2.resize(img, (227, 227))
        
        cv2.imwrite(tar, img)


if __name__ == '__main__':

    resizepic()







