# -*- coding: utf-8 -*-


import matplotlib
matplotlib.use("TkAgg")
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg, NavigationToolbar2TkAgg
from matplotlib.figure import Figure

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import math
import seaborn as sns
import tkinter as tk
from tkinter import ttk


df = pd.read_csv('Aircon.csv')

StatData = df.iloc[:,9:15]
#StatData = df.iloc[:,9:14]

#StatData = StatData.loc[~(StatData[' Enviormental Temperature'] > 100)]

StatData['Local time'] = pd.to_datetime(df['Local time'], format = '%Y-%m-%d %H:%M:%S')



NumEntries = len(StatData)


StatData['Delta Temperature'] = abs(StatData[' Temperature2'] - StatData[' Temperature1'])

StatData['COP Indicator'] = (15-StatData['Current']) * StatData['Delta Temperature']

StatData.loc[StatData['COP Indicator'] > 2, 'Aircon ON'] = 1
StatData.loc[StatData['COP Indicator'] < 2, 'Aircon ON'] = 0

StatData.loc[StatData['Current'] > 2, 'Aircon ON Times'] = 1
StatData.loc[StatData['Current'] < 2, 'Aircon ON Times'] = 0

AirconONDF = StatData.loc[(StatData['Aircon ON'] == 1)]

AirconONDF = AirconONDF.reset_index()
del AirconONDF['index']

AirconOFFDF = StatData.loc[(StatData['Aircon ON'] == 0)]

AirconOFFDF = AirconOFFDF.reset_index()
del AirconOFFDF['index']

ANData = AirconONDF.loc[~(AirconONDF['Delta Temperature'] > 6.5)]
ANData = ANData.loc[~(ANData['Delta Temperature'] < 4)]

ANData = ANData.reset_index()
del ANData['index']

DataAirconON =  StatData.loc[(StatData['Aircon ON Times'] == 1)]

DataAirconON = DataAirconON.reset_index()
del DataAirconON['index']

FilteredDataAirconON = DataAirconON.loc[~(DataAirconON['Delta Temperature'] > 6.5)]
FilteredDataAirconON = FilteredDataAirconON.loc[~(FilteredDataAirconON['Delta Temperature'] < 4)]

FilteredDataAirconON = FilteredDataAirconON.reset_index()
del FilteredDataAirconON['index']

ONlength = len(ANData)
i = 0
temp = 0
ErrorDeltaTemp = []
ErrorTimes = []
ErrorTimesString = []
endlistvalue = math.floor((ONlength-1)/10)

for x in range (0,endlistvalue):
    for y in range ((x*10),((x*10)+10)):
        temp = temp +  ANData.iloc[y,7]
    ErrorDeltaTemp.append((temp/10))
    if (ErrorDeltaTemp[x] > 5):
        tempdatestring1 = ANData.iloc[(y-10),6].strftime('%Y-%m-%d %H:%M:%S')
        tempdatestring2 = ANData.iloc[(y),6].strftime('%Y-%m-%d %H:%M:%S')
        ErrorTimes.append(ANData.iloc[(y),6])
        ErrorTimesString.append(tempdatestring1)
        #ErrorTimesString.append(tempdatestring2) # + ' - ' + tempdatestring2)
    temp = 0

AirconMel = DataAirconON.loc[~(DataAirconON['Delta Temperature'] > 6.5)]

#AirconMel = AirconONDF.loc[~(AirconONDF['Delta Temperature'] > 6.5)]

ONlength = len(DataAirconON)
i = 0
temp = 0
ErrorDeltaTempMel = []
ErrorTimesMel = []
ErrorTimesStringMel = []
endlistvalue = math.floor((ONlength-1)/10)

for x in range (0,endlistvalue):
    for y in range ((x*10),((x*10)+10)):
        temp = temp +  DataAirconON.iloc[y,0]
    ErrorDeltaTempMel.append((temp/10))
    if (ErrorDeltaTempMel[x] > 5):
        tempdatestringMel1 = DataAirconON.iloc[(y-10),6].strftime('%Y-%m-%d %H:%M:%S')
        tempdatestringMel2 = DataAirconON.iloc[(y),6].strftime('%Y-%m-%d %H:%M:%S')
        ErrorTimesMel.append(DataAirconON.iloc[(y),6])
        ErrorTimesStringMel.append(tempdatestringMel2)
        #ErrorTimesString.append(tempdatestring2) # + ' - ' + tempdatestring2)
    temp = 0


