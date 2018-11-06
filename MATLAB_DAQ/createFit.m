function [fitresult] = createFit(tsec, wz)

  % Fit
  [xData, yData] = prepareCurveData(tsec, wz);

  % Set up fittype and options.
  ft = fittype( 'gauss4' );
  opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
  opts.Display = 'Off';
  opts.Lower = [-Inf -Inf 0 -Inf -Inf 0 -Inf -Inf 0 -Inf -Inf 0];
  opts.StartPoint = [132.75846094 48.190524 3.09127421153934 125.952347706911 42.578472 2.75295418111384 117.864270359238 34.167132 2.09303822923094 106.249674936169 30.322236 2.33924603899523];

  % Fit model to data.
  [fitresult, gof] = fit( xData, yData, ft, opts );

end
