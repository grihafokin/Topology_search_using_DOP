% DOP processing function according to the given requirements
function [dops, inds, mininds, maxinds, gNBdop, dn, dphi1n, hn] = ...
    dop_process(dop, gNB, UE, mindop, maxdop)
[dops, inds] = sort(dop); gNB = gNB(:,:,inds);
if min(dops)<mindop
    mindop=min(dops);
end
[~, mininds]=min(abs(dops-mindop)); [~, maxinds]=min(abs(dops-maxdop));
dops=dops(mininds:maxinds);
gNBdop = gNB(:,:,mininds:maxinds); dgNB = gNBdop - UE; 
% finding horizontal distances between gNB and UE
dn = squeeze(sqrt(sum(dgNB(:,1:2,:).^2, 2))); 
% finding azimuth angles between gNB and UE
phin = squeeze(wrapTo360(atan2d(dgNB(:,2,:), dgNB(:,1,:))));
dphi1n = wrapTo360(phin(2:end,:) - phin(1,:));
% finding gNB heights
hn = squeeze(gNBdop(:,3,:));
end