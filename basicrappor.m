function [vec,vec2] = basicrappor(vec,f,p,q)
%BASONERAPPOR
%___________________________________________________________
%input:vec f p q
%output:vec vec2
%   vec:input vector
%   f p q:flip factor
%   vec2:output vector after perturbation by bisicrappor 
%__________________________________________________________

%achieve Permanent random response
[~,vec1,~]=one_timerappor(vec,f);

%achieve Instantaneous random response
turnover0=(rand(size(vec1))<p).*(vec1==0);
turnover1=rand(size(vec1))<(1-q).*vec1;
turnover=turnover0+turnover1;
vec2=xor(vec1,turnover);
end
