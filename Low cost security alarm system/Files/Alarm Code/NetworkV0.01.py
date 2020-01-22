##Randolph Bock
##Net1Bier Alarm
##Network v0.01

##External module imports
import socket

##Variable Definitions
UDP_IP = "192.168.0.104"
UDP_PORT = 7000
MESSAGE = "Sent from Python on Raspberry Pi Alarm"

##Bind UDP Socket
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) 

##Send Welcome message
def sendMessage():
    MESSAGE = "Alarm: Net 1 Bier"
    sock.sendto(MESSAGE, (UDP_IP, UDP_PORT))

def doorMessage():
    MESSAGE = "Triggered REED"
    sock.sendto(MESSAGE, (UDP_IP, UDP_PORT))

def pirMessage():
    MESSAGE = "Triggered PIR"
    sock.sendto(MESSAGE, (UDP_IP, UDP_PORT))