LARGE_FONT= ("Verdana", 28)


class mainprog(tk.Tk):

    def __init__(self, *args, **kwargs):
        
        tk.Tk.__init__(self, *args, **kwargs)

        #tk.Tk.iconbitmap(self, default="clienticon.ico")
        tk.Tk.wm_title(self, "IOT Aircon Data Analysis")
        
        topframe = tk.Frame(self)
        container = tk.Frame(self)
        topframe.pack(side='top')
        container.pack(side="bottom", fill="both", expand = True)
        container.grid_rowconfigure(0, weight=1)
        container.grid_columnconfigure(0, weight=1)

        self.frames = {}

        for F in (StartPage, PageOne, PageTwo, PageThree, PageFour, PageFive, PageSix, PageSeven, PageEight, PageNine):

            frame = F(container, self)

            self.frames[F] = frame

            frame.grid(row=0, column=0, sticky="nsew")

        self.show_frame(StartPage)
        

    def show_frame(self, cont):

        frame = self.frames[cont]
        frame.tkraise()
        
        
 

#def save():
#    TextBox.                
#    file = open('AirconLog.txt','w')
#    file.close()

       
class StartPage(tk.Frame):
    


    def __init__(self, parent, controller):
        tk.Frame.__init__(self,parent)
        label = tk.Label(self, text="IOT Aircon Data Analysis Program", font=LARGE_FONT)
        label.pack(pady=10,padx=10)
        

        button = ttk.Button(self, text="Aircon ON vs Time",
                            command=lambda: controller.show_frame(PageOne))
        button.pack(pady=10,padx=10,side = 'top', anchor='w')
        

        button2 = ttk.Button(self, text="Current vs Time",
                            command=lambda: controller.show_frame(PageTwo))
        button2.pack(pady=10,padx=10,side = 'top', anchor='w')

        button3 = ttk.Button(self, text="Delta Temperature vs Time",
                            command=lambda: controller.show_frame(PageThree))
        button3.pack(pady=10,padx=10,side = 'top', anchor='w')
        
        button4 = ttk.Button(self, text="Current vs Time filtered",
                            command=lambda: controller.show_frame(PageFour))
        button4.pack(pady=10,padx=10,side = 'top', anchor='w')
        
        button5 = ttk.Button(self, text="Delta Temperature vs Time filtered",
                            command=lambda: controller.show_frame(PageFive))
        button5.pack(pady=10,padx=10,side = 'top', anchor='w')

        button6 = ttk.Button(self, text="Current BoxPlot",
                            command=lambda: controller.show_frame(PageSix))
        button6.pack(pady=10,padx=10,side = 'top', anchor='w')
        
        button7 = ttk.Button(self, text="Delta Temperature BoxPlot",
                            command=lambda: controller.show_frame(PageSeven))
        button7.pack(pady=10,padx=10,side = 'top', anchor='w')

        button8 = ttk.Button(self, text="Error Times of Aircon Dirty Filter",
                            command=lambda: controller.show_frame(PageEight))
        button8.pack(pady=10,padx=10,side = 'top', anchor='w')

        button8 = ttk.Button(self, text="Error Times of Aircon no Cooling",
                            command=lambda: controller.show_frame(PageNine))
        button8.pack(pady=10,padx=10,side = 'top', anchor='w')
    
        

class PageOne(tk.Frame):

    def __init__(self, parent, controller):
        tk.Frame.__init__(self, parent)
        label = tk.Label(self, text="Aircon On vs time", font=LARGE_FONT)
        label.pack(pady=10,padx=10)

        button1 = ttk.Button(self, text="Back to Home",
                            command=lambda: controller.show_frame(StartPage))
        button1.pack()

        f = Figure(figsize=(5,5), dpi=100)
        a = f.add_subplot(111)
        a.plot_date(StatData['Local time'], StatData['Aircon ON Times'])
        a.set_xlabel("Time")
        a.set_ylabel("Aircon ON")
        a.set_title("Aircon On vs time")

        

        canvas = FigureCanvasTkAgg(f, self)
        canvas.show()
        canvas.get_tk_widget().pack(side=tk.BOTTOM, fill=tk.BOTH, expand=True)

        toolbar = NavigationToolbar2TkAgg(canvas, self)
        toolbar.update()
        canvas._tkcanvas.pack(side=tk.TOP, fill=tk.BOTH, expand=True)
        
        
        
