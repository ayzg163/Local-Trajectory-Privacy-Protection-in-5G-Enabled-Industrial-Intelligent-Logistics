function [qjlp_reaTF,qjlp_estTF] = QJLPAgg(uni_zonecod,uni_inncod,innvec,qjlp_vec,npoints,f,q,p)
%QLJPAgg  :     aggregated data(QJLP)
%____________________________________________________________________________
%input: uni_zonecod,uni_inncod,con_innvec,npoints,f,q,p
%output:qjlp_reaTF,qjlp_estTF
%   uni_zonecod uni_inncod: united zone code and united inner code
%   innvec:                 inner one-hot vector of QJLP 
%   qjlp_vec:               the vector after QJLP perturb 
%   npoints:                trajectory length
%   f,q,p:                  flip factor
%   qjlp_reaTF,qjlp_estTF:  real trajectory frequency; estimated trajectory frequency
%____________________________________________________________________________

%convert the uni_zonecod to the three-dimensional matrix of n*1*npoints,the trajectory goes through the zone
zonethr=binary2dec(reshape(uni_zonecod,size(uni_zonecod,1),size(uni_zonecod,2)/npoints,npoints));

%convert the zonethr to the two-dimensional matrix of n*npoints,the trajectory goes through the zone
zonethr=reshape(zonethr,size(zonethr,1),npoints);

[uniqzone,ia,ic]=unique(zonethr,'rows');
nn=size(uniqzone,1);

%initialization
zones(nn).C=[]; 
reaTFs(nn).C=[];
estTFs(nn).C=[];
nunitr=0;
ntrsd=zeros(nn,1);%number of trajectories in each subdataset

P=0.5*f*(p+q)+(1-f)*p;
Q=0.5*f*(p+q)+(1-f)*q;
Linncod=size(uni_inncod,2)/npoints;  %length of inner code
nleaf=2^(Linncod);%number of perturbation layer nodes
for i=1:nn
%     for i=32
    pos=find(ic==i);%the positions of trajectories that belong to the i-th zonethr
    zone=zonethr(pos(1),:);%the sequential zone codes of the i-th zonethr
    reaTF=zeros(nleaf^npoints,1);
    [allinntr ia1 ic1]=unique(innvec(pos,:),'rows');
    pos1=binary2dec(uni_inncod(pos(ia1),:))+1;%unique decimal number of the trajectory
    tbl=tabulate(ic1);
    reaTF(pos1)=tbl(:,2);
    
    %Calculate estimated frequency
    estTF=zeros(size(reaTF));
    for j=1:size(allinntr,1)
        ntrcount=sum(sum(allinntr(j,:).*qjlp_vec(pos,:),2));%sum of the perturbed vector
        estTF(pos1(j))=(ntrcount-P*length(pos))/(Q-P);%LDP aggregated 
    end
    
    if length(pos1)==1
        nunitr=nunitr+1;%Count the number of sub-datasets with only one trajectory
    end    
    zones(i).C=zone;
    reaTFs(i).C=[(0:size(reaTF,1)-1)',reaTF];
    estTFs(i).C=[(0:size(estTF,1)-1)',estTF];
    ntrsd(i)=length(pos1);%The number of traces in the zone
end
ntr=sum(ntrsd);

%initial true frequency; estimated frequency after basic rappor 
qjlp_estTF=zeros(ntr,npoints+2);%The first npoints columns represent the zone code, the last two columns are the trajectory number and
                            % frequency in the zone respectively.
qjlp_reaTF=zeros(ntr,npoints+2);

cum=[0;cumsum(ntrsd)];%The beginning sequence number of the trajectory of different zones

estTF3d=cell2mat(struct2cell(estTFs));%Convert struct to array with two columns, decimal inner code and trajectory frequency.
reaTF3d=cell2mat(struct2cell(reaTFs));

for i=1:nn
    zone=repmat(zones(i).C,ntrsd(i),1);
    pos=find(reaTF3d(:,2,i)~=0);
    reaTF=reaTF3d(pos,:,i);
    range=cum(i)+1:cum(i+1);
    qjlp_reaTF(range,:)=[zone reaTF ];%get the real frequency
    estTF=estTF3d(pos,:,i);%estimated frequency of the trajectory in the zone
    qjlp_estTF(range,:)=[zone estTF ];% estimated frequency of the trajectory with zone code
end
end