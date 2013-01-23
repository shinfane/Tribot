//
//    protocol.h
//    data exchange functions using bluetooth
//    based on BTLib by Daniele Benedettelli
//
// additional info: the connection initiator is always the master
// please make sure you choose the right NXT as the master

#ifndef CHANNEL
#define CHANNEL   1    // slave channel can be 1, 2 or 3
#endif

#ifndef MAILBOX
#define MAILBOX   0    // 0 to 9
#endif

#define MASTER    0    // master channel is always 0


byte __local_buffer[80];
byte __local_array[59];

void btwaitfor(int conn)
{
	byte e=NO_ERR+1;
	while(e!=NO_ERR)
	{
		e=BluetoothStatus(conn);
		
		if(e==NO_ERR) break;
		if(e==STAT_COMM_PENDING) continue;
		
		TextOut(0, LCD_LINE2, "Bluetooth error:", true);
		NumOut(30, LCD_LINE4, e);
		
		switch(e)
		{
			case ERR_COMM_CHAN_NOT_READY:
				TextOut(0, LCD_LINE6, "NXT bluetooth");
				TextOut(0, LCD_LINE7, "not connected!");
				break;
				
			case ERR_COMM_BUS_ERR:
				TextOut(0, LCD_LINE6, "bus error:");
				TextOut(0, LCD_LINE7, "please reboot");
				break;
		}
		Wait(7000);
		Stop(true);
	}
}


void sendtomaster(string msg)
{
	byte mbx=MAILBOX+10;
	btwaitfor(MASTER);
	SendMessage(mbx, msg);
	btwaitfor(MASTER);
}


void sendtoslave(string msg)
{
	byte len;
	int i;
	
	StrToByteArray(msg,__local_array);
	len = ArrayLen(__local_array);
	__local_buffer[0] = 0x80;    // no reply telegram
	__local_buffer[1] = 0x09;    // MessageWrite Direct Command
	__local_buffer[2] = MAILBOX; // mailbox number
	__local_buffer[3] = len+1;   // message size
	
	len=len+4;
	i=4;
	for(;;)
	{
		__local_buffer[i] = __local_array[i-4];
		i++;
		if(i>=len) break;
	}
	
	btwaitfor(CHANNEL);
	BluetoothWrite(CHANNEL, __local_buffer);
	btwaitfor(CHANNEL);
}


string receivefrommaster()
{
	string msg;
	btwaitfor(MASTER);
	ReceiveMessage(MAILBOX, true, msg);
	btwaitfor(MASTER);
	return msg;
}


string receivefromslave()
{ 
	string msg;
	btwaitfor(CHANNEL);
	ReceiveMessage(MAILBOX, true, msg);
	btwaitfor(CHANNEL);
	return msg;
} 


void btchannelcheck(int conn)
{
	int e = BluetoothStatus(conn);
	string m;
	
	if(e==NO_ERR) return;
	
	TextOut(0, LCD_LINE3, "Bluetooth error", true);
	NumOut(0,  LCD_LINE4, e);
	TextOut(0, LCD_LINE8, "on channel -.");
	NumOut(66, LCD_LINE8, conn);
	
	if(conn==CHANNEL)
	{
		TextOut(0, LCD_LINE1, "Master NXT");
		TextOut(0, LCD_LINE6, "please connect");
		TextOut(0, LCD_LINE7, "the slave NXT");
	}
	else
	{
		TextOut(0, LCD_LINE1, "Slave NXT");
		TextOut(0, LCD_LINE6, "please wait for");
		TextOut(0, LCD_LINE7, "the master NXT");
	}
	
	Wait(11000);
	Stop(true);
}

// -- convenience functions --

void mastercheck()  { btchannelcheck(CHANNEL); }
void slavecheck()   { btchannelcheck(MASTER);  }

// --- end ---

