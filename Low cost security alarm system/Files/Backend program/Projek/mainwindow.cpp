#include "mainwindow.h"


using namespace std;

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
{
    //this->showFullScreen();
    //this->setMinimumSize(1366, 768);
    QTimer::singleShot(50, this, SLOT(showFullScreen()));

    qApp->setStyleSheet("QPushButton:hover:!Pressed {"
                        "color: yellow;"
                        "background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #88d, stop: 0.1 #99e, stop: 0.49 #77c, stop: 0.5 #66b, stop: 1 #77c);"
                        "border-width: 1px;"
                        "border-color: #339;"
                        "border-style: solid;"
                        "border-radius: 7;"
                        "padding: 3px;"
                        "padding-left: 5px;"
                        "padding-right: 5px;"
                        "min-width: 50px;"
                        "max-width: 400px;"
                        "min-height: 10px;"
                        "max-height: 60px;"
                      "}"
                        "QPushButton {"
                         "color: white;"
                         "background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #88d, stop: 0.1 #99e, stop: 0.49 #77c, stop: 0.5 #66b, stop: 1 #77c);"
                         "border-width: 1px;"
                         "border-color: #339;"
                         "border-style: solid;"
                         "border-radius: 7;"
                         "padding: 3px;"
                         "padding-left: 5px;"
                         "padding-right: 5px;"
                         "min-width: 50px;"
                         "max-width: 400px;"
                         "min-height: 10px;"
                         "max-height: 60px;"
                       "}"
                        "QPushButton:Hover {"
                         "color: red;"
                         "background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #88d, stop: 0.1 #99e, stop: 0.49 #77c, stop: 0.5 #66b, stop: 1 #77c);"
                         "border-width: 1px;"
                         "border-color: #339;"
                         "border-style: solid;"
                         "border-radius: 7;"
                         "padding: 3px;"
                         "padding-left: 5px;"
                         "padding-right: 5px;"
                         "min-width: 50px;"
                         "max-width: 400px;"
                         "min-height: 10px;"
                         "max-height: 60px;"
                       "}");

    MainScreen();




}

void MainWindow::bbtnadminclick(){
//    QString s = edtAdmPass->text();
//    qDebug(s.toLatin1());
    if (edtAdmPass->text() == "jan") {
        MainScreen();
    }

}

void MainWindow::bbtnclientclick(){

    if (edtCntPass->text() == "piet") {
        MainScreen();
    }
    else{
        QLabel *lblheader = new QLabel(this);
        lblheader->setFixedSize(300,50);
        lblheader->move(690,450);
        QFont lblfont = lblheader->font();
        lblfont.setPointSize(16);
        lblheader->setFont(lblfont);
        lblheader->setStyleSheet("QLabel {"
                           "color : red;"
                           "font-style :italic;"
                           "text-decoration : underline"
                         "}");
        lblheader->setText("Incorrect password entered! ");
        lblheader->show();

    }

}

