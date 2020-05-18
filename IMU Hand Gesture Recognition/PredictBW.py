# -*- coding: utf-8 -*-
"""
Created on Wed Mar  4 11:31:04 2020

@author: FJ-Legion
"""
import numpy as np
import pandas as pd
from os import listdir
import pickle

def Forward_Backward_Calculations(N,data,prior,A,B,T):   
    alpha=np.zeros((N,T))
    beta=np.zeros((N,T))
    c=np.zeros(T)
    
    c[0] = 0
    for i in range(N):
        alpha[i,0] = prior[i]*B[i,data[0]]
        c[0] = c[0] + alpha[i,0] + 10**(-10)
        c[0] = 1/c[0]
        
    alpha[:,0] = c[0]*alpha[:,0]
        
    for t in range(1,T):
        c[t] = 0
        for i in range(N):
            alpha[i,t] = 0
            for j in range(N):
                alpha[i,t] = alpha[i,t] + alpha[j,t-1]*A[j,i]
            alpha[i,t] = alpha[i,t]*B[i,data[t]]
            c[t] = c[t] + alpha[i,t] + 10**(-10)
            
        c[t] = 1/c[t]
        alpha[:,t] = c[t]*alpha[:,t]
            
    beta[:,T-1] = c[T-1]
        
    for k in range(1,T):
        t = T-(k+1)
        for i in range (N):
            beta[i,t] = 0
            for j in range(N):
                beta[i,t] = beta[i,t] + A[i,j]*B[j,data[t+1]]*beta[j,t+1]
            beta[i,t] = c[t]*beta[i,t]
    
    return alpha,beta,c

Gestures=['wave', 'inf', 'eight', 'circle', 'beat3', 'beat4']
N=10
predict = np.array([0,0,0,0,0,0], dtype = np.float32)
LoadPath = 'testlabels/'
FileNames = listdir(LoadPath)

pkl_file = open('ADic.pkl', 'rb')
AModels = pickle.load(pkl_file)
pkl_file.close()

pkl_file = open('BDic.pkl', 'rb')
BModels = pickle.load(pkl_file)
pkl_file.close()

pkl_file = open('PDic.pkl', 'rb')
PriorModels = pickle.load(pkl_file)
pkl_file.close()

DATA = {}
for i in FileNames:
    DATA[i]=pd.read_csv(LoadPath+i).to_numpy(int).flatten()

for p in FileNames:
    i = 0
    print(p,' predict:')    
    T=len(DATA[p])
    for j in Gestures:
        a,b,c=Forward_Backward_Calculations(N,DATA[p],PriorModels[j],AModels[j],BModels[j],T)
        ll=-np.sum(np.log(c))
        predict[i] = ll
        i += 1
    
    prediction = np.argpartition(predict, -3)[-3:]
    prediction[np.argsort(predict[prediction])]
    pre3 = prediction[np.argsort(predict[prediction])][0]
    pre2 = prediction[np.argsort(predict[prediction])][1]
    pre1 = prediction[np.argsort(predict[prediction])][2]
    print('Prediction 1 : ',Gestures[pre1], ' loglikelihood Score: ', predict[pre1])
    print('Prediction 2 : ',Gestures[pre2], ' loglikelihood Score: ', predict[pre2])
    print('Prediction 3 : ',Gestures[pre3], ' loglikelihood Score: ', predict[pre3])