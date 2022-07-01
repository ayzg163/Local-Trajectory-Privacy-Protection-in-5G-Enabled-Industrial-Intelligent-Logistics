function [uni_zonecod uni_inncod innvec] = getqjlpvec(m,l,poscod)
%gettrvec
%___________________________________________________________
%input:m,l,poscod
%output:uni_zonecod uni_inncod innvec con_innvec
%   poscod:                 quadtree encoding of positions( 3 dimension matrix:user, binary code, timepoint)
%   m l:                    depths of perturbation layer and generalization layer
%   uni_zonecod uni_inncod: united zone code and united inner code
%   innvec:                 inner one-hot vector of QJLP 
%__________________________________________________________

[n1,n2,n3]=size(poscod);
zonecod=poscod(:,1:2*(m-1),:);
uni_zonecod=reshape(zonecod,n1,2*(m-1)*n3);
inncod=poscod(:,2*(m-1)+1:2*(l-1),:);

% output inner code
uni_inncod=reshape(inncod,n1,2*(l-m)*n3);

%get inner one-hot vector
innvec=zeros(n1,4^(l-m)^n3);
p=binary2dec(uni_inncod)+1;
innvec((p-1).*n1+[1:n1]')=1;%Convert uni_inncod to a 2^h-bit vector innvec

end

