#coding:utf-8
from scipy.io.wavfile import read
import matplotlib.pyplot as plt
import numpy as np
import math
import sys
from subprocess import call
import os


argvs = sys.argv
argc = len(argvs)
if (argc != 2):
  quit()

video_id = argvs[1]
file_dir = "./output"

command = "youtube-dl --extract-audio -o %s https://www.youtube.com/watch?v=%s" % (file_dir + ".m4a", video_id)
call(command.split(), shell=False)
print "done audio download"


bitrate = 8000
command = "ffmpeg -y -i %s -ac 1 -ar %i -acodec pcm_u8 %s" % (file_dir + ".m4a",bitrate, file_dir + ".wav")
call(command.split(), shell=False)
print "done audio conversion"


s_rate,input_data = read("output.wav")
audio = input_data
audio_length = len(audio) / bitrate
time_frame = 5


rms = []
minaudio =  zip(*[iter(audio)]*(bitrate*time_frame))


count = 0
for i in minaudio:
  array = np.array(i)
  norm =  np.linalg.norm(array*1.0)
  rms.append([count,norm])
  count += 1

rms.sort(key=lambda x:x[1])
pct = 1.0
for i in rms:
  i.append(pct / len(rms))
  pct += 1


data = []
for i in rms[-10:]:
  data.append(i)
data.sort(key=lambda x:x[0])


for i in data:
  print "https://www.youtube.com/watch?v=%s#t=%i" % (video_id, i[0]*time_frame-10)

os.remove("output.m4a")
os.remove("output.wav")

