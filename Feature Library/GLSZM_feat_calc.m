function GLSZM_feat = GLSZM_feat_calc(volume, mask, scale)
GLSZM_feat = zeros(16, 1);

GLSZM = GLSZM_calc(volume, mask, scale);

S = GLSZM.S;
SS = GLSZM.SS;
i = GLSZM.i;
j = GLSZM.j;
ii = GLSZM.ii;
jj = GLSZM.jj;
Si = GLSZM.Si;
Sj = GLSZM.Sj;
Ns = GLSZM.Ns;
Nv = GLSZM.Nv;

%% TxtAna_GLSZM_SZE

SZE = Sj ./ ((j).^2);
SZE = sum(SZE, 'omitnan')./Ns;

GLSZM_feat(1) = SZE;

%% TxtAna_GLSZM_LZE

LZE = Sj .* ((j).^2);
LZE = sum(LZE, 'omitnan')./Ns;

GLSZM_feat(2) = LZE;

%% TxtAna_GLSZM_GLN

GLN = Si.^2;
GLN = sum(GLN, 'omitnan')./Ns;

GLSZM_feat(3) = GLN;

%% TxtAna_GLSZM_GLNN

GLNN = Si.^2;
GLNN = sum(GLNN, 'omitnan')./Ns./Ns;

GLSZM_feat(4) = GLNN;

%% TxtAna_GLSZM_SZN

SZN = Sj.^2;
SZN = sum(SZN, 'omitnan')./Ns;

GLSZM_feat(5) = SZN;

%% TxtAna_GLSZM_SZNN

SZNN = Sj.^2;
SZNN = sum(SZNN, 'omitnan')./Ns./Ns;

GLSZM_feat(6) = SZNN;

%% TxtAna_GLSZM_SP

SP = sum(Ns) ./ Nv;

GLSZM_feat(7) = SP;

%% TxtAna_GLSZM_LGLSE

LGLSE = Si ./ ((i).^2);
%LGLSE = reshape(LGLSE, [], no_direction);
LGLSE = sum(LGLSE, 'omitnan')./Ns;

GLSZM_feat(8) = LGLSE;

%% TxtAna_GLSZM_HGLSE

HGLSE = Si .* ((i).^2);
HGLSE = sum(HGLSE, 'omitnan')./Ns;

GLSZM_feat(9) = HGLSE;

%% TxtAna_GLSZM_SSLGLE

SSLGLE = SS ./ (jj.^2) ./ (ii.^2) ;
SSLGLE = sum(SSLGLE, 'omitnan')./Ns;

GLSZM_feat(10) = SSLGLE;

%% TxtAna_GLSZM_SSHGLE

SSHGLE = ii.^2 .* SS ./ (jj.^2);
SSHGLE = sum(SSHGLE, 'omitnan')./Ns;

GLSZM_feat(11) = SSHGLE;

%% TxtAna_GLSZM_LSLGLE

LSLGLE = jj.^2 .* SS ./ (ii.^2);
LSLGLE = sum(LSLGLE, 'omitnan')./Ns;

GLSZM_feat(12) = LSLGLE;

%% TxtAna_GLSZM_LSHGLE

LSHGLE = ii.^2 .* jj.^2 .* SS;
LSHGLE = sum(LSHGLE, 'omitnan')./Ns;

GLSZM_feat(13) = LSHGLE;

%% TxtAna_GLSZM_VarGL

mu = sum(SS ./ Ns .* ii, 'omitnan');
VarGL = sum( (ii - mu).^2 .* (SS ./ Ns), 'omitnan');

GLSZM_feat(14) = VarGL;

%% TxtAna_GLSZM_VarZS

mu = sum(SS ./ Ns .* jj, 'omitnan');
VarZS = sum( (jj - mu).^2 .* (SS ./ Ns), 'omitnan'); 

GLSZM_feat(15) = VarZS;

%% TxtAna_GLSZM_SE

P = SS ./ Ns;

SE = - P .* log2(P);
SE = sum(SE, 'omitnan');

GLSZM_feat(16) = SE;

end