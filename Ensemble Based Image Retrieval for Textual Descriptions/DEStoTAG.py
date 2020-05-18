# -*- coding: utf-8 -*-
"""
Created on Mon Dec  9 21:56:30 2019

@author: FJ-TUF
"""

import pandas as pd
import sklearn
import nltk, string
import re

from nltk.corpus import stopwords

stop_words = set([word.translate(str.maketrans('', '', string.punctuation))
                  for word in stopwords.words('english')])

sanitized_tags = []
for i in range(0,10000):
    with open('cs5785-fall19-final/tags_train/%s.txt' % i) as f:
        descriptions = ' '.join(f.read().strip().split('\n'))
        descriptions = descriptions.replace(':',' ')
        all_words = descriptions.split(' ')
        all_words = ' '.join([a for a in all_words if a and a not in stop_words])
        sanitized_tags.append(all_words)
        
Tag = pd.DataFrame(sanitized_tags, columns=['sentence'])

Descrip = "tent forest next silver brown rv camp site trailer road two pictures tent bus two juxtaposed pictures show tent motor home tent photo bus"

wordList = re.sub("[^\w]", " ",  Descrip).split()

rankings = []

for j in range (0, 10000):
    count = 0
    for i in range (0, len(wordList)):
        if wordList[i] in sanitized_tags[j]:
            count = count + 1
    rankings.append(count)
    
Ranks = pd.DataFrame(rankings, columns=['Value'])
#Ranks.sort_values(by=['Value'], inplace=True, ascending=False)

T20 = Ranks.head(20).index.tolist()

print(T20)
    