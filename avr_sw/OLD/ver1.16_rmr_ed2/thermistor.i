double ysi46041(double r, double *c)
/************************************************************
	Description: Best fit of Steinhart Hart equation to YSI
	tabulated data from -10C to 60C for H mix 10k thermistors.
	Given the thermistor temperature in Kelvin.

	The lack of precision in the YSI data is evident around
	9999/10000 Ohm transition.  Scatter approaches 10mK before,
	much less after.  Probably some systemmatics at the 5mK level
	as a result.  Another decimal place in the impedances would 
	have come in very handy.  The YSI-derived coefficients read
	10mK cold or some through the same interval.

	Mandatory parameters:
	R - Thermistor resistance(s) in Ohms
	C - Coefficients of fit from isarconf.icf file specific
	to each thermistor.
************************************************************/
{ 
double t1, LnR;
	if(r>0)
	{
		LnR = log(r);
		t1 = 1 / (c[0] + LnR * (c[1] + LnR*LnR * c[2]) );
	}
	else t1 = 0;
		return t1;
}
double ysi46041CountToRes(double c)
/**************************************************************
	Description: Converts raw counts to resistance for the 
	YSI46041 10K thermistors.
**************************************************************/
{
	double  r=0;
				r = 10000.0 * c / (5.0 - c);
				return r;
}
double ysi46000(double Rt, double Pt)
/*************************************************************/
// Uses the Steinhart-Hart equations to compute the temperature 
// in degC from thermistor resistance.  S-S coeficients are 
// either computed from calibrations or tests, or are provided by 
// the manufacturer.  Reynolds has Matlab routines for computing 
// the S-S coefficients.
//                                                               
//	xr = ln(Rt);   where Rt is the thermistor resistance in ohms.
//	1/Tk = C(0) + C(1) * xr + C(2) * xr * xr * xr;
//  Tc = Tk - 273.15;
//
// correction for self heating.
// For no correction set P_t = 0;
// deltaT = p(watts) / .004 (W/degC)
//
//rmr 050128
/*************************************************************/
{
	double x;
	double C[3] = {1.025579e-03,  2.397338e-04,  1.542038e-07};  
	// ysi46041, matlab steinharthart_fit(), 0--40 degC
	x = SteinhartHart(C, Rt);
	//printf("ysi46000: R_t = %.2f,  P_t = %.4e\r\n",Rt, Pt);
	//printf("ysi46000: Cal temp = %.5f\r\n",x);
		x = x - Pt/.004; // return temperature in degC
	//printf("Temp correction = %.3e,  final temp = %.5f\r\n", Pt/.004, x);
	return x;
} 
void therm_circuit_ground(double c, double C_max, double R_ref, double V_therm, double V_adc,
	double *v_t, double *R_t, double *P_t)
/*************************************************************/
//Compute the thermistor resistance for a resistor divider circuit //with reference voltage (V_therm), reference resistor (R_ref), //thermistor is connected to GROUND.  The ADC compares a reference //voltage (V_adc) with the thermistor voltage (v_t) and gives an adc //count (c).  The ADC here is unipolar and referenced to ground.
//The ADC range is 0--C_max and is linear with input voltage 0--V_adc.
//Input:
//  c = ADC count.
//  C_max = maximum count, typically 4096.
//  R_ref = reference resistor (ohms)
//  V_therm = thermistor circuit reference voltage 
//  V_adc = ADC reference voltage.
//Output:
//  v_t = thermistor voltage (volts)
//  R_t = thermistor resistance (ohms)
//  P_t = power dissipated by the thermistor (watts)
//	(for self heating correction)
//example
//	double cx, Cmax, Rref, Vtherm, Vadc;
//	double vt, Rt, Pt;
//	cx = 2036;  Cmax = 4095; Rref = 10021; Vtherm = 5.0123;  Vadc = 4.087;
//	ysi46006_circuit(c, Cmax, Rref, Vtherm, Vadc, &vt, &Rt, &Pt);
// vt= 2.0320 volts,  Rt = 6832.48 ohms,  Pt = 6.04323e-4 Watts 
/*************************************************************/
{
	double x;
		//printf("therm_circuit_ground: c = %.1f,              C_max = %.1f,\r\n",c, C_max);
	//printf("therm_circuit_ground: V_therm = %.3f         V_adc = %.3f\r\n", V_therm, V_adc);
	//printf("therm_circuit_ground: R_ref = %.1f\r\n", R_ref);
		*v_t = V_adc * (c/2) / C_max;
	x = (V_therm - *v_t) / R_ref;  // circuit current, I
	*R_t = *v_t / x;  // v/I
	*P_t = x * x * *R_t;  // I^2 R = power
		//printf("therm_circuit_ground: v_t = %.4f,       R_t = %.2f,          P_t = %.4e\r\n", *v_t, *R_t, *P_t);
	return;
}