class PageTwo(tk.Frame):

    def __init__(self, parent, controller):
        tk.Frame.__init__(self, parent)
        label = tk.Label(self, text="Current vs Time", font=LARGE_FONT)
        label.pack(pady=10,padx=10)

        button1 = ttk.Button(self, text="Back to Home",
                            command=lambda: controller.show_frame(StartPage))
        button1.pack()

        f = Figure(figsize=(5,5), dpi=100)
        a = f.add_subplot(111)
        a.plot_date(StatData['Local time'], StatData['Current'])
        a.set_xlabel("Time")
        a.set_ylabel("Current")
        a.set_title("Current vs Time")

        

        canvas = FigureCanvasTkAgg(f, self)
        canvas.show()
        canvas.get_tk_widget().pack(side=tk.BOTTOM, fill=tk.BOTH, expand=True)

        toolbar = NavigationToolbar2TkAgg(canvas, self)
        toolbar.update()
        canvas._tkcanvas.pack(side=tk.TOP, fill=tk.BOTH, expand=True)


class PageThree(tk.Frame):

    def __init__(self, parent, controller):
        tk.Frame.__init__(self, parent)
        label = tk.Label(self, text="Delta Temperature vs Time", font=LARGE_FONT)
        label.pack(pady=10,padx=10)

        button1 = ttk.Button(self, text="Back to Home",
                            command=lambda: controller.show_frame(StartPage))
        button1.pack()

        f = Figure(figsize=(5,5), dpi=100)
        a = f.add_subplot(111)
        a.plot_date(StatData['Local time'], StatData['Delta Temperature'])
        a.set_xlabel("Time")
        a.set_ylabel("Delta Temperature")
        a.set_title("Delta Temperature vs Time")

        

        canvas = FigureCanvasTkAgg(f, self)
        canvas.show()
        canvas.get_tk_widget().pack(side=tk.BOTTOM, fill=tk.BOTH, expand=True)

        toolbar = NavigationToolbar2TkAgg(canvas, self)
        toolbar.update()
        canvas._tkcanvas.pack(side=tk.TOP, fill=tk.BOTH, expand=True)
        
        
class PageFour(tk.Frame):

    def __init__(self, parent, controller):
        tk.Frame.__init__(self, parent)
        label = tk.Label(self, text="Current vs Time for aircon on and data filtered", font=LARGE_FONT)
        label.pack(pady=10,padx=10)

        button1 = ttk.Button(self, text="Back to Home",
                            command=lambda: controller.show_frame(StartPage))
        button1.pack()

        f = Figure(figsize=(5,5), dpi=100)
        a = f.add_subplot(111)
        a.plot_date(DataAirconON['Local time'], DataAirconON['Current'])
        a.set_xlabel("Time")
        a.set_ylabel("Current")
        a.set_title("Current vs Time for aircon on and data filtered")

        

        canvas = FigureCanvasTkAgg(f, self)
        canvas.show()
        canvas.get_tk_widget().pack(side=tk.BOTTOM, fill=tk.BOTH, expand=True)

        toolbar = NavigationToolbar2TkAgg(canvas, self)
        toolbar.update()
        canvas._tkcanvas.pack(side=tk.TOP, fill=tk.BOTH, expand=True)
        

class PageFive(tk.Frame):

    def __init__(self, parent, controller):
        tk.Frame.__init__(self, parent)
        label = tk.Label(self, text="Delta Temperature vs Time for aircon on and data filtered", font=LARGE_FONT)
        label.pack(pady=10,padx=10)

        button1 = ttk.Button(self, text="Back to Home",
                            command=lambda: controller.show_frame(StartPage))
        button1.pack()

        f = Figure(figsize=(5,5), dpi=100)
        a = f.add_subplot(111)
        a.plot_date(DataAirconON['Local time'], DataAirconON['Delta Temperature'])
        a.set_xlabel("Time")
        a.set_ylabel("Delta Temperature")
        a.set_title("Delta Temperature vs Time for aircon on and data filtered")

        

        canvas = FigureCanvasTkAgg(f, self)
        canvas.show()
        canvas.get_tk_widget().pack(side=tk.BOTTOM, fill=tk.BOTH, expand=True)

        toolbar = NavigationToolbar2TkAgg(canvas, self)
        toolbar.update()
        canvas._tkcanvas.pack(side=tk.TOP, fill=tk.BOTH, expand=True)


        
        
