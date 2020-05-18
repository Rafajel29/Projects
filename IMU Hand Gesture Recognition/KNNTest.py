# -*- coding: utf-8 -*-
"""
Created on Tue Mar  3 13:12:17 2020

@author: FJ-Legion
"""

import numpy as np
import pandas as pd
from os import listdir 
    
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
        condition=np.where([x in i for x in FileNames])[0][0]
        FileGesture=FileNames[condition]
        df=df.rename(columns=dict(enumerate(ColNames)))
        df=df.drop(['ts'],axis=1)
        
        DATA=DATA.append(df,ignore_index=True)
        if FileGesture in DATADict:
            DATADict[FileGesture]=DATADict[FileGesture].append(df,ignore_index=True)
        else:
            DATADict[FileGesture]=df
        
    return DATA,DATADict

def save_data(centers,SavePath,Path):
    DataClasses = {}
    FileNames = listdir(Path)
    ColNames=['ts','Ax','Ay','Az','Wx','Wy','Wz']
    pd.DataFrame(centers,columns=ColNames[1:]).to_csv('train_centers.csv',index=False)
    for i in FileNames:
        KNNRes = knn(DATADict[i],centers)
        DataClasses[i]=pd.DataFrame(KNNRes,columns=['centers'])
        DataClasses[i].to_csv(SavePath+i+'.csv',index=False)
        
    return
        
SavePath = 'testlabels/'
Path='test/'
LoadFile = 'train_centers.csv'

centers = np.genfromtxt(LoadFile, delimiter=',',skip_header = 1)
DATA,DATADict=load_data(Path)
save_data(centers,SavePath,Path)