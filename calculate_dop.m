% calculation PDOP, HDOP, VDOP using TOA, TDOA, AOA, TOA-AOA, TDOA-AOA
% measurement processing
function [pdop, hdop, vdop] = calculate_dop(gNB, UE, calc_case)
% gNB - gNB coordinate vector
% UE - UE coordinate vector
n = size(gNB, 1);                 % gNB number
dim=size(gNB, 2);                 % dimension 3D
r=sqrt(sum((UE-gNB).^2,2));       % ranges between gNB and UE
% TOA matrix of partial derivatives with respect to xyz coordinates
H_TOA=(UE-gNB)./r;
% TDOA matrix of partial derivatives with respect to xyz coordinates
H_TDOA=zeros(n-1, dim);
H_TOA2=H_TOA(2:n,:); % H_TOA2=(UE-gNB(2:n,:))./r(2:n); 
H_TOA1=H_TOA(1,:);   % H_TOA1=(UE-gNB(1,:))./r(1);
H_TDOA=H_TOA2-H_TOA1;
    
% DOA matrix of partial derivatives with respect to xyz coordinates
gNB2D=gNB; gNB2D(:,3)=0; UE2D=UE; UE2D(:,3)=0; 
r2D=sqrt(sum((UE2D-gNB2D).^2,2));
% for this case, the rows of the matrix H are not normalized to 1
H_DOA2D = zeros(n,dim); 
H_DOA2D(:,1) = -(UE(:,2)-gNB(:,2))./(r2D.^2);
H_DOA2D(:,2) =  (UE(:,1)-gNB(:,1))./(r2D.^2);
H_DOA3D = zeros(n,dim); 
H_DOA3D(:,1)=-(((UE(:,3)-gNB(:,3)).*(UE(:,1)-gNB(:,1)))./(r.^2))./r2D;
H_DOA3D(:,2)=-(((UE(:,3)-gNB(:,3)).*(UE(:,2)-gNB(:,2)))./(r.^2))./r2D;
H_DOA3D(:,3)=r2D./(r.^2);
H_DOA=[H_DOA2D; H_DOA3D];
% for this case, the rows of the matrix H are normalized to 1 (option 1)
azAng = atan2(UE(2)-gNB(:,2), UE(1)-gNB(:,1)); % azimuth angle
H_DOA2D_1 = [-sin(azAng), cos(azAng), zeros(size(gNB(:,1)))];    
elAng = atan((UE(3)-gNB(:,3))./r2D);           % elevation angle
H_DOA3D_1 = [sin(elAng).*(UE(1) - gNB(:,1))./r2D, ...
             sin(elAng).*(UE(2) - gNB(:,2))./r2D, ...
             cos(elAng)];
H_DOA_1 = [H_DOA2D_1; H_DOA3D_1];
             
% for this case, the rows of the matrix H are normalized to 1 (option 2)
H_DOA2D_2 = zeros(n,dim); 
% is calculated as H_DOA2D, but there is no division by r2D
H_DOA2D_2(:,1) = -(UE(:,2)-gNB(:,2))./r2D;
H_DOA2D_2(:,2) =  (UE(:,1)-gNB(:,1))./r2D;
H_DOA3D_2 = zeros(n,dim);
% is calculated as H_DOA3D, but there is no division by r
H_DOA3D_2(:,1)=-((UE(:,3)-gNB(:,3)).*(UE(:,1)-gNB(:,1)))./r./r2D;
H_DOA3D_2(:,2)=-((UE(:,3)-gNB(:,3)).*(UE(:,2)-gNB(:,2)))./r./r2D; 
H_DOA3D_2(:,3)=r2D./r;
H_DOA_2=[H_DOA2D_2; H_DOA3D_2];             
% choice of calculation method
if calc_case==    'TOA     '
    H=H_TOA;
elseif calc_case=='TDOA    '
    H=H_TDOA;
elseif calc_case=='DOA     '
    H=H_DOA_1;
elseif calc_case=='TOA-DOA '
    H=[H_TOA; H_DOA_1];
elseif calc_case=='TDOA-DOA'
    H=[H_TDOA; H_DOA_1];
end
% DOP matrix calculation
G = pinv(H'*H);
pdop = sqrt(G(1,1) + G(2,2) + G(3,3)); 
hdop = sqrt(G(1,1) + G(2,2));          
vdop = sqrt(G(3,3));                  
end