##Randolph Bock
##Net1Bier Alarm
##MatrixKeypad v0.03

##External module imports
import RPi.GPIO as GPIO
import time

##Variable Definitions
matrix = [[1,2,3],
          [4,5,6],
          [7,8,9],
          ['*',0,'#']]
row = [31,33,35,37]
col = [36,38,40]

##Setup for keypad
def keypadSetup():
    GPIO.setmode(GPIO.BOARD)
    for j in range(3):#Setup of colom pins
        GPIO.setup(col[j],GPIO.OUT)
        GPIO.output(col[j],1)
    for i in range(4):
        GPIO.setup(row[i],GPIO.IN,pull_up_down = GPIO.PUD_UP)

##Code to check for button press
def getKey():
    key=''
    for j in range(3):
        GPIO.output(col[j],0)
        for i in range(4):
            if (GPIO.input(row[i])==0):
                key = matrix[i][j]
                while(GPIO.input(row[i])==0):
                      pass
                time.sleep(0.1)
        GPIO.output(col[j],1)
    return key

##Code to get 4-digit pin code
def getPin():
    pin = [0,0,0,0]
    inputKey = getKey()
    t0 = int(time.time())
    t2 = 0
    while ((inputKey!='#')&(t2<25)):
        inputKey = getKey()
        if ((inputKey!='')&(inputKey!='#')&(inputKey!='*')):
            pin[0] =pin[1]
            pin[1] =pin[2]
            pin[2] =pin[3]
            pin[3] = inputKey
        t1=int(time.time())
        t2 = t1-t0
    return pin
        
def getPinIn(inputKey):
    pin = [0,0,0,inputKey]
    inputKey = getKey()
    t0 = int(time.time())
    t2 = 0
    while ((inputKey!='#')&(t2<25)):
        inputKey = getKey()
        if ((inputKey!='')&(inputKey!='#')&(inputKey!='*')):
            pin[0] =pin[1]
            pin[1] =pin[2]
            pin[2] =pin[3]
            pin[3] = inputKey
        t1=int(time.time())
        t2 = t1-t0
    return pin
