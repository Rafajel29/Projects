# -*- coding: utf-8 -*-
"""
Created on Thu Feb  6 04:53:40 2020

@author: FJ-Legion
"""

import pandas as pd
import math
import numpy as np
from numpy import linalg as LA
import matplotlib.pyplot as plt
import cv2
from skimage.measure import label, regionprops
import os


Barrel = pd.read_csv('data/Red_Barrel.csv')
NotBarrel = pd.read_csv('data/Not_Red_Barrel.csv')

raw_data = {'Lower_Bounds': [0,    1000, 2000, 2800, 3800, 5000, 6000, 9000,  13000, 19000, 50000,  150000],
            'Upper_Bounds': [1000, 2000, 2800, 3800, 5000, 6000, 9000, 13000, 19000, 50000, 150000, 1000000],
            'Distance':     [15,   14,   10,   9,    8,    7,    6,    5,     4,     3,     2,      1]}

SizeDict = pd.DataFrame(raw_data, columns = ['Lower_Bounds', 'Upper_Bounds', 'Distance'])

P_X = 1/(len(NotBarrel)+len(Barrel))
P_YB = len(Barrel)/(len(NotBarrel)+len(Barrel))
P_YNB = len(NotBarrel)/(len(NotBarrel)+len(Barrel))

Barrel_Mean = Barrel.mean()

BarM = np.matrix([Barrel_Mean[0], Barrel_Mean[1], Barrel_Mean[2]])
BarCov = Barrel.cov()
InvBarCov = LA.inv(BarCov)

NormBarCov = LA.norm(BarCov)
SqrNormBarCov = np.sqrt(NormBarCov)

NotBarrel_Mean = NotBarrel.mean()

NBarM = np.matrix([NotBarrel_Mean[0], NotBarrel_Mean[1], NotBarrel_Mean[2]])
NBarCov = NotBarrel.cov()
InvNotBarCov = LA.inv(NBarCov)

NormNotBarCov = LA.norm(NBarCov)
SqrNormNotBarCov = np.sqrt(NormNotBarCov)

const1 = 1/(2*math.pi*SqrNormBarCov)
const2 = 1/(2*math.pi*SqrNormNotBarCov)

folder = "Test_Set"
for filename in os.listdir(folder):
    
    img = cv2.imread(os.path.join(folder,filename))
    img = cv2.cvtColor(img,cv2.COLOR_BGR2RGB)    
    mask = np.zeros((900, 1200))

    for i in range (0, 900):
        for j in range (0, 1200):
            RGB = img[i,j,:]
            pixarr = np.matrix([RGB[0], RGB[1], RGB[2]])
        
            temp2 = np.array(pixarr - BarM)
            temp3 = np.transpose(temp2)
            temp5 = np.matmul(temp2, InvBarCov)
            temp6 = np.matmul(temp5, temp3)
            temp7 = math.exp(-0.5*temp6)
            
            MVG_Bar = const1*temp7
            
            temp2 = np.array(pixarr - NBarM)
            temp3 = np.transpose(temp2)
            temp5 = np.matmul(temp2, InvNotBarCov)
            temp6 = np.matmul(temp5, temp3)
            temp7 = math.exp(-0.5*temp6)
            
            MVG_Not_Bar = const2*temp7
            
            P_YX = (P_YB*MVG_Bar)/P_X
            P_YXN = (P_YNB*MVG_Not_Bar)/P_X
    
            if (P_YX > P_YXN):
                mask[i,j] = 1
    
    
    
    label_img = label(mask)
    regions = regionprops(label_img)
    fig, ax = plt.subplots()
    ax.imshow(img, cmap=plt.cm.gray)
    
    
    p = 0
    for i in range (0, len(regions)):
        if regions[p].bbox_area < 1000:
            del regions[p]
        else:
            p = p + 1
            
    regionsave = regions
            
    p = 0
    for i in range (0, len(regions)):
        corners = regions[p].bbox
        aspec = (corners[2] - corners[0])/(corners[3] - corners[1])
        if aspec > 2.5:
            del regions[p]
        else:
            p = p + 1
                            
        
    if (len(regions) < 1):
        regions = regionsave
        
    
    if (len(regions) > 0):
        p = 0
        k = 0
        for i in range (0, len(regions)):
            if (regions[i].bbox_area > k):
                p = i
                k = regions[i].bbox_area    
                
        BiggestBox = regions[p].bbox_area
        
        p = 0
        for i in range (0, len(regions)):
            if (BiggestBox * 0.35) > regions[p].bbox_area:
                del regions[p]
            else:
                p = p + 1

       
        
    if not regions:
        print('ImageName =', filename, ', No Barrel Detected')
    else:
        for BigProp in regions:
            
            y0, x0 = BigProp.centroid
            orientation = BigProp.orientation
            x1 = x0 + math.cos(orientation) * 0.5 * BigProp.minor_axis_length
            y1 = y0 - math.sin(orientation) * 0.5 * BigProp.minor_axis_length
            x2 = x0 - math.sin(orientation) * 0.5 * BigProp.major_axis_length
            y2 = y0 - math.cos(orientation) * 0.5 * BigProp.major_axis_length
            
            ax.plot(x0, y0, '.g', markersize=10)
            
            minr, minc, maxr, maxc = BigProp.bbox
            bx = (minc, maxc, maxc, minc, minc)
            by = (minr, minr, maxr, maxr, minr)
            ax.plot(bx, by, '-g', linewidth=2.5)
            
            Size = BigProp.bbox_area
            
            LB = SizeDict['Lower_Bounds'] < Size
            UB = SizeDict['Upper_Bounds'] > Size
               
            Distance = SizeDict['Distance'][LB & UB]
            
            Distance = Distance.reset_index()
            print('ImageName =', filename, 'CentroidX =', x0, ', CentroidY =', y0, ', Distance =', Distance['Distance'].iloc[0], 'm')
            
        ax.axis((0, 1200, 900, 0))
        plt.show()