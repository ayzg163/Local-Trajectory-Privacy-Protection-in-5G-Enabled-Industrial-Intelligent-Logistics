function [qlp_reaTF,qlp_estTF] = QLPAgg(uni_zonecod,uni_inncod,con_innvec,qlp_vec,npoints,f,q,p)
%ori2res2agg0  original data-->randomized response(QJLP)-->aggregated data
%____________________________________________________________________________
%input: uni_zonecod,uni_inncod,con_innvec,qlp_vec,ntimp,f,q,p
%output:ful_reaTF,ful_estTF
%   uni_zonecod uni_inncod: united zone code and united inner code
%   con_innvec:             connected inner one-hot vector of QLP
%   qlp_vec      perturbed inner one-hot vector 
%   npoints:                  trajectory length
%   f,q,p:                  flip factors
%   qlp_reaTF,qlp_estTF:    real trajectory frequency; estimated trajectory frequency after aggregation
%____________________________________________________________________________

%convert the uni_zonecod to the three-dimensional matrix of n*1*npoints,the zones that the trajectory goes through
zonethr=binary2dec(reshape(uni_zonecod,size(uni_zonecod,1),size(uni_zonecod,2)/npoints,npoints));

%convert the zonethr to the two-dimensional matrix of n*npoints
zonethr=reshape(zonethr,size(zonethr,1),npoints);

[uniqzone,ia,ic]=unique(zonethr,'rows');
nn=size(uniqzone,1);

%initialization
% zone=zeros(nn,npoints); 
zones=zeros(nn,npoints); 
reaTFs(nn).C=[];
estTFs(nn).C=[];

nunitr=0;%the number of sub-datasets with only one trajectory, only for testing
ntrsd=zeros(nn,1);%number of trajectories in each subdataset

P=0.5*f*(p+q)+(1-f)*p;
Q=0.5*f*(p+q)+(1-f)*q;
nleaf=size(con_innvec,2)/npoints;

for i=1:nn
%     for i=32
    pos=find(ic==i);%i-th subdataset element position
    zones(i,:)=zonethr(pos(1),:);
    reaTF=zeros(nleaf^npoints,1);%real trajectory frequency
    [allinntr ia1 ic1]=unique(con_innvec(pos,:),'rows');
    pos1=binary2dec(uni_inncod(pos(ia1),:))+1;%Unique trajectory number
    tbl=tabulate(ic1);
    reaTF(pos1)=tbl(:,2);
    
    %Calculate estimated frequency(QLP)
    estTF=zeros(size(reaTF));
    for j=1:size(allinntr,1)
        ntrcount=sum(sum(allinntr(j,:).*qlp_vec(pos,:),2)==2);
        np1count=sum(sum(allinntr(j,1:nleaf).*qlp_vec(pos,1:nleaf),2));
        np2count=sum(sum(allinntr(j,nleaf+1:2*nleaf).*qlp_vec(pos,nleaf+1:2*nleaf),2));
        n1=(np1count-P*length(pos))/(Q-P);
        n2=(np2count-P*length(pos))/(Q-P);
        estTF(pos1(j))=(ntrcount-(n1+n2)*Q*P-(length(pos)-n1-n2)*P^2)/(Q-P)^2;
    end
    if length(pos1)==1
        nunitr=nunitr+1;%Count the number of sub-datasets with only one trajectory
    end
    
    reaTFs(i).C=[(0:size(reaTF,1)-1)',reaTF];
    estTFs(i).C=[(0:size(estTF,1)-1)',estTF];
    ntrsd(i)=length(pos1);%The number of traces in the zone
end
ntr=sum(ntrsd);%number of trajectory kinds

%initial true frequency; estimated trajectory frequency after basic rappor
qlp_estTF=zeros(ntr,npoints+2);%The first npoints columns represent the zone code, the last two columns are the trajectory number and
                            % frequency in the zone respectively.
qlp_reaTF=zeros(ntr,npoints+2);

cum=[0;cumsum(ntrsd)];%The beginning sequence number of the trajectory of different zones

estTF3d=cell2mat(struct2cell(estTFs));%Convert struct to array with two columns, decimal inner code and trajectory frequency.
reaTF3d=cell2mat(struct2cell(reaTFs));

for i=1:nn
    zone=repmat(zones(i,:),ntrsd(i),1);
    pos=find(reaTF3d(:,2,i)~=0);
    reaTF=reaTF3d(pos,:,i);
    range=cum(i)+1:cum(i+1);
    qlp_reaTF(range,:)=[zone reaTF];%the real trajectory frequency
    estTF=estTF3d(pos,:,i);%estimated frequency of the trajectory in the zone
    qlp_estTF(range,:)=[zone estTF ];% estimated frequency of the trajectory with zone code
end
end