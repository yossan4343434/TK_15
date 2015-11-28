# -*- coding:utf-8 -*-

import os
import glob


ROOT = os.path.abspath(os.path.dirname(__file__))
TXTDIR = ROOT.replace("program", "txt/")
GORODIR = ROOT.replace("src/yamashita/deeplearning/program", "data/rugby/original/goromaru_trts/")
OTHERDIR = ROOT.replace("src/yamashita/deeplearning/program", "data/rugby/original/other_face/")


def getlist(DIR):

    filelist = glob.glob(DIR+"*")
    
    return filelist


def writelabels(f, num, filelist):

    for imgpath in filelist:
        img = imgpath.split("/")[-1]
        line = img + " " + num + "\n"
        f.write(line)

    return f


if __name__ == '__main__':

    filename = TXTDIR + "labels.txt"    
    f = open(filename, "w")
    for i in xrange(2):
        if i == 0:
            filelist = getlist(GORODIR)
            f = writelabels(f, str(i), filelist)
        else:
            filelist = getlist(OTHERDIR)
            f = writelabels(f, str(i), filelist)

    f.close()



