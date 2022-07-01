function [binary] = dec2binary(decnumber,binlength)
%DEC2BINARY 
%____________________________________________________
%input:decnmber binlength
%output:binary 
%   decnmber:   Entered decimal number
%   binlength:  Controls the length of the output binary
%   binary:     Output binary number
%function of binary2dec:Convert decimal to binary of specified length
%____________________________________________________
binary=zeros(length(decnumber),binlength);
rem=decnumber;
for i=binlength:-1:1
    binary(:,i)=mod(rem,2);
    rem=floor(rem/2);
end
end

