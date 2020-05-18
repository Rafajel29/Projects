# -*- coding: utf-8 -*-
"""
Created on Mon Mar  2 15:49:54 2020

@author: FJ-Legion
"""

import numpy as np
import pandas as pd
from os import listdir
import random        

def kmeans(data,K,iters):
    centers=data.iloc[random.sample(range(len(data)), K),:].to_numpy(float)
    data=(data.sample(frac=1)).to_numpy(float)
    
    for i in range(iters):
        print(i)
        ClassClus=np.zeros((len(data),6))
        ClassPoints=np.zeros((len(data)))
        
        for j in range(len(data[:,0])):
            D=np.argmin(np.sqrt(np.sum((centers - data[j,:])**2, axis=1)))
            ClassClus[D,:] = ClassClus[D,:] + data[j,:]
            ClassPoints[D] = ClassPoints[D] + 1
            
        for c in range(K):
            if (ClassPoints[c] == 0):
                centers[c]=centers[c]      
            else:
                centers[c]=ClassClus[c]/ClassPoints[c]
                 
    return centers

def knn(data,centers):
    data=data.to_numpy(float)
    Clasify = np.zeros((len(data)))
    for i in range(len(data)):
        condition = np.sqrt(np.sum((centers - data[i,:])**2, axis=1))
        Clasify[i]=np.argmin(condition)
         
    return Clasify

def load_data(Path):
    Gestures=['wave', 'inf', 'eight', 'circle', 'beat3', 'beat4']
    ColNames=['ts','Ax','Ay','Az','Wx','Wy','Wz']
    FileNames = listdir(Path)
    DATA=pd.DataFrame(columns=ColNames[1:])
    DATADict={}
    
    for i in FileNames:
        FilePath= Path+i
        df=pd.read_csv((FilePath),header=None,sep='\t', lineterminator='\n')
        condition=np.where([x in i for x in Gestures])[0][0]
        FileGesture=Gestures[condition]
        df=df.rename(columns=dict(enumerate(ColNames)))
        df=df.drop(['ts'],axis=1)
        
        DATA=DATA.append(df,ignore_index=True)
        if FileGesture in DATADict:
            DATADict[FileGesture]=DATADict[FileGesture].append(df,ignore_index=True)
        else:
            DATADict[FileGesture]=df
        
    return DATA,DATADict

def save_data(centers,SavePath):
    DataClasses = {}
    Gestures=['wave', 'inf', 'eight', 'circle', 'beat3', 'beat4']
    ColNames=['ts','Ax','Ay','Az','Wx','Wy','Wz']
    pd.DataFrame(centers,columns=ColNames[1:]).to_csv('train_centers.csv',index=False)
    for i in Gestures:
        KNNRes = knn(DATADict[i],centers)
        DataClasses[i]=pd.DataFrame(KNNRes,columns=['centers'])
        DataClasses[i].to_csv(SavePath+i+'.csv',index=False)
        
    return
        

SavePath = 'trainlabels/'
Path='train/'
K = 50
iters = 100

DATA,DATADict=load_data(Path)
centers=kmeans(DATA,K,iters)
save_data(centers,SavePath)
