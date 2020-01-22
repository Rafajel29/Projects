##Randolph Bock
##Net1Bier Alarm
##Network v0.03

##External module imports
import socket
import time
import datetime
from socket import *

##Variable Definitions
TCP_IP = '192.168.0.104'
TCP_PORT = 7000
MESSAGE = "Sent from Raspberry Pi Alarm"
BUFFER_SIZE = 1024

##TCP Socket
tcpSock = socket(AF_INET, SOCK_STREAM)
tcpSock.connect((TCP_IP, TCP_PORT))
print("Running")
##Send message
def sendMessage():
    MESSAGE = "Alarm: Net 1 Bier"
    tcpSock.send(MESSAGE)
    data = tcpSock.recv(BUFFER_SIZE)

def doorMessage():##Message sent to server for DCS trigger
    MESSAGE = "1B#DCS#" + getDate()+"#1"
    tcpSock.send(MESSAGE)
    data = tcpSock.recv(BUFFER_SIZE)

def pirMessage():##Message sent to server for PIR trigger
    MESSAGE = "1B#PIR#" + getDate() +"#1"
    tcpSock.send(MESSAGE)
    data = tcpSock.recv(BUFFER_SIZE)

def getDate():##Get date and time to sent when triger has occured
    t=time.localtime()
    dateMessage = str(t[2])+"/"+str(t[1])+"/"+str(t[0])+"#"+str(t[3])+":"+str(t[4])
    return dateMessage

def networkCleanUp():##Cleans up all network connections
    tcpSock.close()
