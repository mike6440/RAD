function Rose_plain(ws,wd,fg, ax, fontname, title1)%function Rose_plain(ws,wd,fg, ax, fontname, title1) -- plot a wind rose for given speed and direction%INPUT%  ws = wind speed% wd = wind direction, met convention% fg, ax are the handles for the figure and the axis% fontname is the font desired.% title1 = a title string%% 030320 - Remove all missing data from percentages% 031206 rmr Nok/Calm/VRB/BAD = no.pts./pcnt calm / pcnt vrb / pcnt missing% 	for we count nans.  wdir(VRB)=-998;  wdir(BAD)=NaN;% v104 060621 rmr -- cosmetic changes, adjust percent circles to keep the plot%    square% rmr 090527 fix for bnlmet to be identical input to Rose.md2r = pi / 180;% ws = wind speed% wd = wind direction% ORIGINAL SERIES LENGTHnpts = length(wd);% SET UP THE BINSx1 = [0; 11.25; [33.75:22.5:348.75]'];x2 = [[11.25:22.5:360]'; 360];% HOW MANY BAD POINTS. OR MISSING, OR NANix = find(isnan(wd));Nbad = length(ix);pcntbad = 100 * Nbad / npts;fprintf('PERCENT BAD = %.1f\n',pcntbad);% HOW MANY VRB DIRECTIONS, COUNT THEN SET TO NAN	ix = find(wd == -998);Nvrb=0;if length(ix) > 0	Nvrb = length(ix);	wd(ix)=NaN;endpcntvrb = 100 * Nvrb / npts;fprintf('PERCENT VRB = %.1f\n',pcntvrb);% FIND ALL CALM CONDITIONSix = find( ws == 0);Ncalm = 0;if length(ix) > 0,    Ncalm = length(ix);	wd(ix)=NaN;endpcntcalm = 100 * Ncalm / npts;fprintf('PERCENT CALM = %.1f\n',pcntcalm);% MAKE A VECTOR WITH ALL BAD DIRECTIONS REMOVEDws1 = ws;  [v, ix] = ScrubSeries(wd,[0;360]);if ~isnan(ix(1)),	ws1(ix) = []; end% NEW CLEANED LENGTHnpts = length(v);% FIND NUMBER OF DIRECTIONS IN EACH BINin = [];for ibin = 1:17,	in = [in; length(find(v >= x1(ibin) & v < x2(ibin) ))];end% COMBINE BINS 1 AND 17 INTO NORTH BINin(1) = in(1) + in(17);in(17) = [];% CONVERT TO PERCENTAGEStotal = length(wd);  % 030320 - percent of all data, not just good data.  sum(in);total = Nvrb + Ncalm + npts;  % v104 - percentages are based on real datain = in ./ total .* 100;% COMPUTE PERCENT CIRCLES BASED ON MAXIMUM BINinmax = max(ScrubSeries(in));pcnt_circles = [5 10 15];if inmax > 17,    pcnt_circles = [5 10 15];end% theta IS THE BIN MEDIAN DIRECTION IN DEGREEStheta = [0:22.5:359]';%  ---------------  PLOTTING THE WIND ROSE ------------------------% SET UP THE PLOTTING AREA%fg = figure('position',[100 20 700 700], 'paperposition',[1 3.25 7 7]);%ax = axes('Position',[0.13 0.2 0.7 0.7]);% COMPUTE CIRCLES IN PERCENTAGESrd = [0:.1:360]' .* d2r;for radius = pcnt_circles,	xx = radius .* sin(rd);	yy = radius .* cos(rd);	plot(xx,yy,'-k');	hold onendset(ax, 'color',[1 1 1], 'xcolor','w',...	'ycolor','w');plot([0,0],[-16,16],'-k');plot([-16,16],[0,0],'-k');% PLOT EACH BINfor ibn = 1: length(in),	radius = in(ibn);	arc = [theta(ibn)-11.25:0.1:theta(ibn)+11.25]';	lnarc = length(arc);	a1 = x1(ibn);	a2 = x2(ibn);		% pb is the plotting vector	pb = [0 0];		% first point at the origin	% the arc	pb = [pb; radius .* sin(arc .* d2r), radius .* cos(arc .* d2r)];	% end point	pb = [pb; 0, 0];		ln = plot(pb(:,1),pb(:,2),'r');	set(ln,'linewidth',2);endtx = text(0,16.0,'N');set(tx,'horizontalalignment','center','verticalalignment','bottom',...	'fontsize',18,'fontweight','bold');tx = text(0,-16.0,'S');set(tx,'horizontalalignment','center','verticalalignment','top',...	'fontsize',18,'fontweight','bold');tx = text(16.0,0,'E');set(tx,'horizontalalignment','left','verticalalignment','middle',...	'fontsize',18,'fontweight','bold');tx = text(-16.0,0,'W');set(tx,'horizontalalignment','right','verticalalignment','middle',...	'fontsize',18,'fontweight','bold');% LABEL CIRCLESa1 = 5.1 .* sin(135 .* d2r);a2 = 5.1 .* cos(135 .* d2r);tx = text(a1,a2,'5%');set(tx,'horizontalalignment','left','verticalalignment','top',...	'fontsize',16,'fontweight','bold');a1 = 10.1 .* sin(135 .* d2r);a2 = 10.1 .* cos(135 .* d2r);tx = text(a1,a2,'10%');set(tx,'horizontalalignment','left','verticalalignment','top',...	'fontsize',16,'fontweight','bold');a1 = 15.1 .* sin(135 .* d2r);a2 = 15.1 .* cos(135 .* d2r);tx = text(a1,a2,'15%');set(tx,'horizontalalignment','left','verticalalignment','top',...	'fontsize',16,'fontweight','bold');%  VARIOUS LABELSstr1 = str2mat('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug');str2 = str2mat('Sep','Oct','Nov','Dec');monstr = [str1; str2];str = title1;tx = text(0,0,str);set(tx,'units','normalized','position',[.5,.95],...	'horizontalalignment','center','verticalalignment','bottom',...	'fontsize',14,'fontweight','bold');str = sprintf('Good/Clm/Vrb/Bad = %d / %.1f%% / %.1f%% / %.1f%%', length(ws), pcntcalm, pcntvrb, pcntbad);tx = text(0,0,str);set(tx,'units','normalized','position',[.5,.02],...	'horizontalalignment','center',...	'fontweight', 'bold','fontsize',14);%str = sprintf('Total Number of Readings: %d points', length(ws));%tx = text(-20,-24,str);% % set(tx,'horizontalalignment','left','verticalalignment','bottom',...% 	'fontsize',16,'fontweight','bold');% % str = sprintf('Calm %.1f%%,     Missing Data %.1f%%',...%     pcntcalm, 100 * nbad / length(ws));% % tx = text(-20,-27,str);%set(tx,'horizontalalignment','left','verticalalignment','bottom',...%	'fontsize',10,'fontweight','bold');axis('square')set(gca,'xticklabel',[]);set(gca,'xtick',[]);set(gca,'yticklabel',[]);set(gca,'ytick',[]);return;