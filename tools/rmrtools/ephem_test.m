function [az, ze, ze0] = ephem(lat, lon, dt); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%function [az, ze, ze0] = ephem(lat, lon, dt);%pro sunae1,year,day,hour,lat,long,az,el%      implicit real(a-z)%Purpose:%Calculates azimuth and elevation of sun%%References:%(a) Michalsky, J. J., 1988, The Astronomical Almanac's algorithm for%approximate solar position (1950-2050), Solar Energy, 227---235, 1988%%(b) Spencer, J. W., 1989, Comments on The Astronomical%Almanac's algorithm for approximate solar position (1950-2050)%Solar Energy, 42, 353%%Input:%lat -  local latitude in degrees (north is positive)%lon -  local longitude (east of Greenwich is positive.%dt - time epoch array, utc%                        i.e. Honolulu is 15.3, -157.8)%Output:%az - azimuth angle of the sun (measured east from north 0 to 360)%ze - zenith angle at Earth's surface%ze0 - zenith angle at top of atmosphere%Spencer correction introduced and 3 lines of Michalsky code%commented out (after calculation of az)%%Based on codes of Michalsky and Spencer, converted to IDL by P. J.  Flatau% 010318 rmr -- remove singularity at line 142.% 060630 rmr -- check the NREL SPA on the web at% www.nrel.gov/midc/solpos/spa.htm.  I did comparisons of this algorithm% with the NREL results and the agreement to spot checks is generall% within a few tenths of a degree in ze0, but az can be off for low sun% angles.%%120315 -- EPHEMERIS CHECKING:%EPHEMERIS CHECKING:%NOAA: http://www.esrl.noaa.gov/gmd/grad/solcalc/  		NREL: http://www.nrel.gov/midc/srrl%5Fbms/%Gan I. (-0.6906, 73.15)     NOAA CALCULATOR				 MATLAB ephem*			NREL CALCULATOR%	2011-12-21 	060000		146.36	62.3	27.7		146.352		27.679		146.3708	27.692%		"      	070000      176.9	67.23	22.8		176.909		22.755		176.919		22.772%		"		080000		209.3	63.67	26.33		209.317		26.318		209.311		26.335			219.437	25.197%		"		120000		245.86	15.29	74.71		245.872		74.709		245.862		74.716%Around Zero                              NOAA CALCULATOR 	MATLAB ephem 	  		PERL				%	0.0  0.0  2011-09-21	12000000	293.26	1.85   		293.219 	1.85		293.22	1.86 	√	%	2.0  0.0      "				"		233.18	2.12		233.364		2.11		233.36	2.12 	√%   -2.0  0.0  		"			"		328.12	3.21		328.012		3.21		211.89	3.22 	√%   40.0	 0.0		"			"		182.68	39.29		182.692		39.282		182.69	39.29 	√%  -40.0  0.0   		"			"		357.4	49.26		357.381		40.74		182.61	40.74 	*%* 120315--Fixed the az calculation in ephem% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TEST%clear, lat = -70; lon = 100; year = 2000; day = 172; hour = [0:23]';%fprintf('Ephem(): \n'); keyboard %TEST[year, jdf] = dt2jdf(dt);day = fix(jdf);hour = rem(jdf,1) .* 24;twopi = 2. .* pi;d2r = pi ./ 180.;% get the current Julian datedelta = year - 1949.;leap = fix( delta ./ 4. );jd = 32916.5 + delta .* 365. + leap + day + hour ./ 24.;% calculate ecliptic coordinatestime = jd - 51545.0;% force mean longitude between 0 and 360 degsmnlong = 280.460 + 0.9856474 .* time;mnlong = rem(mnlong,360);%if mnlong < 0,         mnlong = mnlong + 360.;         endix = find( mnlong < 0);if length(ix) > 0        mnlong(ix) = mnlong(ix) + 360;end% mean anomaly in radians between 0, 2*pimnanom = 357.528 + 0.9856003 .* time;mnanom = rem(mnanom,360);%if mnanom < 0, mnanom = mnanom + 360;          endix = find( mnanom < 0);if length(ix) > 0        mnanom(ix) = mnanom(ix) + 360;endmnanom = mnanom .* d2r;% compute ecliptic longitude and obliquity of ecliptic%eclong=mnlong+1.915*(mnanom)+0.20*sin(2.*mnanom);eclong = mnlong + 1.915 .* sin(mnanom) + 0.020 .* sin(2 .* mnanom);eclong = rem(eclong,360);%if eclong < 0,         eclong = eclong + 360;          endix = find( eclong < 0);if length(ix) > 0        eclong(ix) = eclong(ix) + 360;endoblqec = 23.429 - 0.0000004 .* time;eclong = eclong .* d2r;oblqec = oblqec .* d2r;%calculate right ascention and declinationnum = cos(oblqec) .* sin(eclong);den = cos(eclong);ra = atan(num ./ den);% force ra between 0 and 2*pi% if den < 0,%       ra = ra + pi;% elseif num < 0,%       ra = ra + twopi;% endix = find( den < 0);iy = find( den >= 0);if length(ix) > 0        ra(ix) = ra(ix) + pi;endif length(iy) > 0        ra(iy) = ra(iy) + twopi;end%dec in radiansdec = asin( sin(oblqec) .* sin(eclong) );%calculate Greenwich mean sidereal time in hoursgmst = 6.697375 + 0.0657098242 .* time + hour;% hour not changed to sidereal sine "time" includes the fractional daygmst = rem(gmst,24);%if gmst < 0,    gmst = gmst + 24;  endix = find( gmst < 0);if length(ix) > 0        gmst(ix) = gmst(ix) + 24;end% calculate local mean sidereal time in radianslmst = gmst + lon ./ 15;lmst = rem(lmst, 24);%if lmst < 0,    lmst = lmst + 24;              endix = find( lmst < 0 );if length(ix) > 0        lmst(ix) = lmst(ix) + 24;endlmst = lmst .* 15 .* d2r;% calculate hour angle in radians between -pi, piha = lmst - ra;ix = find( ha < -pi);if length(ix) > 0        ha(ix) = ha(ix) + twopi;endix = find( ha > pi);if length(ix) > 0        ha(ix) = ha(ix) - twopi;endlat = lat * d2r;% ELEVATIONx=sin(dec) .* sin(lat) + cos(dec) .* cos(lat) .* cos(ha);el = asin( x );%fprintf('dec=%.4f   ha=%.4f\n',dec,ha);%fprintf('x=%.4f   el=%.4f\n',x,el);% AZIMUTHgamma= sin(ha) ./ (cos(ha).*sin(lat)-tan(dec).*cos(lat));gamma = atan(gamma);az=gamma+pi;fprintf('HA=%.4f  GAMMA=%.4f   AZ=%.3f   ZE=%.3f\n',ha, gamma, az/d2r,90-el/d2r);if  ha  >  0 & gamma < 0,	az=az+pi;endif ha < 0 & gamma > 0,	az=az+pi;end%%%%%%%%%%%%%% REFRACTION%%%%%%%%%%%%%%% this puts azimuth between 0 and 2*pi radians% calculate refraction correction for US stand. atm.el = el / d2r;refrac = 0.56 .* ones(size(el));ix = find(el > -.56);if length(ix) > 0        refrac(ix) = 3.51561 .* (0.1594 + 0.0196 .* el(ix) + 0.00002 .* el(ix) .^2) ./...                (1 + 0.505 .* el(ix) + 0.0845 .* el(ix) .^ 2);endze0 = 90-el; % TESTze = 90 - (el + refrac);az = az ./d2r;az = CompassCheck(az);return