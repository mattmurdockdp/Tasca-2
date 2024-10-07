function [DisplacementDiff, StressDiff] = testResults(u,sig)

OriginalResults  = load('OriginalResults.mat'); 

DisplacementDiff = norm(u - OriginalResults.u);

StressDiff       = norm(sig - OriginalResults.sig);

end