#coding: UTF8

import cv2
import shutil
import numpy as np
import math

"""
#modelist
slide_multi3
slide_multi5
blight
flip
contrast
saturation
hue
rotation
mono
"""

mode = "mono"
r_src = "/Users/Yamashita/Desktop/github_space/TK_15/data/rugby/original/preprocessed_goromaru/"
r_dst = "/Users/Yamashita/Desktop/github_space/TK_15/data/rugby/datasets/aug1/"


def multi_3(img, pix=3):

    col = 100
    row = 100
    cols = [0]*col
    white = [cols] * row
    white = [white] * 3
    white = np.asarray(white)
    white = white.astype(np.uint8)
    white = np.transpose(white, (1,2,0))
    
    tmp_s1 = img[0:100, pix:100]
    tmp_s2 = img[0:100, 0:100-pix]
    
    im_s1 = np.copy(white)
    im_s2 = np.copy(white)

    im_s1[0:100, 0:100-pix] = tmp_s1
    im_s2[0:100, pix:100] = tmp_s2

    return im_s1, im_s2


def multi_5(img, pix=1):
    
    col = 100
    row = 100
    cols = [0]*col
    white = [cols] * row
    white = [white] * 3
    white = np.asarray(white)
    white = white.astype(np.uint8)
    white = np.transpose(white, (1,2,0))
    
    tmp_s1 = img[0:100, pix:100]
    tmp_s2 = img[0:100, 0:100-pix]
    tmp_s3 = img[pix:100, 0:100]
    tmp_s4 = img[0:100-pix, 0:100]
    
    im_s1 = np.copy(white)
    im_s2 = np.copy(white)
    im_s3 = np.copy(white)
    im_s4 = np.copy(white)

    im_s1[0:100, 0:100-pix] = tmp_s1
    im_s2[0:100, pix:100] = tmp_s2
    im_s3[0:100-pix, 0:100] = tmp_s3
    im_s4[pix:100, 0:100] = tmp_s4

    return im_s1, im_s2, im_s3, im_s4
        

def rotation(img, angle=5.0):

    center = tuple(np.array([img.shape[1] * 0.5, img.shape[0] * 0.5]))
    size = tuple(np.array([img.shape[1], img.shape[0]]))
    scale = 1.0
    rotation_matrix = cv2.getRotationMatrix2D(center, angle, scale)
    img_rot = cv2.warpAffine(img, rotation_matrix, size, flags=cv2.INTER_CUBIC)

    return img_rot


def mono(img):

    img_gry = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    img_gry = cv2.cvtColor(img_gry, cv2.COLOR_GRAY2BGR)
    return img_gry

def saturation(img, multi=0.5):

    hsv_img = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
    hsv_img = np.transpose(hsv_img, (2,0,1))
    hsv_img[1] *= multi
    hsv_img = np.transpose(hsv_img, (1,2,0))
    sat_img = cv2.cvtColor(hsv_img, cv2.COLOR_HSV2BGR)

    return sat_img


def hue(img):

    hsv_img = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
    hsv_img = np.transpose(hsv_img, (2,0,1))
    hsv_img[0] *= 0.0
    hsv_img[0] += 60.0

    hsv_img = np.transpose(hsv_img, (1,2,0))
    hue_img = cv2.cvtColor(hsv_img, cv2.COLOR_HSV2BGR)

    return hue_img


def flip(img, mode="lr"):

    if mode == "lr":
        code = 1
    elif mode == "td":
        code = 0
    else:
        print "flipCode Error!"
        quit()

    img = cv2.flip(img, flipCode=code)

    return img


def contrast(image, a=7.0):
  lut = [ np.uint8(255.0 / (1 + math.exp(-a * (i - 128.) / 255.))) for i in range(256)]
  result_image = np.array( [ lut[value] for value in image.flat], dtype=np.uint8 )
  result_image = result_image.reshape(image.shape)

  return result_image


def blight_conv(img, gamma=3.0):

    look_up_table = np.ones((256, 1), dtype = 'uint8' ) * 0
    for i in range(256):
        look_up_table[i][0] = 255 * pow(float(i) / 255, 1.0 / gamma)

    img_gamma = cv2.LUT(img, look_up_table)

    return img_gamma


if __name__ == '__main__':

    filelist = glob.glob(r_src+"*")
    
    for photo in filelist:

        n1_photo = r_dst + jpg

        img = cv2.imread(photo)
        img = cv2.resize(img, (100, 100))
        cv2.imwrite(n1_photo, img)

        if mode == "slide_multi3":
          
            im_s1, im_s2 = multi_3(img)
            
            jpg_s1 = jpg.replace(".jpg", "_s1.jpg")
            jpg_s2 = jpg.replace(".jpg", "_s2.jpg")
            
            n_photo1 = r_dst + jpg_s1
            n_photo2 = r_dst + jpg_s2
            cv2.imwrite(n_photo1, im_s1)
            cv2.imwrite(n_photo2, im_s2)

        elif mode == "slide_multi5":
          
            im_s1, im_s2, im_s3, im_s4 = multi_5(img)
            
            jpg_s1 = jpg.replace(".jpg", "_s1.jpg")
            jpg_s2 = jpg.replace(".jpg", "_s2.jpg")
            jpg_s3 = jpg.replace(".jpg", "_s3.jpg")
            jpg_s4 = jpg.replace(".jpg", "_s4.jpg")
            
            n_photo1 = r_dst + jpg_s1
            n_photo2 = r_dst + jpg_s2
            n_photo3 = r_dst + jpg_s3
            n_photo4 = r_dst + jpg_s4
            cv2.imwrite(n_photo1, im_s1)
            cv2.imwrite(n_photo2, im_s2)
            cv2.imwrite(n_photo3, im_s3)
            cv2.imwrite(n_photo4, im_s4)

        elif mode == "blight":
            
            img = blight_conv(img)
            
            jpg2 = jpg.replace(".jpg", "_b.jpg")
            n2_photo = r_dst + jpg2
            cv2.imwrite(n2_photo, img)

        elif mode == "contrast":
            
            img = contrast(img)

            jpg2 = jpg.replace(".jpg", "_c.jpg")
            n2_photo = r_dst + jpg2
            cv2.imwrite(n2_photo, img)

        elif mode == "flip":

            img = flip(img)

            jpg2 = jpg.replace(".jpg", "_r.jpg")
            n2_photo = r_dst + jpg2
            cv2.imwrite(n2_photo, img)

        elif mode == "saturation":

            img = saturation(img)

            jpg2 = jpg.replace(".jpg", "_st.jpg")
            n2_photo = r_dst + jpg2
            cv2.imwrite(n2_photo, img)
    
        elif mode == "hue":

            img = hue(img)

            jpg2 = jpg.replace(".jpg", "_h.jpg")
            n2_photo = r_dst + jpg2
            cv2.imwrite(n2_photo, img)

        elif mode == "rotation":

            img = rotation(img)

            jpg2 = jpg.replace(".jpg", "_rot.jpg")
            n2_photo = r_dst + jpg2
            cv2.imwrite(n2_photo, img)

        elif mode == "mono":

            img = mono(img)

            jpg2 = jpg.replace(".jpg", "_m.jpg")
            n2_photo = r_dst + jpg2
            cv2.imwrite(n2_photo, img)
            


