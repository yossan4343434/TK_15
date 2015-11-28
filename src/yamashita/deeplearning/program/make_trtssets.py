# -*- coding:utf-8 -*-

import os
import random
import shutil

ROOT = os.path.abspath(os.path.dirname(__file__))
TXTDIR = ROOT.replace("program", "txt/")
GORODIR = ROOT.replace("src/yamashita/deeplearning/program", "data/rugby/original/goromaru_trts/")
OTHERDIR = ROOT.replace("src/yamashita/deeplearning/program", "data/rugby/original/other_face/")
TRTSDIR = ROOT.replace("src/yamashita/deeplearning/program", "data/rugby/datasets/")



def makelabeltxt(dataset, txtname, dirname):

    filename = TXTDIR + txtname
    f = open(filename, "w")
    for line in dataset:
        f.write(line)
        
        imgname = line.split(" ")[0]
        num = line.split(" ")[1]

        if int(num) == 0:
            DIR = GORODIR
        else:
            DIR = OTHERDIR

        src = DIR + imgname
        tar = TRTSDIR + dirname + "/" + imgname
        shutil.copy(src, tar)


if __name__ == '__main__':

    filename = TXTDIR + "labels.txt"
    f = open(filename, "r") 
    filelist = list(f)
    f.close()
    
    random.shuffle(filelist) 
    
    trainset = filelist[:8000]
    testset = filelist[8000:]

    makelabeltxt(trainset, "train.txt", "trainset")
    makelabeltxt(testset, "test.txt", "testset")




