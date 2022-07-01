% the length of trajectory is 3
clear
globalset;%initial setting
npoints=3;% number of time points in a trajectory
% lon=lon(1:1000,:);%only for testing
% lat=lat(1:1000,:);
lonlim=[min(lon(:)) max(lon(:))];
latlim=[min(lat(:)) max(lat(:))];
poscod3p = getposcod(lon,lat,lonlim,latlim,h);%position code of 3 time points(the length of trajeactory is 3 )
poscod2p = getposcod(lon(:,1:2),lat(:,1:2),lonlim,latlim,h);%position code of 2 time points(the length of trajeactory is 2 )

[uni_zonecod3p,uni_inncod3p,innvec3p] = getqjlpvec(m,l,poscod3p);%get the QJLP's zone code, inner code and inner one-hot vector(3 time points)
[uni_zonecod2p,uni_inncod2p,innvec2p] = getqjlpvec(m,l,poscod2p);%get the QJLP's zone code, inner code and inner one-hot vector(2 time points)
[~,~,con_innvec2p] = getqlpvec(m,l,poscod2p);% get the QLP's connected inner one-hot vector(2 time points)

%initialization
nround=size(fqpe,1);% number of parameter groups
R3P_qjlp(nround).C=[];%Real 3 time points
E3P_qjlp(nround).C=[];
R2P_qjlp(nround).C=[];
E2P_qjlp(nround).C=[];
R2P_qlp(nround).C=[];
E2P_qlp(nround).C=[];

%processing
parfor ii=1:nround
    for iii=1:ntest  %nround
        f=fqpe(ii,1);%flip factor
        q=fqpe(ii,2);%flip factor
        p=fqpe(ii,3);%flip factor
        [qjlp_vec3p] = QJLP(uni_zonecod3p,innvec3p,f,p,q);%perturbed inner one-hot vector of qjlp code (3 time points)
        [qjlp_vec2p] = QJLP(uni_zonecod2p,innvec2p,f,p,q);%perturbed inner one-hot vector of qjlp code (2 time points)
        [qlp_vec2p] = QLP(uni_zonecod2p,con_innvec2p,f,p,q);%perturbed inner one-hot vector of qlp code (2 time points)        
        [qjlp_reaTF3p qjlp_estTF3p]=QJLPAgg(uni_zonecod3p,uni_inncod3p,innvec3p,qjlp_vec3p,npoints,f,q,p);%get the real statistics and estimated statistics(3 time points)
        [qjlp_reaTF2p qjlp_estTF2p]=QJLPAgg(uni_zonecod2p,uni_inncod2p,innvec2p,qjlp_vec2p,2,f,q,p);%get the real statistics and estimated statistics(2 time points)
        [qlp_reaTF2p qlp_estTF2p]=QLPAgg(uni_zonecod2p,uni_inncod2p,con_innvec2p,qlp_vec2p,2,f,q,p);%get the real statistics and estimated statistics(2 time points)
        
        %get ntest times result  
        %Put the estimated result in the last column of the array each time
        if iii == 1
            R3P_qjlp(ii).C = qjlp_reaTF3p;
            R2P_qjlp(ii).C = qjlp_reaTF2p;
            E3P_qjlp(ii).C = qjlp_estTF3p;
            E2P_qjlp(ii).C = qjlp_estTF2p;          
            R2P_qlp(ii).C = qlp_reaTF2p;
            E2P_qlp(ii).C = qlp_estTF2p
        else    
            E3P_qjlp(ii).C=[E3P_qjlp(ii).C qjlp_estTF3p(:,end)];
            E2P_qjlp(ii).C=[E2P_qjlp(ii).C qjlp_estTF2p(:,end)];
            E2P_qlp(ii).C=[E2P_qlp(ii).C qlp_estTF2p(:,end)];
        end
    end
end

save ../results/main.mat R3P_qjlp E3P_qjlp R2P_qjlp E2P_qjlp R2P_qlp E2P_qlp