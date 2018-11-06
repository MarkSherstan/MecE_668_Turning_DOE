function [fitresult] = createFit(wz)

  % Fit
  [xData, yData] = prepareCurveData( [], wwzz );

  % Set up fittype and options.
  ft = fittype( 'gauss4' );
  opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
  opts.Display = 'Off';
  opts.Lower = [-Inf -Inf 0 -Inf -Inf 0 -Inf -Inf 0 -Inf -Inf 0];
  opts.StartPoint = [132.75846094 1773 134.923708659272 126.699814427146 1522 117.962724531341 117.840932648423 1184 92.018311965428 106.847239922242 1011 99.8384694087704];

  % Fit model to data.
  [fitresult, gof] = fit( xData, yData, ft, opts );

end
