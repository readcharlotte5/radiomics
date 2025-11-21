function GLCOM_feat = GLCOM_feat_calc(volume, mask, dimension, scale, norm, GLCOM_type)
GLCOM_feat = zeros(22, 1);

GLCOM = GLCOM_calc(volume, mask, dimension, scale, GLCOM_type);

P = GLCOM.P;
PP = GLCOM.PP;
ii = GLCOM.ii;
jj = GLCOM.jj;
Pimj = GLCOM.Pimj;
Pipj = GLCOM.Pipj;
k1 = GLCOM.k1;
k2 = GLCOM.k2;
ux = GLCOM.ux;
uy = GLCOM.uy;

no_direction = size(P, 3);
norm_type = norm(1);
norm_factor = norm(2);

%% TxtAna_GLCOM_AutoCorrelation
 
AC = ii .* jj.* PP;
AC = reshape(AC, [], no_direction);
AC = sum(AC, 'omitnan');

GLCOM_feat(1) = feature_norm(AC, norm_type, norm_factor);
 
%% TxtAna_GLCOM_ClusterProminence
CP = (ii + jj - ux - uy).^4 .* PP;
CP = reshape(CP, [], no_direction);
CP = sum(CP, 'omitnan');
 
GLCOM_feat(2) = feature_norm(CP, norm_type, norm_factor);
 
%% TxtAna_GLCOM_ClusterShade
CS = (ii + jj - ux - uy).^3 .* PP;
CS = reshape(CS, [], no_direction);
CS = sum(CS, 'omitnan');
 
GLCOM_feat(3) = feature_norm(CS, norm_type, norm_factor);
 
%% TxtAna_GLCOM_ClusterTendency
CT = (ii + jj -  ux - uy).^2 .* PP;
CT = reshape(CT, [], no_direction);
CT = sum(CT, 'omitnan');
 
GLCOM_feat(4) = feature_norm(CT, norm_type, norm_factor);
 
%% TxtAna_GLCOM_Contrast
C = (ii - jj).^2 .* PP;
C = reshape(C, [], no_direction);
C = sum(C, 'omitnan');
 
GLCOM_feat(5) = feature_norm(C, norm_type, norm_factor);
 
%% TxtAna_GLCOM_Correlation
ux_local = ii .* PP;
ux_local = reshape(ux_local, [], no_direction);
ux_local = sum(ux_local, 'omitnan');
uy_local = ux_local;
 
sigma_x = (ii - ux).^2 .* PP;
sigma_x = reshape(sigma_x, [], no_direction);
sigma_x = sqrt(sum(sigma_x, 'omitnan'));
sigma_y = sigma_x;
 
CL = (ii .* jj.* PP);
CL = reshape(CL, [], no_direction);
CL = sum(CL, 'omitnan');
 
CL = (CL - ux_local.*uy_local) ./ sigma_x./sigma_y;
CL(isnan(CL)) = 0;
 
GLCOM_feat(6) = feature_norm(CL, norm_type, norm_factor);
 
%% TxtAna_GLCOM_DiffEntropy
DE = -Pimj .* log2(Pimj);
DE = sum(DE, 'omitnan');
 
GLCOM_feat(7) = feature_norm(DE, norm_type, norm_factor);
 
%% TxtAna_GLCOM_Dissimilarity
DS = abs(ii - jj) .* PP;
DS = reshape(DS, [], no_direction);
DS = sum(DS, 'omitnan');
 
GLCOM_feat(8) = feature_norm(DS, norm_type, norm_factor);
 
%% TxtAna_GLCOM_Energy
E = PP.^2;
E = reshape(E, [], no_direction);
E = sum(E);
 
GLCOM_feat(9) = feature_norm(E, norm_type, norm_factor);
 
%% TxtAna_GLCOM_Entropy
EH = PP .* log2(PP);
EH(isnan(EH)) = 0;
EH(isinf(EH)) = 0;
EH = reshape(EH, [], no_direction);
EH = -sum(EH);
 
GLCOM_feat(10) = feature_norm(EH, norm_type, norm_factor);
 
%% TxtAna_GLCOM_Homogeneity_1
H1 = PP ./ (1 + abs(ii - jj));
H1(H1==Inf) = 0;
H1(isnan(H1)) = 0;
H1 = reshape(H1, [], no_direction);
H1 = sum(H1);
 
