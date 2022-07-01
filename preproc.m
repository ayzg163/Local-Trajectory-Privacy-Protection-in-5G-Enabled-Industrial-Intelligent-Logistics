% This a programming for processing the oringinal data.
final=0;
for k=1:288 %
    begin=final+1;
    No=num2str(k,'%03d');
    filename=['F:\LDP\open-source\11\11\20170311_',No,'.TXT'];
    [a b c d e f g h i j]=textread(filename,'%d %d %c %*2s %s %f %f %f %d %d %d','delimiter',',');
    L=size(a,1);%Returns the number of rows in the matrix
    final=begin+L-1;    
    dd=cell2mat(d);
    [row col v]=find((dd=='A') | (dd=='B')| (dd=='C')| (dd=='D')| (dd=='E')| (dd=='F'));
    
    %The maximum number in the first digit of the original license plate is
    %8. The first position of the following license plates containing
    %letters is 9, which is different from other license plates
    row=unique(row);
    dd(row)='9';  
    
    %As far as this data set is concerned, the first letter of the license
    %plate is 9. The following processing converts letters into numbers.
    %There is no situation where multiple license plates are converted into
    %the same number.
    dd(dd=='A')='1';
    dd(dd=='B')='2';
    dd(dd=='C')='3';
    dd(dd=='D')='4';
    dd(dd=='E')='5';
    dd(dd=='F')='6';
    dd=str2num(dd);
    bigdata(begin:final,:)=[b dd e f g h i j];
end
bigdata=bigdata(1:final,:);
%Delete invalid data and set time
bigdata(find((bigdata(:,3)<85)+(bigdata(:,3)>120)),:)=[];%Filter out locations outside of China
bigdata(find((bigdata(:,4)<20)+(bigdata(:,4)>52)),:)=[];
bigdata(bigdata(:,2)>9e9,:)=[];%Remove invalid license plates with letters in numeric license plate numbers
bigdata(bigdata(:,8)==0,:)=[];%Delete license plates with invalid data
time=bigdata(:,1);
time=fix(time/10000)*3600+mod(fix(time/100),100)*60+mod(time,100);%Convert GPS time to seconds
bigdata(:,1)=time;
bigdata=sortrows(bigdata,[2,1]);%Sort by 2 columns and then by 1 column

mu=mean(bigdata(:,3));
sigma=std(bigdata(:,3));%standard deviation
lonlim=[mu-3*sigma,mu+3*sigma];%Defines the longitude range; includes 99% of points
mu=mean(bigdata(:,4));
sigma=std(bigdata(:,4));
latlim=[mu-3*sigma,mu+3*sigma];%Defines the dimension range; includes 99% of the points
[row,col] = find(bigdata(:,4)<latlim(1) | bigdata(:,4)>latlim(2) | bigdata(:,3)<lonlim(1) |bigdata(:,3)>lonlim(2));%Find points outside the area
bigdata(row,:)=[];% delete

timeint=300;%time span
longitude=bigdata(:,3);
latitude=bigdata(:,4);
ndecplace=2;

time=bigdata(:,1);
[C ia ic]=unique(bigdata(:,2)); %bigdata is a dataset sorted by the two column attributes of license plate and time
ncars=size(C,1);%number of cars
nrealTPs=[ia(2:end)-ia(1:end-1);size(bigdata,1)+1-ia(end)];%number of time points of each car
nsetTP=60*60*24/timeint;% number of set timepoints
setTPNo=1:nsetTP;
realTPNo=fix((time-timeint/2)/timeint)+1;

X=zeros(nsetTP,ncars);
Y=X;

for j=1:ncars
    t=realTPNo(ia(j):ia(j)+nrealTPs(j)-1);
    [lia,locb]=ismember(setTPNo,t);
    pos=find(locb==0);
    begin=1;
    
    %If the set first TP cannot find the corresponding real TP, special processing
    if ~isempty(pos) && pos(1)==1
        locb(1)=locb(min(find(lia~=0)));
        begin=2;
    end
    
    for k=begin:length(pos)
        locb(pos(k))=locb(pos(k)-1);
    end
    X(:,j)=longitude(ia(j)-1+locb);
    Y(:,j)=latitude(ia(j)-1+locb);
end

loninTP=X';%Behavior car, listed as TP
latinTP=Y';

% get more trajectories 
%Due to insufficient samples, the trajectory of the same vehicle in other
%time periods is used as a new sample.
[N maxcol]=size(loninTP);
repeat=20;
maxntimp=3;
interval=1;%interval within one trajectory
intervaloftr=3;%interval between tracks

selcol=zeros(repeat,maxntimp);
begincol=1;
increase=(maxntimp-1)*(interval+1)+intervaloftr;
for j=1:maxntimp
    endcol=begincol+increase*(repeat-1);
    selcol(:,j)=[begincol:increase:endcol]';
    begincol=begincol+interval+1;
end
selcol=selcol+round(maxcol/2-(selcol(end)-selcol(1)+1)/2);
%Treat the records of the same user in different time periods as records of
%another user, and expand the size of the dataset
lon=[];
lat=[];
for i=1:size(selcol,1)
    lon=[lon;loninTP(:,selcol(i,:))];
    lat=[lat;latinTP(:,selcol(i,:))];
end
save data.mat lon lat