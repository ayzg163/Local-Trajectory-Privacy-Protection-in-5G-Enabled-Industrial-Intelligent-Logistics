function [uni_zonecod uni_inncod  con_innvec] = getqlpvec(m,l,poscod)
%getqlpvec: getting the connected inner one-hot vector of QLP
%___________________________________________________________
%input:m,l,poscod
%output:uni_zonecod uni_inncod innvec con_innvec
%   poscod:                 quadtree encoding of position (3 dimension matrix:user, binary code, timepoint)
%   m l:                    depths of perturbation layer and generalization layer
%   uni_zonecod uni_inncod: united zone code and united inner code
%   con_innvec:             connected inner one-hot vector of QLP
%__________________________________________________________

[n1,n2,n3]=size(poscod);
zonecod=poscod(:,1:2*(m-1),:);
uni_zonecod=reshape(zonecod,n1,2*(m-1)*n3);
inncod=poscod(:,2*(m-1)+1:2*(l-1),:);
con_innvec=zeros(n1,4^(l-m),n3);
p=1+binary2dec(inncod);

%get connected inner one-hot vector
for z=1:n3
    tmp=con_innvec(:,:,z);
    p1=p(:,:,z);
    tmp((p1-1).*n1+[1:n1]')=1;
    con_innvec(:,:,z)=tmp;
end
con_innvec=reshape(con_innvec,n1,4^(l-m)*n3);

% output inner code
uni_inncod=reshape(inncod,n1,2*(l-m)*n3);
end

