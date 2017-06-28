#include "PIR.h"

/*******************************************************************************************/

void PirTcTd2LW(double vp, double kp, double PIRadc_offset, double PIRadc_gain, double tc, double td, double k, 
	double *lw, double *C_c, double *C_d)
/**********************************************************
%input
%  vp = thermopile voltage
%  kp = thermopile calibration factor in volts/ W m^-2.
%  gainPIR[2] is the offset and gain for the preamp circuit
%     The thermopile net radiance is given by vp/kp, but
%     if a preamp is used, then the measured voltage vp = c0 + c1 * vp'
%     where vp' is the actual voltage on the thermopile.
%	Then vp' = (vp - c0) / c1;  And e = vp'/kp;
%  e = thermopile computed flux in W/m^2 
%  tc = case degC 
%  td = dome degC 
%  k = calib coef, usually = 4.
%  no arguments ==> test mode
%output
%  lw = corrected longwave flux, W/m^2
%  C_c C_d = corrections for case and dome, w/m^2 // Matlab rmrtools edits
%000928 changes eps to 0.98 per {fairall98}
%010323 back to 1.0 per Fairall
/**********************************************************/
{
	double Tc,Td;
	double sigma=5.67e-8;
	double eps = 1;
	double x,y;
	double e; // w/m^2 on the thermopile
	
    	// THERMOPILE IRRADIANCE
		e = ( ( (( vp - PIRadc_offset ) / PIRadc_gain) /1000) / kp ) ;
	    //printf("Tc= %f, Td= %f\n\r", Tc, Td);
		//printf("vp= %f\n\r");
		//printf("PirTcTd2LW: e = %.4e\r\n", e);
	
	// THE CORRECTION IS BASED ON THE TEMPERATURES ONLY
	Tc = tc + Tabs;
	Td = td + Tabs;
	x = Tc * Tc * Tc * Tc; // Tc^4
	y = Td * Td * Td * Td; // Td^4
	
	// Corrections
	*C_c = eps * sigma * x;
	*C_d =  - k * sigma * (y - x);
	
	// Final computation
	*lw = e + *C_c + *C_d;

	return;
}
double SteinhartHart(double C[], double R) 
/*************************************************************/
// Uses the Steinhart-Hart equations to compute the temperature 
// in degC from thermistor resistance.  
// See http://www.betatherm.com/stein.htm
//The Steinhart-Hart thermistor equation is named for two oceanographers 
//associated with Woods Hole Oceanographic Institute on Cape Cod, Massachusetts. 
//The first publication of the equation was by I.S. Steinhart & S.R. Hart 
//in "Deep Sea Research" vol. 15 p. 497 (1968).
//S-S coeficients are
// either computed from calibrations or tests, or are provided by 
// the manufacturer.  Reynolds has Matlab routines for computing 
// the S-S coefficients.
//
//	xr = ln(Rt);   where Rt is the thermistor resistance in ohms.
//	1/Tk = C(0) + C(1) * xr + C(2) * xr * xr * xr;
//  Tc = Tk - 273.15;
//example
// C = 1.0271173e-3,  2.3947051e-4,  1.5532990e-7  
// ysi46041, donlon // C = 1.025579e-03,  2.397338e-04,  1.542038e-07  
// ysi46041, matlab steinharthart_fit()
// R = 25000;     Tc = 25.00C
// rmr 050128
/*************************************************************/
{
	double x;
//	double Tabs = 273.15;  // defined elsewhere

	//printf( "SteinhartHart: %.5e, %.5e, %.5e\r\n",C[0], C[1], C[2]);
	
	x = log(R);
	x = C[0] + x * ( C[1] + C[2] * x * x );
	x = 1/x - Tabs;
	
	//printf("SteinhartHart: R = %.2f,      Tc = %.4f\r\n",R,x);
	return x;
}


