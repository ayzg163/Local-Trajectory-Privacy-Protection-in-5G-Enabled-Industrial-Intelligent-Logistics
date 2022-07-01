function [qlp_vec] = QLP(uni_zonecod,con_innvec,f,p,q)
%QLP  randomized response(QLP)
%____________________________________________________________________________
%input: uni_zonecod,con_innvec,f,q,p
%output:qlp_vec
%   uni_zonecod: united zone code
%   con_innvec:             connected inner one-hot vector of QLP
%   f,q,p:          flip factors
%   qlp_vec      perturbed inner one-hot vector 
%   response:    after LDP response to server

%____________________________________________________________________________

%get response vector uasing perturbation vectors by basic rappor
[con_innvec,qlp_vec] = basicrappor(con_innvec,f,p,q);
response=[uni_zonecod qlp_vec];%response to server

end