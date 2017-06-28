RADSN = 'RAD02';
disp('---- PSP ------------------------------------------------------------------');
k_psp = 8.48e-6;
pspampgain = [123.2,19.8]';  % first run
v_in = [0, 2, 4, 6, 10]'; % MV
adc_psp = [26.8, 261, 506.8, 760.5, 1254.3]';  % first run
% COMPUTE SW FROM INPUT VOLTAGE
%sw_rad = [22.8, 253, 487.3, 721.0, 1190.2]';   % first run
sw_rad = [-1, 237.5, 475.5, 712.5, 1189.0]';   % second run
sw_test = v_in ./ k_psp / 1000;   % sw based on input voltage.
% COMPUTE SW FROM ADC
sw_adc = (adc_psp - pspampgain(2)) / pspampgain(1) / k_psp / 1000;  % sw as computed in the program.
% PRINT RESULTS
fprintf('%s: PSP K = %8.2e, AMP GAIN = %.1f, AMP OUTPUT OFFSET, MV = %.1f\n',RADSN,k_psp, pspampgain(1), pspampgain(2));
disp('VIN is the input voltage (mv)');
disp('ADC is the ADC count mean from several samples.');
disp('SW-RAD is the SW computed by RAD in the NMEA');
disp('SW-ADC is SW computed from ADC count and fitted gain and offset.');
disp('SW-TEST is SW based on input volts and K.');
fprintf('   VIN(MV)   ADC(mv)       SW-RAD     SW_ADC     SW-TEST\n');
fprintf('%10.1f %10.1f %10.1f %10.1f %10.1f\n', [v_in, adc_psp, sw_rad, sw_adc,sw_test]');

p = polyfit(v_in,adc_psp,1);
fprintf('AMP GAIN = %.1f, AMP OFFSET = %.1f MV\n\n', p(1),p(2));

disp('RECOMPUTE WITH ADJUSTED GAIN');
pspampgain = p;
sw_adc = (adc_psp - pspampgain(2)) / pspampgain(1) / k_psp / 1000;  % sw as computed in the program.
% PRINT RESULTS
fprintf('AMP GAIN = %.1f, AMP OFFSET = %.1f MV\n', p(1),p(2));
disp('VIN is the input voltage (mv)');
disp('ADC is the ADC count mean from several samples.');
disp('SW-RAD is the SW computed by RAD in the NMEA');
disp('SW-ADC is SW computed from ADC count and fitted gain and offset.');
disp('SW-TEST is SW based on input volts and K.');
fprintf('   VIN(MV)   ADC(mv)       SW-RAD     SW_ADC     SW-TEST\n');
fprintf('%10.1f %10.1f %10.1f %10.1f %10.1f\n', [v_in, adc_psp, sw_rad, sw_adc,sw_test]');
return


disp(' ');
disp('--- PIRU --------------------------------------------------------------------------------');
k_pir = 3.11e-6;
pirampgain = [825,0]';
v_in = [-.4, -.2, 0, .2, .4, .6, 1]'; % MV
adc_pir = [-290, -128, 39, 198, 357, 521, 841]';
piru_test = v_in / 1000 / k_pir;
p = polyfit(v_in,adc_pir,1);
fprintf('%s: PIR K = %8.2e, AMP GAIN = %.1f, AMP OUTPUT OFFSET, MV = %.1f\n',RADSN, k_pir, pirampgain(1), pirampgain(2));
disp('VIN is the input voltage (mv)');
disp('ADC is the ADC count mean of 10 samples.');
fprintf('   VIN   ADC \n');
fprintf('%10.1f %10.2f\n',[v_in, adc_pir]');
fprintf('ADC GAIN = %.1f, ADC OFFSET = %.1f MV\n\n', p(1),p(2));
return

disp(' ');
disp('---- CASE TEMPERATURE -----------------------------------------------------------------');
% TEST RESISTORS
Tabs = 273.15;
r_test = [14966, 9991, 5621]';
C = [1.025579e-03,  2.397338e-04,  1.542038e-07]';
t_test = SteinhartHart(C,r_test);
% COMPUTE REFERENCE RESISTOR
Vadc = 4095;
Vref = Vadc;
Cmax = 2048;
Rref = 32200;
% case
v_meas = [1273, 948, 593]';  % MV VOLTAGE ACROSS TEST RESISTOR
% compute Rrefm
i_m = v_meas ./ r_test;
Rrefcal = (Vref - v_meas) ./ i_m;
% VOLTAGE AT ADC
ctest = [1263.13, 943.0, 595.25]';
t_radout = [15.53, 25.06, 39.40]';
v_adc = Vref .* (ctest/2) ./ Cmax;
% CURRENT based on adc count
i = (Vref - v_adc) / Rref;
% THERMISTOR RESISTANCE, COMPUTED FROM ADC
r_rad = v_adc ./ i;
% POWER ACROSS THERMISTOR
p_t = i .* i .* r_rad ./ 1e6;
% TEMPERATURE CORRECTION FOR POWER DISSIPATION.
t_corr = p_t/.004;
% COMPUTE TEMPERATURE BASED ON ADC
t_rad0 = SteinhartHart(C, r_rad);
% power correction
t_rad = t_rad0 - t_corr;
% voltage error ratio
ratio = (v_adc - v_meas) ./ v_adc;

fprintf('%s: PIR CASE Vadc = %.1f mv, Cmax = %.0f, Rref = %.1f ohms\n',RADSN,Vadc,Cmax,Rref);
disp('R-TEST = calibration resistances. (ohms)');
disp('T-TEST = thermistor temperature for cal resistors. (C)');
disp('ADC is the corresponding ADC count from the test menu. (count)');
disp('V-MEAS is the voltage measured across the test resistances. (mv)');
disp('R-REF is the reference resistance computed from measured voltage across the test resistances. (ohms)');
disp('V-ADC is the voltage computed from the ADC count and the measured Vref. (mv)');
disp('R-RAD is the thermistor resistance computed from adc. This is the RAD value. (ohms)');
disp('T-OUT is the temperature from the RAD NMEA line.');
disp('T-RAD0 is the temperature based on computed thermistor resistance computed by the RAD program. (C)');
disp('T-CORR is the correction to T-RAD from the power dissipation. (C)');
disp('RATIO is (V-ADC - V-MEAS) / V-ADC.');
disp('   R-TEST   T-TEST   V-MEAS  R-REF    ADC    V-ADC    R-RAD     T-OUT    T-RAD0  T-CORR  RATIO');
fprintf('%8.0f %9.3f %7.0f %9.1f %5.0f %8.1f %8.1f %8.2f %8.2f %7.3f% 8.3f\n',[r_test, t_test, v_meas, Rrefcal, ctest, v_adc, r_rad, t_radout, t_rad0, t_corr, ratio]');
fprintf('Mean Rref = %.1f\n', mean(Rrefcal));


disp(' ');
disp('---- DOME TEMPERATURE -----------------------------------------------------------------');
% TEST RESISTORS
r_test = [14966, 9993, 5621]';
C = [1.025579e-03,  2.397338e-04,  1.542038e-07]';
t_test = SteinhartHart(C,r_test);
% dome
v_meas = [1.272, .948, .593]'*1000;  % VOLTAGE ACROSS TEST RESISTOR
% COMPUTE REFERENCE RESISTOR
i_m = v_meas ./ r_test;
Rrefcal = (Vref - v_meas) ./ i_m;
Rref = 32700;
% VOLTAGE AT ADC
ctest = [1277.4, 955.86, 606.3]';
t_radout = [15.51, 25.05, 39.52]';
v_adc = Vref .* (ctest/2) ./ Cmax;
% CURRENT based on adc count
i = (Vref - v_adc) / Rref;
% THERMISTOR RESISTANCE, COMPUTED FROM ADC
r_rad = v_adc ./ i;
% POWER ACROSS THERMISTOR
p_t = i .* i .* r_rad ./ 1e6;
% TEMPERATURE CORRECTION FOR POWER DISSIPATION.
t_corr = p_t/.004;
% COMPUTE TEMPERATURE BASED ON ADC
t_rad0 = SteinhartHart(C, r_rad);
% power correction
t_rad = t_rad0 - t_corr;
% voltage error ratio
ratio = (v_adc - v_meas) ./ v_adc;

fprintf('%s: PIR DOME Vadc = %.1f mv, Cmax = %.0f, Rref = %.1f ohms\n',RADSN,Vadc,Cmax,Rref);
disp('R-TEST = calibration resistances. (ohms)');
disp('T-TEST = thermistor temperature for cal resistors. (C)');
disp('ADC is the corresponding ADC count from the test menu. (count)');
disp('V-MEAS is the voltage measured across the test resistances. (mv)');
disp('R-REF is the reference resistance computed from measured voltage across the test resistances. (ohms)');
disp('V-ADC is the voltage computed from the ADC count and the measured Vref. (mv)');
disp('R-RAD is the thermistor resistance computed from adc. This is the RAD value. (ohms)');
disp('T-RAD0 is the temperature based on computed thermistor resistance computed by the RAD program. (C)');
disp('T-CORR is the correction to T-RAD from the power dissipation. (C)');
disp('RATIO is (V-ADC - V-MEAS) / V-ADC.');
disp('   R-TEST   T-TEST   V-MEAS  R-REF    ADC    V-ADC    R-RAD     T-OUT    T-RAD0  T-CORR  RATIO');
fprintf('%8.0f %9.3f %7.0f %9.1f %5.0f %8.1f %8.1f %8.2f %8.2f %7.3f% 8.3f\n',[r_test, t_test, v_meas, Rrefcal, ctest, v_adc, r_rad, t_radout, t_rad0, t_corr, ratio]');
fprintf('Mean Rref = %.1f\n', mean(Rrefcal));
return


%void therm_circuit_ground(double c, double C_max, double R_ref, double V_therm, double V_adc,
% 	double *v_t, double *R_t, double *P_t)
% /*************************************************************/
% //Compute the thermistor resistance for a resistor divider circuit 
% //with reference voltage (V_therm), reference resistor (R_ref), 
% //thermistor is connected to GROUND.  The ADC compares a reference 
% //voltage (V_adc) with the thermistor voltage (v_t) and gives an adc 
% //count (c).  The ADC here is unipolar and referenced to ground.
% //The ADC range is 0--C_max and is linear with input voltage 0--V_adc.
% //Input:
% //  c = ADC count.
% //  C_max = maximum count, typically 4096.
% //  R_ref = reference resistor (ohms)
% //  V_therm = thermistor circuit reference voltage 
% //  V_adc = ADC reference voltage.
% //Output:
% //  v_t = thermistor voltage (volts)
% //  R_t = thermistor resistance (ohms)
% //  P_t = power dissipated by the thermistor (watts)
% //	(for self heating correction)
% //example
% //	double cx, Cmax, Rref, Vtherm, Vadc;
% //	double vt, Rt, Pt;
% //	cx = 2036;  Cmax = 4095; Rref = 10021; Vtherm = 5.0123;  Vadc = 4.087;
% //	ysi46006_circuit(c, Cmax, Rref, Vtherm, Vadc, &vt, &Rt, &Pt);
% // vt= 2.0320 volts,  Rt = 6832.48 ohms,  Pt = 6.04323e-4 Watts 
% /*************************************************************/
% {
% 	double x;
% 	
% 	//printf("therm_circuit_ground: c = %.1f,              C_max = %.1f,\r\n",c, C_max);
% 	//printf("therm_circuit_ground: V_therm = %.3f         V_adc = %.3f\r\n", V_therm, V_adc);
% 	//printf("therm_circuit_ground: R_ref = %.1f\r\n", R_ref);
% 	
% 	*v_t = V_adc * (c/2) / C_max;
% 	x = (V_therm - *v_t) / R_ref;  // circuit current, I
% 	*R_t = *v_t / x;  // v/I
% 	*P_t = x * x * *R_t;  // I^2 R = power
% 	
% 	//printf("therm_circuit_ground: v_t = %.4f,       R_t = %.2f,          P_t = %.4e\r\n", *v_t, *R_t, *P_t);
% 
% 	return;
% }
% % double ysi46000(double Rt, double Pt)
% /*************************************************************/
% // Uses the Steinhart-Hart equations to compute the temperature 
% // in degC from thermistor resistance.  S-S coeficients are 
% // either computed from calibrations or tests, or are provided by 
% // the manufacturer.  Reynolds has Matlab routines for computing 
% // the S-S coefficients.
% //                                                               
% //	xr = ln(Rt);   where Rt is the thermistor resistance in ohms.
% //	1/Tk = C(0) + C(1) * xr + C(2) * xr * xr * xr;
% //  Tc = Tk - 273.15;
% //
% // correction for self heating.
% // For no correction set P_t = 0;
% // deltaT = p(watts) / .004 (W/degC)
% //
% //rmr 050128
% /*************************************************************/
% {
% 	double x;
% 	double C[3] = {1.025579e-03,  2.397338e-04,  1.542038e-07};  
% 	// ysi46041, matlab steinharthart_fit(), 0--40 degC
% 	x = SteinhartHart(C, Rt);
% 	//printf("ysi46000: R_t = %.2f,  P_t = %.4e\r\n",Rt, Pt);
% 	//printf("ysi46000: Cal temp = %.5f\r\n",x);
% 	
% 	x = x - Pt/.004; // return temperature in degC
% 	//printf("Temp correction = %.3e,  final temp = %.5f\r\n", Pt/.004, x);
% 	return x;
% 
% } 
% 
