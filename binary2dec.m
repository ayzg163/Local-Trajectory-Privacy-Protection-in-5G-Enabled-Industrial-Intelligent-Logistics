function [decnumber] = binary2dec(binary)
%BINARY2DEC 
%_________________________________________________
%input:binary
%output:decnmber
%function of binary2dec:Convert binary to decimal
%_________________________________________________
L=size(binary,2);
decnumber=sum(binary.*2.^[L-1:-1:0],2);
end

