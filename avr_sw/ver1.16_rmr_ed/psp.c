#include "PSP.h"

/*******************************************************************************************/

float PSPSW(double vp, double kp, double PSPadc_offset, double PSPadc_gain, double *sw)
/**********************************************************
%input
%  vp = thermopile voltage
%  kp = thermopile calibration factor in volts/ W m^-2.
%  gainPSP[2] is the offset and gain for the preamp circuit
%     The thermopile net radiance is given by vp/kp, but
%     if a preamp is used, then the measured voltage vp = c0 + c1 * vp'
%     where vp' is the actual voltage on the thermopile.
%	Then vp' = (vp - c0) / c1;  And e = vp'/kp;
%  e = thermopile computed flux in W/m^2 
%    
%  no arguments ==> test mode
%  sw = corrected shortwave flux, W/m^2
%  
%000928 changes eps to 0.98 per {fairall98}
%010323 back to 1.0 per Fairall
% v14 080603 rmr -- 
/**********************************************************/
{

	double e; // w/m^2 on the thermopile 
	
	// THERMOPILE IRRADIANCE
	e = ( (((vp - PSPadc_offset) / PSPadc_gain) /1000) / kp );
	//printf("PSP: e = %.4e\r\n", e);
	
	*sw = e;
	
	return e;
}