GLCOM_feat(11) = feature_norm(H1, norm_type, norm_factor);
 
%% TxtAna_GLCOM_Homogeneity_2
H2 = PP ./ (1 + abs(ii - jj).^2);
H2(H2==Inf) = 0;
H2(isnan(H2)) = 0;
H2 = reshape(H2, [], no_direction);
H2 = sum(H2);
 
GLCOM_feat(12) = feature_norm(H2, norm_type, norm_factor);
 
%% TxtAna_GLCOM_IMC1
P_sum = sum(P);
P_sum = P_sum(:);
 
HXY1 = - PP .* log2(P_sum(ii) .* P_sum(jj));
HXY1 = reshape(HXY1, [], no_direction);
HXY1 = sum(HXY1, 'omitnan');
 
HX = - P_sum .* log2(P_sum);
HX = reshape(HX, [], no_direction);
HX = sum(HX, 'omitnan');
 
HXY = - PP .* log2(PP);
HXY = reshape(HXY, [], no_direction);
HXY = sum(HXY, 'omitnan');
 
IMC1 = (HXY - HXY1)./HX;
IMC1(isnan(IMC1)) = 0;
IMC1(isinf(IMC1)) = 0;
 
GLCOM_feat(13) = feature_norm(IMC1, norm_type, norm_factor);
 
%% TxtAna_GLCOM_IMC2
P_sum = sum(P);
P_sum = P_sum(:);
 
HXY2 = - P_sum(ii) .* P_sum(jj) .* log2(P_sum(ii) .* P_sum(jj));
HXY2 = reshape(HXY2, [], no_direction);
HXY2 = sum(HXY2, 'omitnan');
 
HXY = - PP .* log2(PP);
HXY = reshape(HXY, [], no_direction);
HXY = sum(HXY, 'omitnan');
 
IMC2 = sqrt(1-exp(-2*(HXY2 - HXY)));
IMC2(imag(IMC2) ~=0) = 0;
 
GLCOM_feat(14) = feature_norm(IMC2, norm_type, norm_factor);
 
%% TxtAna_GLCOM_IDMN
Ng = size(P, 1);
 
IDMN = PP ./ (1 + (ii-jj).^2 /Ng/Ng);
IDMN = reshape(IDMN, [], no_direction);
IDMN = sum(IDMN, 'omitnan');
 
GLCOM_feat(15) = feature_norm(IDMN, norm_type, norm_factor);
 
%% TxtAna_GLCOM_IDM
IDN = PP ./ (1 + abs(ii-jj)/Ng);
IDN = reshape(IDN, [], no_direction);
IDN = sum(IDN, 'omitnan');
 
GLCOM_feat(16) = feature_norm(IDN, norm_type, norm_factor);
 
%% TxtAna_GLCOM_InverseVariance
IV = PP ./ ((ii-jj).^2);
IV(IV == Inf) = 0;
IV(isnan(IV)) = 0;
IV = reshape(IV, [], no_direction);
IV = sum(IV, 'omitnan');
 
GLCOM_feat(17) = feature_norm(IV, norm_type, norm_factor);
 
%% TxtAna_GLCOM_MaximumProbability
MP = reshape(PP, [], no_direction);
MP = max(MP);
 
GLCOM_feat(18) = feature_norm(MP, norm_type, norm_factor);
 
%% TxtAna_GLCOM_SumAve
SA = sum(k2 .* Pipj, 'omitnan');
GLCOM_feat(19) = feature_norm(SA, norm_type, norm_factor);
 
%% TxtAna_GLCOM_SumEntropy
SE = Pipj .* log2(Pipj);
SE = -sum(SE, 'omitnan');
 
GLCOM_feat(20) = feature_norm(SE, norm_type, norm_factor);
 
%% TxtAna_GLCOM_SumVariance
SA = sum(k2 .* Pipj, 'omitnan');
SV = sum((k2 - SA).^2 .* Pipj, 'omitnan');
 
GLCOM_feat(21) = feature_norm(SV, norm_type, norm_factor);

%% TxtAna_Joint_Variance
JV = (ii - ux).^2 .* PP;
JV(JV==Inf) = 0;
JV(isnan(JV)) = 0;
JV = reshape(JV, [], no_direction);
JV = sum(JV);

GLCOM_feat(22) = feature_norm(JV, norm_type, norm_factor);
end