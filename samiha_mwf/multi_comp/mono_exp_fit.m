function [s0_fit, t2_fit] = mono_exp_fit(measurements, echo_times, guess, lb, ub)
%  function [S0, T2] = mono_exp_fit(measurements, te_values, guess)
%
%  returns two parameters from mon-exponential fit
%   S0 = signal at TE = 0
%   T2 = decay constant
%
%  inputs:
%   measurements = signal samples
%   TE_values    = corresponding echo times
%   guess        = starting point for [S0, T2]


[result, resnorm, res, flag] = lsqnonlin(@err_fit, guess,[],[],[], measurements, echo_times);
t2_fit = result(1);
s0_fit = result(2); 