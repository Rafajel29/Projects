# -*- coding: utf-8 -*-
"""
Created on Tue Mar  3 23:33:36 2020

@author: FJ-Legion
"""

import numpy as np
import pandas as pd
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

def E_Step(N,data,A,B,c,alpha,beta,T):  
    gamma=np.zeros((N,T))
    kci=np.zeros((N,T,N))
    for t in range(T-1):
        for i in range(N):
            gamma[i,t] = 0
            for j in range(N):
                kci[i,t,j] = alpha[i,t]*A[i,j]*B[j,data[t+1]]*beta[j,t+1]
                gamma[i,t] = gamma[i,t] + kci[i,t,j]
                
    gamma[:,T-1] = alpha[:,T-1]        
    
        
    return gamma,kci

def M_Step(N,data,A,B,c,M,alpha,beta,gamma,kci,prior,T):  
    
    ATemp=np.copy(A)
    BTemp=np.copy(B)    
    prior[:] = gamma[:,0]

    for i in range(N):
        denom = 0
        for t in range(T-1):
            denom = denom + gamma[i,t]
        for j in range(N):
            numer = 0
            for t in range(T-1):
                numer = numer + kci[i,t,j]
            ATemp[i,j] = numer/denom
            
    for i in range(N):
        denom = 0
        for t in range(T):
            denom = denom + gamma[i,t]
        for j in range(M):
            numer = 0
            for t in range(T):
                if(data[t] == j):
                    numer = numer + gamma[i,t]
            BTemp[i,j] = numer/denom
            
    return ATemp,BTemp,prior


def Baum_Welch(A,N,B,M,data,prior,T,tol):
    prev=0
    LogEr=10
    while (abs(LogEr-prev)>=tol):

        prev=LogEr
        alpha,beta,c = Forward_Backward_Calculations(N,data,prior,A,B,T)
        gamma,kci = E_Step(N,data,A,B,c,alpha,beta,T)
        A,B,prior = M_Step(N,data,A,B,c,M,alpha,beta,gamma,kci,prior,T)
        LogEr=-np.sum(np.log(c))                
        print(LogEr)
        
    print('Model trained')
    return A,B,prior


Gestures=['wave', 'inf', 'eight', 'circle', 'beat3', 'beat4']    
N=10
M=50
tol=1
B = np.zeros((N,M))
B[:,:] = 1/M
A = np.zeros((N,N))
A[:,:] = 1/N
prior= np.zeros((N))
prior[0]=1
AModels,BModels,PriorModels,DATA={},{},{},{}

for i in Gestures:
    DATA[i]=pd.read_csv('trainlabels/'+i+'.csv').to_numpy(int).flatten()

for i in Gestures:
    print('Train',i,'model')
    T=len(DATA[i])
    AModels[i],BModels[i],PriorModels[i]=Baum_Welch(A,N,B,M,DATA[i],prior,T,tol)

output = open('ADic.pkl', 'wb')
pickle.dump(AModels, output)
output.close()

output = open('BDic.pkl', 'wb')
pickle.dump(BModels, output)
output.close()

output = open('PDic.pkl', 'wb')
pickle.dump(PriorModels, output)
output.close()