void MainWindow::Alarm() {

    QPixmap securityscreen(":/img/sec3.jpg");
    QLabel *lsecurityscreen = new QLabel(this);
    lsecurityscreen->setPixmap(securityscreen);
    lsecurityscreen->setFixedWidth(1920);
    lsecurityscreen->setFixedHeight(1080);
    lsecurityscreen->setScaledContents(true);
    lsecurityscreen->show();
    lsecurityscreen->raise();

    pnlAlarm = new QFrame(this);
    pnlAlarm->setFixedSize(600,400);
    pnlAlarm->move(600,100);
    pnlAlarm->setStyleSheet("QFrame {"
                            "background-color: qlineargradient(spread:reflect, x1:0.5, y1:0, x2:0, y2:0, stop:0 rgb(94, 204, 233), stop:1 rgb(32, 80, 96));"
                            "border-radius: 8px;"
                            "}");
    pnlAlarm->show();
    pnlAlarm->raise();

    QLabel *lblName = new QLabel(this);
    lblName->setFixedSize(150,50);
    lblName->move(690,100);
    QFont lblfont = lblName->font();
    lblfont.setPointSize(16);
    lblName->setFont(lblfont);
    lblName->setStyleSheet("QLabel {"
                       "color : black;"
                       "font-style :italic;"
                       "text-decoration : underline"
                     "}");
    lblName->setText("Name : ");
    lblName->show();

    QLabel *lblLocation = new QLabel(this);
    lblLocation->setFixedSize(150,50);
    lblLocation->move(690,150);
    lblLocation->setFont(lblfont);
    lblLocation->setStyleSheet("QLabel {"
                       "color : black;"
                       "font-style :italic;"
                       "text-decoration : underline"
                     "}");
    lblLocation->setText("Address : ");
    lblLocation->show();

    QLabel *lblNumber = new QLabel(this);
    lblNumber->setFixedSize(150,50);
    lblNumber->move(690,200);
    lblNumber->setFont(lblfont);
    lblNumber->setStyleSheet("QLabel {"
                       "color : black;"
                       "font-style :italic;"
                       "text-decoration : underline"
                     "}");
    lblNumber->setText("Call number : ");
    lblNumber->show();

    QLabel *lblSector = new QLabel(this);
    lblSector->setFixedSize(150,50);
    lblSector->move(690,250);
    lblSector->setFont(lblfont);
    lblSector->setStyleSheet("QLabel {"
                       "color : black;"
                       "font-style :italic;"
                       "text-decoration : underline"
                     "}");
    lblSector->setText("Sector : ");
    lblSector->show();

    QPixmap dataframe(":/img/frame.png");
    QLabel *ldataframe = new QLabel(this);
    ldataframe->setPixmap(dataframe);
    ldataframe->setFixedWidth(550);
    ldataframe->setFixedHeight(700);
    ldataframe->setScaledContents(true);
    ldataframe->move(1300,100);
    ldataframe->show();
    ldataframe->raise();

    QLabel *lblPolice = new QLabel(this);
    lblPolice->setFixedSize(350,50);
    lblPolice->move(1400,300);
    lblPolice->setFont(lblfont);
    lblPolice->setStyleSheet("QLabel {"
                       "color : black;"
                       "font-style :italic;"
                       "text-decoration : underline"
                     "}");
    lblPolice->setText("Police department : 10111 ");
    lblPolice->show();

    QLabel *lblFire = new QLabel(this);
    lblFire->setFixedSize(350,50);
    lblFire->move(1400,350);
    lblFire->setFont(lblfont);
    lblFire->setStyleSheet("QLabel {"
                       "color : black;"
                       "font-style :italic;"
                       "text-decoration : underline"
                     "}");
    lblFire->setText("Fire department : (018) 293 1111/2 ");
    lblFire->show();

    QLabel *lblAmbulance = new QLabel(this);
    lblAmbulance->setFixedSize(350,50);
    lblAmbulance->move(1400,400);
    lblAmbulance->setFont(lblfont);
    lblAmbulance->setStyleSheet("QLabel {"
                       "color : black;"
                       "font-style :italic;"
                       "text-decoration : underline"
                     "}");
    lblAmbulance->setText("Ambulance : (018) 293 1111/2 ");
    lblAmbulance->show();


    QPixmap intframe(":/img/scroll.png");
    QLabel *lintframe = new QLabel(this);
    lintframe->setPixmap(intframe);
    lintframe->setFixedWidth(500);
    lintframe->setFixedHeight(500);
    lintframe->setScaledContents(true);
    lintframe->move(50,100);
    lintframe->show();
    lintframe->raise();

    QLabel *lblint = new QLabel(this);
    lblint->setFixedSize(400,300);
    lblint->move(110,150);
    QFont intfont = lblint->font();
    intfont.setPointSize(14);
    lblint->setFont(intfont);
    lblint->setStyleSheet("QLabel {"
                       "color : black;"
                     "}");
    lblint->setText("Instructions\n\n1.Call the number provided\n2.Ask if everything is fine\n3.If person in destress call the apropraite \nhelpline\n4.If everything is fine ask for codeword\n5.End conversation and insert codeword");
    lblint->show();
    lblint->raise();

    bbtadmin = new QPushButton(this);
    bbtadmin->setFixedSize(250,50);
    bbtadmin->move(100,820);
    bbtadmin->setText("Admin Overide");
    QFont font1 = bbtadmin->font();
    font1.setPointSize(16);
    bbtadmin->setFont(font1);
    bbtadmin->show();
    bbtadmin->raise();

    edtAdmPass = new QLineEdit(this);
    edtAdmPass->setFixedSize(300,50);
    edtAdmPass->move(100,750);
    QFont edtfont1 = edtAdmPass->font();
    edtfont1.setPointSize(16);
    edtAdmPass->setEchoMode(QLineEdit::Password);
    edtAdmPass->setFont(edtfont1);
    edtAdmPass->show();
    edtAdmPass->raise();

    bbtclient = new QPushButton(this);
    bbtclient->setFixedSize(250,50);
    bbtclient->move(690,400);
    bbtclient->setText("Check Password");
    bbtclient->setFont(font1);
    bbtclient->show();
    bbtclient->raise();

    edtCntPass = new QLineEdit(this);
    edtCntPass->setFixedSize(300,50);
    edtCntPass->move(690,330);
    edtCntPass->setFont(edtfont1);
    edtCntPass->show();
    edtCntPass->raise();

    connect(bbtadmin, SIGNAL(clicked(bool)), this, SLOT(bbtnadminclick()));
    connect(bbtclient, SIGNAL(clicked(bool)), this, SLOT(bbtnclientclick()));

}

void MainWindow::bbtnloginclick(){
    LoginScreen();
}

void MainWindow::bbtnbackclick(){
    MainScreen();
}

