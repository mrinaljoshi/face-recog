function PCA_recog(subDim)
 
global imloadfunc;

imloadfunc =  'pgma_read'; 

disp(' ')
load Database
DATA = Database;                           % creates the data n stores in variable DATA.

save DATA DATA;

[imSize, numImages] = size(DATA);

dim = numImages;                           % Creating database images space
imSpace = zeros (imSize, dim);

for i = 1 : dim
    imSpace(:, i) = DATA(:, i);
end;
save imSpace imSpace;
clear DATA;

fprintf('Zero mean\n')                      % Calculating mean face from database
psi = mean(double(imSpace'))';
save psi psi;

zeroMeanSpace = zeros(size(imSpace));       % Zero mean
for i = 1 : dim
    zeroMeanSpace(:, i) = double(imSpace(:, i)) - psi;
end;
save zeroMeanSpace zeroMeanSpace;
clear imSpace;

fprintf('PCA\n')                            % PCA
L = zeroMeanSpace' * zeroMeanSpace;         % From equations (7) and (8) of the report
[eigVecs, eigVals] = eig(L);

diagonal = diag(eigVals);
[diagonal, index] = sort(diagonal);         % sorting eigenvalues
index = flipud(index);
 
pcaEigVals = zeros(size(eigVals));
for i = 1 : size(eigVals, 1)
    pcaEigVals(i, i) = eigVals(index(i), index(i));
    pcaEigVecs(:, i) = eigVecs(:, index(i));
end;

pcaEigVals = diag(pcaEigVals);
pcaEigVals = pcaEigVals / (dim-1);
pcaEigVals = pcaEigVals(1 : subDim);        % Retaining only the largest subDim ones

pcaEigVecs = zeroMeanSpace * pcaEigVecs;    % Concept explained in report

save pcaEigVals pcaEigVals;

fprintf('Normalising\n')                    % Normalisation to unit length
for i = 1 : dim
    pcaEigVecs(:, i) = pcaEigVecs(:, i) / norm(pcaEigVecs(:, i));
end;
save pcaEigVecs pcaEigVecs;
 
fprintf('Creating lower dimensional subspace\n')  % Dimensionality reduction.
w = pcaEigVecs(:, 1:subDim);
save w w;
clear w;

load DATA;                                   % Subtract mean face from all images
load psi;
zeroMeanDATA = zeros(size(DATA));
for i = 1 : size(DATA, 2)
    zeroMeanDATA(:, i) = double(DATA(:, i)) - psi;
end;
clear psi;
clear DATA;

% Project all images onto a new lower dimensional subspace (w)
fprintf('Projecting all images onto a new lower dimensional subspace\n')
load w;
pcaProj = w' * zeroMeanDATA;                % Stored projections of database images on lower subdimensional subspace
clear w;
clear zeroMeanDATA; 
save pcaProj pcaProj;

