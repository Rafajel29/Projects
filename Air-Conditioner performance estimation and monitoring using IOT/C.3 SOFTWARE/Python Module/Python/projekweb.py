# -*- coding: utf-8 -*-
"""
Created on Sat Oct 13 18:26:42 2018

@author: FJ-PC
"""

import datetime

from websocket import create_connection




while(1):
    ws = create_connection("wss://af1.loriot.io/app?token=vgEAIQAAAA1hZjEubG9yaW90Lmlv1t1Cv77m8k4w3fnB6ci9gw==")
    csv_out = open('Aircon.csv','a', newline='\n')
    print("Receiving...")
    result =  ws.recv()
    print("Received '%s'" % result)
    
    if (len(result) > 100):
        
        data = result.split(',')
        
        temp = data[0].split(':')
        cmd = temp[1].strip('"')
        
        temp = data[1].split(':')
        seqno = temp[1].strip('"')
        
        temp = data[2].split(':')
        EUI = temp[1].strip('"')
        
        temp = data[3].split(':')
        ts = temp[1].strip('"')
        
        temp = data[4].split(':')
        fcnt = temp[1].strip('"')
        
        temp = data[5].split(':')
        port = temp[1].strip('"')
        
        temp = data[6].split(':')
        freq = temp[1].strip('"')
        
        temp = data[7].split(':')
        rssi = temp[1].strip('"')
        
        temp = data[8].split(':')
        snr = temp[1].strip('"')
        
        temp = data[9].split(':')
        toa = temp[1].strip('"')
        
        temp = data[10].split(':')
        dr = temp[1].strip('"')
        
        temp = data[11].split(':')
        ack = temp[1].strip('"')
        
        temp = data[12].split(':')
        bat = temp[1].strip('"')
        
        temp = data[13].split(':')
        RecData = temp[1].strip('"')
        RecData = RecData.strip('}')
        RecData = RecData.strip('"')
        
        temp1 = RecData[0:2]
        temp2 = RecData[2:4]
        temp = temp2 + temp1
        Current = ((int(temp,16))/100)
        
        temp1 = RecData[4:6]
        temp2 = RecData[6:8]
        temp = temp2 + temp1
        CurrentHigh = ((int(temp,16))/100)
        
        temp1 = RecData[8:10]
        temp2 = RecData[10:12]
        temp = temp2 + temp1
        CurrentLow = ((int(temp,16))/100)
        
        temp1 = RecData[12:14]
        temp2 = RecData[14:16]
        temp = temp2 + temp1
        Temperature1 = ((int(temp,16))/100)
        
        temp1 = RecData[16:18]
        temp2 = RecData[18:20]
        temp = temp2 + temp1
        Temperature2 = ((int(temp,16))/100)
        
        temp1 = RecData[20:22]
        temp2 = RecData[22:24]
        temp = temp2 + temp1
        TemperatureEnvio = ((int(temp,16))/100)
        
        currentDT = datetime.datetime.now()
        
        DateTime = currentDT.strftime('%Y-%m-%d %H:%M:%S')
        
        row = EUI + ',' + DateTime + ',' + freq + ',' + dr + ',' + rssi + ',' + snr + ',' + seqno + ',' + port + ',' + RecData + ',' + str(Current) + ',' + str(CurrentHigh) + ',' + str(CurrentLow) + ',' + str(Temperature1) + ',' + str(Temperature2) + ',' + str(TemperatureEnvio) + '\n' 
        
        csv_out.write(row)
        print('Data Saved')
        
    csv_out.close()
    ws.close()
    
    