void MainWindow::LoginScreen(){

    QPixmap loginscreen(":/img/sec2.png");
    QLabel *lloginscreen = new QLabel(this);
    lloginscreen->setPixmap(loginscreen);
    lloginscreen->setFixedWidth(1920);
    lloginscreen->setFixedHeight(1080);
    lloginscreen->setScaledContents(true);
    lloginscreen->show();

    pnlLogin = new QFrame(this);
    pnlLogin->setFixedSize(600,400);
    pnlLogin->move(600,100);
    pnlLogin->setStyleSheet("QFrame {"
                            "background-color: qlineargradient(spread:reflect, x1:0.5, y1:0, x2:0, y2:0, stop:0 rgba(91, 204, 233, 70), stop:1 rgba(32, 80, 96, 70));"
                            "border-radius: 8px;"
                            "}");
    pnlLogin->show();
    pnlLogin->raise();

    bbtquit->setFixedSize(250,50);
    bbtquit->move(100,800);
    bbtquit->show();
    bbtquit->raise();

    bbtback = new QPushButton(this);
    bbtback->setFixedSize(250,50);
    bbtback->move(100,700);
    bbtback->setText("Back");
    QFont font1 = bbtback->font();
    font1.setPointSize(16);
    bbtback->setFont(font1);
    bbtback->show();
    bbtback->raise();

    bbtcheck = new QPushButton(this);
    bbtcheck->setFixedSize(550,50);
    bbtcheck->move(695,400);
    bbtcheck->setText("Login");
    bbtcheck->setFont(font1);
    bbtcheck->show();
    bbtcheck->raise();

    edtUser = new QLineEdit(this);
    edtUser->setFixedSize(300,50);
    edtUser->move(810,200);
    QFont edtfont1 = edtUser->font();
    edtfont1.setPointSize(16);
    edtUser->setFont(edtfont1);
    edtUser->show();
    edtUser->raise();

    edtPass = new QLineEdit(this);
    edtPass->setFixedSize(300,50);
    edtPass->move(810,300);
    edtPass->setFont(edtfont1);
    edtPass->setEchoMode(QLineEdit::Password);
    edtPass->show();
    edtPass->raise();

    QLabel *lblUser = new QLabel(this);
    lblUser->setFixedSize(150,50);
    lblUser->move(690,200);
    QFont lblfont = lblUser->font();
    lblfont.setPointSize(16);
    lblUser->setFont(lblfont);
    lblUser->setStyleSheet("QLabel {"
                       "color : red;"
                       "font-style :italic;"
                       "text-decoration : underline"
                     "}");
    lblUser->setText("Username : ");
    lblUser->show();


    QLabel *lblPass = new QLabel(this);
    lblPass->setFixedSize(150,50);
    lblPass->move(690,300);
    lblPass->setFont(lblfont);
    lblPass->setStyleSheet("QLabel {"
                       "color : red;"
                       "font-style :italic;"
                       "text-decoration : underline"
                     "}");
    lblPass->setText("Password : ");
    lblPass->show();

    QLabel *lblhead = new QLabel(this);
    lblhead->setFixedSize(600,100);
    lblhead->move(690,100);
    lblhead->setFont(lblfont);
    lblhead->setStyleSheet("QLabel {"
                       "color : black;"
                       "font-weight : bold;"
                       "text-decoration : underline"
                     "}");
    lblhead->setText("Please Enter your username and password ");
    lblhead->show();



    connect(bbtback, SIGNAL(clicked(bool)), this, SLOT(bbtnbackclick()));
    connect(bbtcheck, SIGNAL(clicked(bool)), this, SLOT(bbtncheckclick()));

}

void MainWindow::bbtncheckclick() {

}

void MainWindow::MainScreen(){

    QPixmap startscreen(":/img/sec1.png");
    QLabel *lstartscreen = new QLabel(this);
    lstartscreen->setPixmap(startscreen);
    lstartscreen->setFixedWidth(1920);
    lstartscreen->setFixedHeight(1080);
    lstartscreen->setScaledContents(true);
    lstartscreen->show();

    bbtquit = new QPushButton(this);
    bbtquit->setFixedSize(250,50);
    bbtquit->move(100,800);
    bbtquit->setText("Exit");
    QFont font1 = bbtquit->font();
    font1.setPointSize(16);
    bbtquit->setFont(font1);
    bbtquit->show();
    bbtquit->raise();

    bbtlogin = new QPushButton(this);
    bbtlogin->setFixedSize(250,50);
    bbtlogin->move(100,700);
    bbtlogin->setText("Login");
    bbtlogin->setFont(font1);
    bbtlogin->show();
    bbtlogin->raise();

    connect(bbtquit, SIGNAL(clicked(bool)), this, SLOT(bbtnquitclick()));
    connect(bbtlogin, SIGNAL(clicked(bool)), this, SLOT(bbtnloginclick()));

    bbtalarm = new QPushButton(this);
    bbtalarm->setFixedSize(250,50);
    bbtalarm->move(100,600);
    bbtalarm->setText("Alarm");
    bbtalarm->setFont(font1);
    bbtalarm->show();
    bbtalarm->raise();

    connect(bbtalarm, SIGNAL(clicked(bool)), this, SLOT(Alarm()));
}

void MainWindow::bbtnquitclick(){
    QCoreApplication::quit();
}

MainWindow::~MainWindow()
{

}
