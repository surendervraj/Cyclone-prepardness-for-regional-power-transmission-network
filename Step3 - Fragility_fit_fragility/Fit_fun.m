function [fitresult, gof] = Fit_fun(x, y, M)
%CREATEFIT(X,Y,M)
%  Create a fit.
%
%  Data for 'Fit_ex' fit
%      X Input : x
%      Y Output: y
%      Weights : M
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 27-Jun-2020 11:32:03


%% Fit: 'Fit_ex'.
[xData, yData, weights] = prepareCurveData( x, y, M );

% Set up fittype and options.
ft = fittype( 'normcdf(a+(log(x)*b))', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [0.0713780144965911 0.0560268492558385];
opts.Weights = weights;

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
%figure( 'Name', 'Fit_ex' );
%h = plot( fitresult, xData, yData );
%legend( h, 'y vs. x with M', 'Fit_ex', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
%xlabel( 'x', 'Interpreter', 'none' );
%ylabel( 'y', 'Interpreter', 'none' );
%grid on
