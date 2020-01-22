##Randolph Bock
##Net1Bier Alarm
##AlarmMain v0.07
##Last update 25/10/2017

##External module imports
import RPi.GPIO as GPIO
import time
import os
import MatrixKeypad
from MatrixKeypad import *
import Network
from Network import *

##Pin code for Alarm:
pinCode = [1,3,7,9]

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

##Setup GPIO
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

print("Alarm v0.07")
print("Net 1 Bier")
print("Program Started, press CTRL+c to exit")
sendMessage()
try:
    while 1:
        if (state ==2):##Idle State
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
        if (state==3):##Armed State
            buzzerPwm.stop()
            if GPIO.input(pir):##Check for PIR trigger
                print("Triggered PIR")
                pirMessage()
                state=4
                orangePwm.stop()
                redPwm.start(50)
                GPIO.output(siren,GPIO.HIGH)
            if (GPIO.input(reed)!=1):##Check for DCS trigger
                redPwm.start(50)
                inputCode = getPin()
                if (inputCode==pinCode):
                    state = 2
                    orangePwm.stop()
                    redPwm.stop()
                    inputCode = [0,0,0,0]
                else:
                    print("Triggered REED")
                    doorMessage()
                    state=4
                    orangePwm.stop()
                    GPIO.output(siren,GPIO.HIGH)
            inputKey = getKey()
            if (inputKey!=''):##Exit Armed state to idle state when pin is entered
                inputCode = getPin()
                if(inputCode==pinCode):
                    state = 2
                    orangePwm.stop()
        if (state==4):##Triggered State
            inputKey = getKey()
            if (inputKey!=''):
                inputCode = getPin()
                if(inputCode==pinCode):
                    state = 2
                    orangePwm.stop()
                    redPwm.stop()
                    GPIO.output(siren,GPIO.LOW)
                    os.system('sudo reboot')
                
except KeyboardInterrupt:
    greenPwm.stop()
    GPIO.cleanup()
    print("Program Stopped")
except (RuntimeError, TypeError, NameError, ValueError):##Error State
    greenPwm.stop()
    GPIO.cleanup()
    os.system('sudo reboot')
