function outname = remove_curvature_from_map(R1MeshName,CurvatureMeshName,outname,fitorder)
% Syntax : outname = remove_curvature_from_map(R1MeshName,CurvatureMeshName,outname,fitorder);
% This function removes the curvatures in the gifti mesh "CurvatureMeshName" from the R1 values in
% "R1MeshName" by means a general linear model of order "fitorder" if
% outname is not specified, or left empty "outname" will be similar to
% "R1MeshName" with "curvcor" inserted after the "mesh." prefix.

if nargin <3
    basename    = spm_file(R1MeshName,'basename');
    direc       = spm_file(R1MeshName,'path');
    outname     = [direc filesep basename(1:findstr(basename,'mesh.')+length('mesh')) 'curvcor' basename(1+findstr(basename,'mesh.')+length('mesh'):end) '.gii'];
end

if nargin<4
    fitorder = 1;
end

% Load the R1 surface values
R1      = [];
r1      = gifti(R1MeshName);
R1      = double(r1.cdata);

% Load the Curvature vector
cu      = gifti(CurvatureMeshName);
C       = double(cu.cdata);


%find indices for finite values
idx=find(isfinite(C).*isfinite(R1));

%Construct the Designmatrix X
X       = ones(size(C(idx)));

for order = fitorder:-1:1
    X   = [C(idx).^order X];
end


% Estimate linear curvature vs R1 fit
beta        = X\R1(idx);

% Make sure not to regress the mean value out
beta(end)   = 0;

% Remove curvature trend from data
R1Corr      = R1;
R1Corr(idx) = R1(idx)-((X*beta));

% Save the curvature corrected values in gifti format

g           = gifti;
g.mat       = cu.mat;
g.vertices  = double(cu.vertices);
g.faces     = double(cu.faces);
g.cdata     = R1Corr;
save(g,outname);
