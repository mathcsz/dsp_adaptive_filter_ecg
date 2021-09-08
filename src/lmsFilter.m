% LMS adaptive filter
%
% In:
%   n: reference signal samples
%   d: primary signal samples
%   firM: number of kernel's samples
%   mu: adaptation factor
%   ini: 1 to initialize the filter
%
% Out:
%   y: filtered n
%   e: instant error
%
function [y, e] = lmsFilter(n, d, firM, mu, ini)
persistent x w MU M
  % Initialization:
if (ini == 1)
  MU = mu;
  M = firM;
  y = 0;

  % memory initialization
  x = zeros(1,M);

  % filter coefficients initialization
  w = zeros(1,M);
  w(1) = 1;

else
  % Update x with the new sample
  for J=M:-1:2
    x(J) = x(J-1);
  end;
  x(1) = n;

  % calculate the filtered sample (y = conv(w,x))
  y = 0;
  for J = 1:M
      y = y + w(J)*x(J);
  end;

  % Calculate the error
  e = d - y;

  % Update the filter coefficients 
  for J = 1:M
      w(J) = w(J) + MU*e*x(J);
  end;
   
end
