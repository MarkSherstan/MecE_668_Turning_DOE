close all

tt = t.seconds;

figure(1)

yyaxis left
%leftA = plot(tt,aa.x,'-r',tt,aa.y,'-g',tt,aa.z,'-b')
leftA = plot(tt,aa.y,'-g',tt,aa.z,'-b')
ylabel('Acceleration [g]')

yyaxis right
rightW = plot(tt,ww.x,'--r',tt,ww.y,'--g',tt,ww.z,'--b')
ylabel('Angular Velocity')

%Leg = legend([leftA; rightW], {'a_x','a_y','a_z','w_x','w_y','w_z'});
Leg = legend([leftA; rightW], {'a_y','a_z','w_x','w_y','w_z'});
xlabel('Time (s)')
