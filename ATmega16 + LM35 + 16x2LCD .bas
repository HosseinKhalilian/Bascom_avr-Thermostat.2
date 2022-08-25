'======================================================================='

' Title: LCD Display Thermometer
' Last Updated :  05.2022
' Author : A.Hossein.Khalilian
' Program code  : BASCOM-AVR 2.0.8.5
' Hardware req. : Atmega16 + LM35 + 16x2 Character lcd display

'======================================================================='

$regfile = "m16def.dat"
$crystal = 1000000

Config Lcdpin = Pin , Db4 = Portc.4 , Db5 = Portc.5 , Db6 = Portc.6 , _
Db7 = Portc.7 , E = Portc.3 , Rs = Portc.2
Config Lcd = 16 * 2

Config Adc = Single , Prescaler = Auto , Reference = Internal
Config Portd = Output
Config Portb = Input

Dim T As Word
Dim H As Byte
Dim L As Byte


Start Adc
Declare Sub Main1
Declare Sub Main2
L = 10
H = 30

'------------------------------------

Do

T = Getadc(2)
T = T / 4

If Pinb.0 = 1 Then Incr H
If Pinb.1 = 1 Then Decr H
If Pinb.2 = 1 Then Incr L
If Pinb.3 = 1 Then Decr L
If T > L Then Reset Portd.1
If T < H Then Reset Portd.0

Cls
Cursor Off
Home
Lcd "TEMP:" ; T ; "   H:" ; H
Locate 2 , 2
Lcd "NORMAL" ; "   L:" ; L

Select Case T
Case Is <= L
Call Main1
Case Is >= H
Call Main2
End Select

Waitms 250
Loop
End

'-----------------------------------------

Main1:

Cls
Cursor Off
Home
Lcd "TEMP:" ; T ; "   H:" ; H
Locate 2 , 2
Lcd "LOW" ; "     L:" ; L

Reset Portd.0
Set Portd.1

Return

''''''''''''''''''''''''''''

Main2:

Cls
Cursor Off
Home
Lcd "TEMP:" ; T ; "   H:" ; H
Locate 2 , 2
Lcd "HIGH" ; "     L:" ; L

Set Portd.0
Reset Portd.1

Return

'---------------------------------------------
