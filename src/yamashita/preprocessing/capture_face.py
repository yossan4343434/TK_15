# -*- coding: utf-8 -*-

import os
import shutil
import cv2
import glob

ROOT = os.path.abspath(os.path.dirname(__file__))
SRCDIR = ROOT.replace("src/yamashita/preprocessing", "data/rugby/goromaru/")
TARDIR = ROOT.replace("src/yamashita/preprocessing", "data/rugby/pre_goromaru/")
NODIR = ROOT.replace("src/yamashita/preprocessing", "data/rugby/no_goromaru/")
cascade = cv2.CascadeClassifier("/usr//local/Cellar/opencv/2.4.11_1/share/OpenCV/haarcascades/haarcascade_frontalface_alt.xml")
cascade = cv2.CascadeClassifier("/usr//local/Cellar/opencv/2.4.11_1/share/OpenCV/haarcascades/haarcascade_mcs_nose.xml")
#cascade = cv2.CascadeClassifier("/usr//local/Cellar/opencv/2.4.11_1/share/OpenCV/haarcascades/haarcascade_frontalface_alt2.xml")
#cascade = cv2.CascadeClassifier("/usr//local/Cellar/opencv/2.4.11_1/share/OpenCV/haarcascades/haarcascade_frontalface_default.xml")
#cascade = cv2.CascadeClassifier("/usr//local/Cellar/opencv/2.4.11_1/share/OpenCV/haarcascades/haarcascade_mcs_mouth.xml")


def cap_face(paths):

    i = 0

    for path in paths:
        i += 1
        img = cv2.imread(path)

        #gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        face = cascade.detectMultiScale(img, 1.3, 5)

        r_name = TARDIR + "goromaru_" + str(i) 
        
        if len(face) != 0:
            j = 0
            for (x, y, w, h) in face:
                j += 1
                name = r_name + "_" + str(j) + ".jpg" 
                tmp = img[y:y+h, x:x+w]
                tmp = cv2.resize(tmp, (227, 227))
                cv2.imwrite(name, tmp)
        else:
            nogoro = NODIR + path.split("/")[-1]
            shutil.copy(path, nogoro)

        if i >= 10:
            quit()

def getlist():

    filelist = glob.glob(SRCDIR+"*")

    return filelist


if __name__ == '__main__':

    imgpaths = getlist()
    cap_face(imgpaths) 









