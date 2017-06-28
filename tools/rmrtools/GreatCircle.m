function [dx, B1, B2] = GreatCircle(l1,m1,l2,m2)%function [dx, B1, B2] = GreatCircle(l1,m1,l2,m2)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Compute the great circle distances and bearings%between two points on the Earth.%input% l1,m1 = lat and lon of the ship.% l2,m2 = lat lon of the reference (destination).%%output% dx = distance in m% B1 = compass heading for ship.% B2 = compass heading at reference.%%see http://daniel.calpoly.edu/~dfrc/Robin/GPS/bearing.html%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% clear% l2 = 0.5;% m2 = 167;% % m1 = [m2-1:.1:m2+1]';% npts = length(m1);% l1 = .6 * ones(npts,1);% l2 = l2 * ones(npts,1); % m2 = m2 * ones(npts,1);d2r = pi / 180;l1r = l1 * d2r;  l2r = l2 * d2r;m1r = m1 * d2r;  m2r = m2 * d2r;delm = abs(m2 - m1);delmr = delm * d2r;cosd = sin(l1r) .* sin(l2r) + cos(l1r) .* cos(l2r) .* cos(delmr);dr = acos(cosd);sind = sin(dr);%  GS DISTANCE IN METERSdx = 1.111e5 / d2r * dr;cosB1 = sin(l2r) - sin(l1r) .* cosd;% sinB1 = (cos(l2r) .* sin(delmr)) ./ sind;% sinB2 = (sin(l2r) - (sin(l1r) .* cosd)) ./ (cos(l1r) .* sind);% % B1r = asin(sinB1);% B2r = asin(sinB2);cosB1 =( sin(l2r) - sin(l1r) .* cosd) ./ (cos(l1r) .* sind);cosB2 = ( sin(l1r) - sin(l2r) .* cosd) ./ (cos(l2r) .* sind);B1r = acos(cosB1);B2r = acos(cosB2);B1 = B1r ./ d2r;B2 = -B2r ./ d2r;% CORRECTIONS%WESTWARD TRAVELix = find(m1 > m2);if length(ix) > 0	B1(ix) = -B1(ix);	B2(ix) = -B2(ix);endB1 = compasscheck(real(B1));B2 = compasscheck(real(B2));return