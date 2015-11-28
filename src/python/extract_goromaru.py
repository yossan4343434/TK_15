# -*- coding: utf-8 -*-

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import sys
import os
import caffe
from caffe.io import blobproto_to_array
from caffe.proto import caffe_pb2
import glob
import csv
import cv2

ROOT = os.path.abspath(os.path.dirname(__file__))
MEAN_FILE = ROOT.replace("python", "yamashita/deeplearning/mean.binaryproto")
MODEL_FILE = ROOT.replace("python", "yamashita/deeplearning/caffemodel/set0/deploy.prototxt")
PRETRAINED = ROOT.replace("python", "yamashita/deeplearning/caffemodel/set0/snapshot/bestgoromaru.caffemodel")
IMAGE_DIR = ROOT.replace("src/python", "data/rugby/video/video_5minsep/")

cascade = cv2.CascadeClassifier("/usr//local/Cellar/opencv/2.4.11_1/share/OpenCV/haarcascades/haarcascade_frontalface_alt.xml")

if __name__ == '__main__':

    blob = caffe_pb2.BlobProto()
    with open(MEAN_FILE, 'rb') as fp:
        blob.ParseFromString(fp.read())
    numpy_mean = blobproto_to_array(blob)
    numpy_mean = numpy_mean.mean(0)

    # load classifier
    net = caffe.Classifier(MODEL_FILE, PRETRAINED,
                           mean=numpy_mean.mean(1).mean(1),
                           channel_swap=(2,1,0),
                           raw_scale=255,
                           image_dims=(100, 100))
    
    imglist = glob.glob(IMAGE_DIR+"*") 

    for photo in imglist:
        photo = IMAGE_DIR + "0386.png"
        # load image file to be predicted
        input_image = caffe.io.load_image(photo)
        img = cv2.imread(photo)

        face = cascade.detectMultiScale(img, 1.3, 3)
        
        if len(face) != 0:
            for (x, y, w, h) in face:
                tmp = img[y:y+h, x:x+w]
                cv2.imshow("test", tmp)
                cv2.waitKey(0)
                tmp = cv2.resize(tmp, (100, 100))
                input_image = tmp.astype(np.float32) / 255

                # predict
                prediction = net.predict([input_image])
                sorted_predict = sorted(range(len(prediction[0])),key=lambda x:prediction[0][x],reverse=True)
                    
                class_ = sorted_predict[0]
                if class_ == 0:
                    print photo

