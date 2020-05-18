# IMU Hand Gesture Recognition Project

Contents of submission (type of file) (description)
1. test (folder) (Place test data text files in folder)
2. testlabels (folder) (quintized test data used for predictions are placed in here by program)
3. ADic.pkl (Model data) (A matrix data used for predictions)
4. BDic.pkl (Model data) (B matrix data used for predictions)
5. PDic.pkl (Model data) (Pi vector data used for predictions)
6. train_centers (csv file) (KMeans centers found when running KMeans on training data)
7. KMeansTrain (Python program) (Program used to create centers given training data)
8. KNNTest (Python Program) (Program used to find closest centre to each data point given training data and Kmeans centres csv file)
9. BW (Python Program) (Program used to create Model data given labeled training data(not included))
10.PredictBW (Python Program) (Program used to predict what gesture a test data file is given model data and test data)
11. Predictions (text file) (Contains predictions of test data with prediction 1 being the best gueus)
12. ReadMe (text file) (This file comntains instructions on running program) 
 
Libraries required:
numpy
pandas
os
pickle
random

I wrote and tested the python code using the spyder code editor within Anaconda

Predictions of the test data set is incl

In order to test program on new test data place test data txt files in the test folder. Then run the KNNTest program. Lastly Run the PredictBW program it will print out the predictions with loglikelihood scores. Prediction 1 is the top prediction and best gueus.


In order to retrain the program place training data in a folder named train in the folder with the programs aswell as an empty folder named trainlabels. Then run the KMeansTrain Program followed by the KNNTest program but in the KNNTest program the line SavePath needs to be changed to 'trainlabels/' and the line Path needs to be changed to 'train/'. Now run the BW program to complete training of model. To now test data undo changes in KNNTest and run that program followed by PredictBW

