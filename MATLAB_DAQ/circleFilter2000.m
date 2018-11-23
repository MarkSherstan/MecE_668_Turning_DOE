function [idxCenter,idxRadius,radiusOut,center,perCentChangeSum,percentChangeR,A,B,C,idxBoth] = circleFilter2000(pos,scale,flag)

  % Average 5 points forward and backward
  aa = movmean(pos.x,[4 4]);
  bb = movmean(pos.y,[4 4]);

  % Use every 15th point to formulate a circle
  posx = aa(1:8:end);
  posy = bb(1:8:end);

  % Find the radius and center location
  for i = 1:length(posx) - 3
    ABC = [posx(i) posy(i); posx(i+1) posy(i+1); posx(i+2) posy(i+2)];
    [R(i) cent] = fit_circle_through_3_points(ABC);
    center.x(i) = cent(1);
    center.y(i) = cent(2);
  end

  %% For center points
  %%%%%%%%%%%%%%%%%%%%%%%%%
  xx = diff(movmean(center.x,1));
  yy = diff(movmean(center.y,1));

  percentChangeX = abs(xx./center.x(1:end-1));
  percentChangeY = abs(yy./center.y(1:end-1));
  perCentChangeSum = percentChangeX + percentChangeY;

  %Smooth any single peaks, cut off first 10% of data
  perCentChangeSum = movmean(perCentChangeSum,6);
  idx1 = round(length(perCentChangeSum)*0.20);
  perCentChangeSum(1:idx1) = nan;
  A = cumsum(perCentChangeSum,'omitnan');


  for ii = 1:length(perCentChangeSum)
    if A(ii) > 1;
      %fprintf('\nChange in circle position (> 7%%)\n')
      %fprintf('Iteration %0.0f with a value of %0.2f%%\n\n',ii,perCentChangeSum(ii)*100)
      idxCenter = ii*8;
      break
    end
  end

  %% For radius
  %%%%%%%%%%%%%%%%%%%%%%%%%
  rrr = diff(R);

  percentChangeR = abs(rrr./R(1:end-1));

  % Smooth any single peaks, cut off first 10% of data
  percentChangeR = movmean(percentChangeR,6);
  idx2 = round(length(percentChangeR)*0.20);
  percentChangeR(1:idx2) = nan;
  B = cumsum(percentChangeR,'omitnan');

  for ii = 1:length(percentChangeR)
    if B(ii) > 2;
      %fprintf('Change in radius (> 7%%)\n')
      %fprintf('Iteration %0.0f with a value of %0.2f%%\n\n',ii,percentChangeR(ii)*100)
      idxRadius = ii*8;
      break
    end
  end

  %% For both
  %%%%%%%%%%%%%%%%%%%%%%%%%
  C = A + B;
  for ii = 1:length(C)
    if C(ii) > 3;
      idxBoth = ii*8;
      break
    end
  end



if flag == true
  % close all

  figure
  hold on
  plot(perCentChangeSum,'-k')
  plot(percentChangeR,'-r')
  title('Percent Changes')
  hold off
  %
  % figure
  % plot(pos.x,pos.y)
  % axis equal

  % figure
  % hold on
  % plot(R*scale,'o')
  % plot(R*scale)
  % hold off
end


  % Output results resampled to original size
  radiusOut = resample(R,length(pos.x),length(R))*scale;

end


function [R,xcyc] = fit_circle_through_3_points(ABC)
    % FIT_CIRCLE_THROUGH_3_POINTS
    % Mathematical background is provided in http://www.regentsprep.org/regents/math/geometry/gcg6/RCir.htm
    %
    % Input:
    %
    %   ABC is a [3 x 2n] array. Each two columns represent a set of three points which lie on
    %       a circle. Example: [-1 2;2 5;1 1] represents the set of points (-1,2), (2,5) and (1,1) in Cartesian
    %       (x,y) coordinates.
    %
    % Outputs:
    %
    %   R     is a [1 x n] array of circle radii corresponding to each set of three points.
    %   xcyc  is an [2 x n] array of of the centers of the circles, where each column is [xc_i;yc_i] where i
    %         corresponds to the {A,B,C} set of points in the block [3 x 2i-1:2i] of ABC
    %
    % Author: Danylo Malyuta.
    % Version: v1.0 (June 2016)
    % ----------------------------------------------------------------------------------------------------------
    % Each set of points {A,B,C} lies on a circle. Question: what is the circles radius and center?
    % A: point with coordinates (x1,y1)
    % B: point with coordinates (x2,y2)
    % C: point with coordinates (x3,y3)
    % ============= Find the slopes of the chord A<-->B (mr) and of the chord B<-->C (mt)
    %   mt = (y3-y2)/(x3-x2)
    %   mr = (y2-y1)/(x2-x1)
    % /// Begin by generalizing xi and yi to arrays of individual xi and yi for each {A,B,C} set of points provided in ABC array
    x1 = ABC(1,1:2:end);
    x2 = ABC(2,1:2:end);
    x3 = ABC(3,1:2:end);
    y1 = ABC(1,2:2:end);
    y2 = ABC(2,2:2:end);
    y3 = ABC(3,2:2:end);
    % /// Now carry out operations as usual, using array operations
    mr = (y2-y1)./(x2-x1);
    mt = (y3-y2)./(x3-x2);
    % A couple of failure modes exist:
    %   (1) First chord is vertical       ==> mr==Inf
    %   (2) Second chord is vertical      ==> mt==Inf
    %   (3) Points are collinear          ==> mt==mr (NB: NaN==NaN here)
    %   (4) Two or more points coincident ==> mr==NaN || mt==NaN
    % Resolve these failure modes case-by-case.
    idf1 = isinf(mr); % Where failure mode (1) occurs
    idf2 = isinf(mt); % Where failure mode (2) occurs
    idf34 = isequaln(mr,mt) | isnan(mr) | isnan(mt); % Where failure modes (3) and (4) occur
    % ============= Compute xc, the circle center x-coordinate
    xcyc = (mr.*mt.*(y3-y1)+mr.*(x2+x3)-mt.*(x1+x2))./(2*(mr-mt));
    xcyc(idf1) = (mt(idf1).*(y3(idf1)-y1(idf1))+(x2(idf1)+x3(idf1)))/2; % Failure mode (1) ==> use limit case of mr==Inf
    xcyc(idf2) = ((x1(idf2)+x2(idf2))-mr(idf2).*(y3(idf2)-y1(idf2)))/2; % Failure mode (2) ==> use limit case of mt==Inf
    xcyc(idf34) = NaN; % Failure mode (3) or (4) ==> cannot determine center point, return NaN
    % ============= Compute yc, the circle center y-coordinate
    xcyc(2,:) = -1./mr.*(xcyc-(x1+x2)/2)+(y1+y2)/2;
    idmr0 = mr==0;
    xcyc(2,idmr0) = -1./mt(idmr0).*(xcyc(idmr0)-(x2(idmr0)+x3(idmr0))/2)+(y2(idmr0)+y3(idmr0))/2;
    xcyc(2,idf34) = NaN; % Failure mode (3) or (4) ==> cannot determine center point, return NaN
    % ============= Compute the circle radius
    R = sqrt((xcyc(1,:)-x1).^2+(xcyc(2,:)-y1).^2);
    R(idf34) = Inf; % Failure mode (3) or (4) ==> assume circle radius infinite for this case
end

  % tt = 1:length(R);
  % [p,~,mu] = polyfit(tt,R,9);
  % f = polyval(p,tt,[],mu);
  % %plot(tt,f*scale,'LineWidth',3)