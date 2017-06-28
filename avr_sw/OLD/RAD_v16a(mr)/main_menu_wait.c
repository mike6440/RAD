long t1,t2;

	// ***************************************
	// WAITING FOR A CHARACTER.  TIMEOUT.  v13
	// ***************************************
	rtc_get_time(&h,&m,&s);
	t1 = h*3600+m*60+s;
	while (1) {
		// CHECK INPUT BUFFER FOR A CHARACTER
		if ( SerByteAvail() )
		{
			ch = getchar();
			break;
		}
		// CHECK CURRENT TIME FOR A TIMEOUT		 
		rtc_get_time(&h,&m,&s);
		t2 = h*3600+m*60+s;
		if ( abs(t2 - t1) > MENU_TIMEOUT )     //v13 30 sec timeout
		{
			printf("TIMEOUT: Return to sampling\n\r");
			return;
		}
	}	
