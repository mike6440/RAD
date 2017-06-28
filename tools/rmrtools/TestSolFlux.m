% TestSolFluxclearhrflt = [0:.1:24]';  uone = ones(size(hrflt));%alat = 40.8667 .* uone;		alon = -72.87817 .* uone;  	% BNLalat = 0 .* uone;		alon = 148 .* uone;  				% TWP%MM = 5 .* uone;   dd = 28 .* uone;  		% jd 148%MM = 2 .* uone;   dd = 6 .* uone;  			% jd 34MM = 3 .* uone;   dd = 10 .* uone;  		% equinoxmm = 0 .* uone;		ss = mm;yyyy = 1997 .* uone;jd = julian(yyyy,MM,dd) - julian(yyyy,1,1) + 1;% MINNETT/REYNOLDS fprintf('SolarRadiance\n');[s1, z1, a1] = solarradiance(alat, alon, jd, hrflt);% SOLFLUX -- MATHER ROUTINEmu = cos(z1 .* pi ./ 180);w = 5 .* ones(size(mu));			% int. water vapor (g/cm^2), typically 5 in TWPfprintf('solflux\n');[En, Ed] = SolFlux(mu,w);%  PLOT THE RESULTSfigure;subplot(2,1,1);plot(hrflt,s1,'r');set(gca,'xlim',[0,24],'xtick',[0,3,6,9,12,15,18,21,24]);grid;title('SolarRadiance flux');subplot(2,1,2);plot(hrflt,En,'b',hrflt,Ed,'r');set(gca,'xlim',[0,24],'xtick',[0,3,6,9,12,15,18,21,24]);grid;title('SolFlux: Direct (red) and Diffuse (blue)');return