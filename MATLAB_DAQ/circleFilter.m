function [R] = circleFilter(pospos,scale)

  % Average 10 points, 5 forward and 5 backward
  aa = movmean(pospos.x,[5 5]);
  bb = movmean(pospos.y,[5 5]);

  % Use every 8th point to formulate a circle
  posx = aa(1:8:end);
  posy = bb(1:8:end);

  % Find the radius and center location based on 3 points spaced 8 apart
  for i = 1:length(posx) - 3
    ABC = [posx(i) posy(i); posx(i+1) posy(i+1); posx(i+2) posy(i+2)];
    [Radius(i) cent] = fit_circle_through_3_points(ABC);
  end

  % Smooth out sharp peaks
  Radius = movmean(Radius,[2 2]);

  % Find location cut off for the bottom 25% of the data
  idxHigh = round(length(Radius)*0.25);

  % Calculate mean and std. Set a scale for number of deviations
  R.mean = mean(Radius(1:idxHigh));
  R.std = std(Radius(1:idxHigh));
  R.devs = 2;
  R.radius = Radius;

  % Find radius values thats dont fit in the std set
  indexR = zeros(1,length(Radius));

  for ii = idxHigh:length(Radius)
    if (R.radius(ii) >= (R.mean + R.std*R.devs) || R.radius(ii) <= (R.mean - R.std*R.devs))
      indexR(ii) = ii;
    end
  end

  % Convert index locations to a logical and add to structure
  R.idx = logical(indexR);

  % Add scaled radius in meters
  R.meters = R.radius*scale;

end


% https://www.mathworks.com/matlabcentral/fileexchange/57668-fit-circle-through-3-points
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