class PageSix(tk.Frame):

    def __init__(self, parent, controller):
        tk.Frame.__init__(self, parent)
        label = tk.Label(self, text="Boxplot of filtered data aircon on current", font=LARGE_FONT)
        label.pack(pady=10,padx=10)

        button1 = ttk.Button(self, text="Back to Home",
                            command=lambda: controller.show_frame(StartPage))
        button1.pack()

        f = Figure(figsize=(5,5), dpi=100)
        a = f.add_subplot(111)
        a.boxplot(DataAirconON['Current'], 0, 'gD')        
        a.set_title("Boxplot of filtered data aircon on current")

        

        canvas = FigureCanvasTkAgg(f, self)
        canvas.show()
        canvas.get_tk_widget().pack(side=tk.BOTTOM, fill=tk.BOTH, expand=True)

        toolbar = NavigationToolbar2TkAgg(canvas, self)
        toolbar.update()
        canvas._tkcanvas.pack(side=tk.TOP, fill=tk.BOTH, expand=True)
        

class PageSeven(tk.Frame):

    def __init__(self, parent, controller):
        tk.Frame.__init__(self, parent)
        label = tk.Label(self, text="Boxplot of filtered data aircon on delta temperature", font=LARGE_FONT)
        label.pack(pady=10,padx=10)

        button1 = ttk.Button(self, text="Back to Home",
                            command=lambda: controller.show_frame(StartPage))
        button1.pack()

        f = Figure(figsize=(5,5), dpi=100)
        a = f.add_subplot(111)
        a.boxplot(DataAirconON['Delta Temperature'], 0, 'gD')        
        a.set_title("Boxplot of filtered data aircon on delta temperature")

        

        canvas = FigureCanvasTkAgg(f, self)
        canvas.show()
        canvas.get_tk_widget().pack(side=tk.BOTTOM, fill=tk.BOTH, expand=True)

        toolbar = NavigationToolbar2TkAgg(canvas, self)
        toolbar.update()
        canvas._tkcanvas.pack(side=tk.TOP, fill=tk.BOTH, expand=True)
        
class PageEight(tk.Frame):

    def __init__(self, parent, controller):
        tk.Frame.__init__(self, parent)
        label = tk.Label(self, text="Times dirty filter was detected", font=LARGE_FONT)
        label.pack(pady=10,padx=10)

        button1 = ttk.Button(self, text="Back to Home",
                            command=lambda: controller.show_frame(StartPage))
        button1.pack()
        
        Lb1 =  tk.Listbox(self)
        Lb1.pack(pady=10,padx=10,side = 'top', anchor='w')
        #stringtemp = ErrorTimesString[0] + ' - ' + ErrorTimesString[(len(ErrorTimesString)-1)]
        #Lb1.insert(1,stringtemp)
        for x in range (0,len(ErrorTimesString)):
            Lb1.insert(x,ErrorTimesString[x])
        
        Lb1.config(width=0)
        
        

class PageNine(tk.Frame):

    def __init__(self, parent, controller):
        tk.Frame.__init__(self, parent)
        label = tk.Label(self, text="Times Aircon did not cool as suppose", font=LARGE_FONT)
        label.pack(pady=10,padx=10)

        button1 = ttk.Button(self, text="Back to Home",
                            command=lambda: controller.show_frame(StartPage))
        button1.pack()
        
        Lb2 =  tk.Listbox(self)
        Lb2.pack(pady=10,padx=10,side = 'top', anchor='w')
        #stringtemp = ErrorTimesString[0] + ' - ' + ErrorTimesString[(len(ErrorTimesString)-1)]
        #Lb1.insert(1,stringtemp)
        for x in range (0,len(ErrorTimesStringMel)):
            Lb2.insert(x,ErrorTimesStringMel[x])
        
        Lb2.config(width=0)
           

        

app = mainprog()
app.mainloop()