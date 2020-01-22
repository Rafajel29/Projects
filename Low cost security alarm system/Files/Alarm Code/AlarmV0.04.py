##Randolph Bock
##Net1Bier Alarm
##AlarmMain v0.04
##Last update 15/10/2017

##External module imports
import RPi.GPIO as GPIO
import time
import MatrixKeypad
from MatrixKeypad import *

##Pin Definitions
greenLed = 22
orangeLed = 16
redLed = 18
pir = 13
reed =15
buzzer = 7
siren = 29

##Variable Definitions
state = 1

##Setup
GPIO.setmode(GPIO.BOARD)
GPIO.setup(greenLed,GPIO.OUT)
GPIO.setup(orangeLed,GPIO.OUT)
GPIO.setup(redLed,GPIO.OUT)
GPIO.setup(buzzer,GPIO.OUT)
GPIO.setup(siren,GPIO.OUT)
GPIO.setup(pir,GPIO.IN)
GPIO.setup(reed,GPIO.IN)
GPIO.output(redLed,GPIO.LOW)
GPIO.output(orangeLed,GPIO.LOW)
greenPwm = GPIO.PWM(greenLed,0.5)
orangePwm = GPIO.PWM(orangeLed,1)
redPwm = GPIO.PWM(redLed,5)
buzzerPwm = GPIO.PWM(buzzer,20)
keypadSetup()

##Initial state for outputs
greenPwm.start(15)
state = 2
GPIO.output(siren,GPIO.LOW)

print("Alarm v0.04")
print("Net 1 Bier")
print("Program Started, press CTRL+c to exit")
try:
    while 1:
        if (state ==2):
            inputKey = getKey()
            if (inputKey!=''):
                print(inputKey)
                if(inputKey=='*'):
                    state=3
                    print("SYSTEM AMRING")
                    buzzerPwm.start(50)
                    time.sleep(5)
                    print("SYSTEM AMRED")
                    orangePwm.start(5)
        if (state==3):
            buzzerPwm.stop()
            if GPIO.input(pir):
                print("Triggered PIR")
                state=4
                orangePwm.stop()
                redPwm.start(50)
                GPIO.output(siren,GPIO.HIGH)
            if (GPIO.input(reed)!=1):
                print("Triggered REED")
                state=4
                orangePwm.stop()
                redPwm.start(50)
                GPIO.output(siren,GPIO.HIGH)
        if (state==4):
            inputKey = getKey()
            if (inputKey!=''):
                print(inputKey)
                if(inputKey=='*'):
                    state = 2
                    redPwm.stop()
                    GPIO.output(siren,GPIO.LOW)
                
except KeyboardInterrupt:
    greenPwm.stop()
    GPIO.cleanup()
    print("Program Stopped")
