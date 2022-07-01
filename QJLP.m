function [qjlp_vec] = QJLP(uni_zonecod,innvec,f,p,q)
%QJLP  randomized response(QJLP)
%____________________________________________________________________________
%input: uni_zonecod,innvec,f,q,p
%output:qjlp_vec
%   uni_zonecod: united zone code 
%   innvec:                 inner one-hot vector of QJLP 
%   qjlp_vec:       perturbed inner one-hot vector 
%   f,q,p:          flip factor
%   response:   after LDP response to server
%____________________________________________________________________________
%get response vector uasing perturbation vectors by basic rappor
[innvec,qjlp_vec] = basicrappor(innvec,f,p,q);
response=[uni_zonecod qjlp_vec];%response to server
end