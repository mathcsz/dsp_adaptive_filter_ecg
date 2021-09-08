% Returns the RMS value of the error between two vectors weighted 
% by their respective means. 
%
function e = weightedErms(x1, x2)
  e = rms((x1 - mean(x1)) - (x2 - mean(x2)));
endfunction
