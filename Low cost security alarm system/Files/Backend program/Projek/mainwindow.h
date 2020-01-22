#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QProcess>
#include <QMainWindow>
#include <QLabel>
#include <QPixmap>
#include "time.h"
#include <iostream>
#include <QList>
#include "QSizePolicy"
#include <QTimer>
#include <QMouseEvent>
#include <QProgressBar>
#include <QPushButton>
#include "math.h"
#include <stdlib.h>
#include <QTime>
#include <QCoreApplication>
#include <QDebug>
#include <QtNetwork/QUdpSocket>
#include <QString>
#include <QApplication>
#include <QLineEdit>
#include <QFrame>

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = 0);
    ~MainWindow();

private slots:


    void bbtnquitclick();
    void bbtnloginclick();
    void MainScreen();
    void LoginScreen();
    void bbtnbackclick();
    void bbtncheckclick();
    void Alarm();
    void bbtnadminclick();
    void bbtnclientclick();


protected:



private:


    QPushButton  *bbtquit, *bbtlogin, *bbtback, *bbtcheck, *bbtalarm, *bbtadmin, *bbtclient;
    QLineEdit *edtUser, *edtPass, *edtAdmPass, *edtCntPass;
    QFrame *pnlLogin, *pnlAlarm;


};

#endif // MAINWINDOW_H
