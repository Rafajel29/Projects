#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pickle
from ast import literal_eval
import pandas as pd
import re


# In[2]:


#import dataset, change path to yours.
path = 'data/New_Data/'
recipes = pd.read_csv("smart_fridge_recipes.csv")
recipes = recipes.drop(columns=['nutrition', 'description','n_ingredients'])
csui = pickle.load( open("cuisines.pkl", "rb" ) )


# In[4]:


#use recomend_phase_1 get result
def recomend_phase_1(df,ig_have,cusine_type,diet_type,allergies):
    if diet_type:
        diet_type = pickle.load(open(diet_type+'.pkl', "rb" ))
        #apply allergy filter
        df = allergy_filter(df,allergies)
        #apply cusine filter
        cusinetype = csui[cusine_type]
        df = cuisine_filter(df,cusinetype)
        #apply diet preference
        df = diet_preference(df,diet_type)
        df = ingredientfilter(df,ig_have)
    else:
        df = allergy_filter(df,allergies)
        #apply cusine filter
        cusinetype = csui[cusine_type]
        df = cuisine_filter(df,cusinetype)
        #apply diet preference
        df = ingredientfilter(df,ig_have)
    return df
    
def cuisine_filter(df,cusine_type):
    return df[df['cuisine']==cusine_type]

#types = ['milk','eggs','fish','shellfish','nuts','peanuts','wheat','soybeans']

def allergy_filter(df,allergies):
    return df[df['ingredients'].str.contains('|'.join(allergies),  flags=re.IGNORECASE ,regex=True) == False]

#Four diet types: Vegan, Lacto Vegan, Lacto-ovo Vegan, Pescetarian
def diet_preference(df,diet_type):    
    temp = df['ingredients'].apply(lambda x:literal_eval(x))
    diff = temp.apply(lambda x:set(x) - set(diet_type))
    alert = temp.apply(lambda x:set(x).intersection(set(diet_type)))
    test = df[((alert.str.len() / (diff.str.len() + alert.str.len())) == 0)]
    return test
    
def ingredientfilter(df,ig_have):
    temp = df['ingredients'].apply(lambda x:literal_eval(x))
    diff = temp.apply(lambda x:set(x) - set(ig_have))
    used = temp.apply(lambda x:set(x).intersection(set(ig_have)))
    df['availability'] = used.str.len() / (diff.str.len() + used.str.len())
    df['diff'] = diff
    return df.sort_values('availability',ascending=False)


# In[5]:


#User 1 example
#input
cusine_type = 'japanese'
diet_type = 'vegan'
allergies = ['egg','milk']
ig_have = ['lettuce', 'tomatoes','apple','potatoes']


#output
recomend_phase_1(recipes,ig_have,cusine_type,diet_type,allergies).nlargest(10, 'availability')


# In[ ]:




