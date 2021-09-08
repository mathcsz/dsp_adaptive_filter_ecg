% RLS adaptive filter
%
% In:
%   n: reference signal samples
%   d: primary signal samples
%   firM: number of kernel's samples
%   l: (lambda) forgetting factor
%   ini: 1 to initialize the filter
%
% Out:
%   y: filtered n
%   e: instant error
%
function [y, e] = rlsFilter(n, d, firM, l, ini)
persistent psi teta lambda delta M P 
% Initialization:
if (ini == 1)
  lambda = l;
  M = firM;
  y = 0;

  % memory initialization
  psi = zeros(M,1);

  % filter coefficients initialization
  teta = zeros(M,1);

  % Initialize P with aI (a = 0.01), 
  % avoiding a singular matrix
  P = 0.01*eye(M);
    
else
  % Update psi with the new sample
  for J = M:-1:2
    psi(J) = psi(J-1);
  end;
  psi(1) = n;

  % calculate the filtered sample
  y = psi'*teta;

  % Calculate the error
  e = d - y;

  % Calculate the gain matrix
  K = P*psi/(lambda + psi'*P*psi);

  % Update the correlation matrix
  P = (P - K*psi'*P)/lambda;

  % Update the filter coefficients 
  teta = teta + K*e;
end
