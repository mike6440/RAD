function [s,d] = VecV2P( x, y);%---------------------------------------------------------------------------%function [s,d] = VecV2P( x, y);%VECV2P = convert true vector components to polar coordinates.%The vector components are the components of the%vector and thus are in the direction of motion.  A true vector%sense.%INPUT% x,y are vector components%OUTPUT% s = speed (magnitude)% d = direction, (to)%%reynolds 070924% rmr 080713%---------------------------------------------------------------------------r2d = 180 / pi;s = sqrt(x .^ 2 + y .^ 2);d = atan2(x,y) * r2d;ix = find(d < 0);if length(ix) > 0	d(ix) = d(ix) + 360 * ones(size(ix));endreturn