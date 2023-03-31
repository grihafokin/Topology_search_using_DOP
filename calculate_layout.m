% function for calculating gNB coordinates from probable topology parameter
function [gNB_m]=calculate_layout(dn_m, hdphi1n_m, hn_m)
n = length(dn_m);
phi_m = [225, mod(225 + hdphi1n_m, 360)];
gNB_m = zeros(n, 3);
for i=1:n
    gNB_m(i, :) = (rotz(phi_m(i))*[dn_m(i); 0; hn_m(i)]).';
end   
end