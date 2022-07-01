function [poscode] = getposcod(lon,lat,lonlim,latlim,h)
%getposcod       Given a geographic location, an area range, and a quadtree
%                depth, converting the geographic location to a quadtree  
%                encoding of the specified depth
%___________________________________________________________
%input: lon,lat,lonlim,latlim,h
%output:poscode
%   lon lat:        longitude and latitude of the geographic location
%   lonlim,latlim:  ranges of longitude and latitude
%   h:              depth of the quadtree
%   poscode:        the quadtree encoding of the geographic location
%__________________________________________________________

%For example
%__________________________________________________________
% x=[2 4 2.1]';
% y=[2 3 1.1]';
% xlim=[0 4]';
% ylim=[0 4]';
% h=7;
%__________________________________________________________
[n,npoints]=size(lon);%n:number of users; npoints: number of time points
nleaf=4^(h-1);% number of leaves in the quadtree
lonspan=(lonlim(2)-lonlim(1))/sqrt(nleaf);
latispan=(latlim(2)-latlim(1))/sqrt(nleaf);
londeccod=floor((lon-lonlim(1))./lonspan)-(lon==lonlim(2));%Longitude decimal encoding
latdeccod=floor((lat-latlim(1))./latispan)-(lat==latlim(2));%Latitude decimal encoding
poscode=zeros(size(lon,1),2*(h-1),npoints);

%Binary encoding of longitude and latitude
lonquot=londeccod;%the integral part of the quotient 
latquot=latdeccod;%the integral part of the quotient 
for i=h-1:-1:1
    poscode(:,2*(i-1)+1,:)=mod(lonquot,2);
    poscode(:,2*i,:)=mod(latquot,2);
    lonquot=floor(lonquot/2);
    latquot=floor(latquot/2);
end
end