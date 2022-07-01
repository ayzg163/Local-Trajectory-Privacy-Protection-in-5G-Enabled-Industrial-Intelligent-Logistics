function [vec,permute_vec,turnover] = one_timerappor(vec,f)
%basicrappor:Permanent random response(LDP)
%____________________________________________________________________________
%input: vec f
%output:vec permute_vec turnover
%   vec:input vector
%   f:flip factor
%   turnover:vec flipped vector by flip factor
%   permute_vec:output vector after perturbation by Permanent random response 
%____________________________________________________________________________
% Permanent random response
turnover=rand(size(vec))<0.5*f;
permute_vec=xor(vec,turnover);
end
