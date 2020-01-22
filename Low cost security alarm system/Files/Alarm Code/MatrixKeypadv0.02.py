##Randolph Bock
##Net1Bier Alarm
##MatrixKeypad v0.02

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
