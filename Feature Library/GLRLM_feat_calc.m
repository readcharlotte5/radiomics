function GLRLM_feat = GLRLM_feat_calc(volume, mask, dimension, scale, norm, GLRLM_type)
GLRLM_feat = zeros(16, 1);

GLRLM = GLRLM_calc(volume, mask, dimension, scale, GLRLM_type);

R = GLRLM.R;
RR = GLRLM.RR;
PP = GLRLM.PP;
i = GLRLM.i;
j = GLRLM.j;
ii = GLRLM.ii;
jj = GLRLM.jj;
Ri = GLRLM.Ri;
Rj = GLRLM.Rj;
Ns = GLRLM.Ns;
Nv = GLRLM.Nv;

no_direction = size(GLRLM.R, 3);
norm_type = norm(1);
norm_factor = norm(2);

%% TxtAna_GLRLM_SRE
SRE = Rj ./ ((j).^2);
SRE = reshape(SRE, [], no_direction);
SRE = sum(SRE, 'omitnan')./Ns;

GLRLM_feat(1) = feature_norm(SRE, norm_type, norm_factor);

%% TxtAna_GLRLM_LRE
LRE = Rj .* ((j).^2);
LRE = reshape(LRE, [], no_direction);
LRE = sum(LRE, 'omitnan')./Ns;

GLRLM_feat(2) = feature_norm(LRE, norm_type, norm_factor);

%% TxtAna_GLRLM_GLN

GLN = Ri.^2;
GLN = reshape(GLN, [], no_direction);
GLN = sum(GLN, 'omitnan')./Ns;

GLRLM_feat(3) = feature_norm(GLN, norm_type, norm_factor);

%% TxtAna_GLRLM_GLNN

GLNN = Ri.^2;
GLNN = reshape(GLNN, [], no_direction);
GLNN = sum(GLNN, 'omitnan')./Ns./Ns;

GLRLM_feat(4) = feature_norm(GLNN, norm_type, norm_factor);

%% TxtAna_GLRLM_RLN

RLN = Rj.^2;
RLN = reshape(RLN, [], no_direction);
RLN = sum(RLN, 'omitnan')./Ns;

GLRLM_feat(5) = feature_norm(RLN, norm_type, norm_factor);

%% TxtAna_GLRLM_RLNN

RLNN = Rj.^2;
RLNN = reshape(RLNN, [], no_direction);
RLNN = sum(RLNN, 'omitnan')./Ns./Ns;

GLRLM_feat(6) = feature_norm(RLNN, norm_type, norm_factor);

%% TxtAna_GLRLM_RP

RP = Ns / Nv;

GLRLM_feat(7) = feature_norm(RP, norm_type, norm_factor);

%% TxtAna_GLRLM_LGLRE

LGLRE = Ri ./ ((i).^2);
LGLRE = reshape(LGLRE, [], no_direction);
LGLRE = sum(LGLRE, 'omitnan')./Ns;

GLRLM_feat(8) = feature_norm(LGLRE, norm_type, norm_factor);

%% TxtAna_GLRLM_HGLRE

HGLRE = Ri .* ((i).^2);
HGLRE = reshape(HGLRE, [], no_direction);
HGLRE = sum(HGLRE, 'omitnan')./Ns;

GLRLM_feat(9) = feature_norm(HGLRE, norm_type, norm_factor);

%% TxtAna_GLRLM_SRLGLE

SRLGLE = RR ./ (ii.^2) ./ (jj.^2);
SRLGLE = reshape(SRLGLE, [], no_direction);
SRLGLE = sum(SRLGLE, 'omitnan')./Ns;

GLRLM_feat(10) = feature_norm(SRLGLE, norm_type, norm_factor);

%% TxtAna_GLRLM_SRHGLE

SRHGLE = RR .* (ii.^2) ./ (jj.^2);
SRHGLE = reshape(SRHGLE, [], no_direction);
SRHGLE = sum(SRHGLE, 'omitnan')./Ns;

GLRLM_feat(11) = feature_norm(SRHGLE, norm_type, norm_factor);

%% TxtAna_GLRLM_LRLGLE

LRLGLE = RR .* (jj.^2) ./ (ii.^2);
LRLGLE = reshape(LRLGLE, [], no_direction);
LRLGLE = sum(LRLGLE, 'omitnan')./Ns;

GLRLM_feat(12) = feature_norm(LRLGLE, norm_type, norm_factor);

%% TxtAna_GLRLM_LRHGLE

LRHGLE = RR .* (jj.^2) .* (ii.^2);
LRHGLE = reshape(LRHGLE, [], no_direction);
LRHGLE = sum(LRHGLE, 'omitnan')./Ns;

GLRLM_feat(13) = feature_norm(LRHGLE, norm_type, norm_factor);

%% TxtAna_GLRLM_VarGL
mu = PP .* ii;
mu = reshape(mu, [], no_direction);
mu = sum(mu, 'omitnan');
mu = repmat(mu, size(R, 1)*size(R, 2), 1);
mu = mu(:);

VarGL = (ii - mu) .^ 2 .* PP;
VarGL = reshape(VarGL, [], no_direction);
VarGL = sum(VarGL, 'omitnan');

GLRLM_feat(14) = feature_norm(VarGL, norm_type, norm_factor);

%% TxtAna_GLRLM_VarRL

mu = PP .* jj;
mu = reshape(mu, [], no_direction);
mu = sum(mu, 'omitnan');
mu = repmat(mu, size(R, 1)*size(R, 2), 1);
mu = mu(:);

VarRL = (jj - mu) .^ 2 .* PP;
VarRL = reshape(VarRL, [], no_direction);
VarRL = sum(VarRL, 'omitnan');

GLRLM_feat(15) = feature_norm(VarRL, norm_type, norm_factor);

%% TxtAna_GLRLM_RE

RE = - PP .* log2(PP);
RE = reshape(RE, [], no_direction);
RE = sum(RE, 'omitnan');

GLRLM_feat(16) = feature_norm(RE, norm_type, norm_factor);
end