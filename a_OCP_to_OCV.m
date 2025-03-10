
clear; clc; close all
% Config
filename_OCPp = 'CHC_(5)_OCV_C20.mat';
filename_OCPn = 'AHC_(5)_OCV_C20.mat';
filename_OCV = 'FCC_(5)_OCV_C20.mat';

x0 = 0.02;
x1 = 0.925;
y0 = 0.9867;
y1 = 0.2180;

load(filename_OCPp)
y_data = OCV_golden.OCVchg(:,1);
OCPp_data = OCV_golden.OCVchg(:,2);
clear OCV_golden OCV_all

load(filename_OCPn)
x_data = OCV_golden.OCVchg(:,1);
OCPn_data = OCV_golden.OCVchg(:,2);


figure(1)
subplot(1,2,1)
plot(y_data,OCPp_data)

subplot(1,2,2)
plot(x_data,OCPn_data)



% SOC_vec
soc_vec = -0.1:0.01:1.1;

% stoic_vec
y_vec = y0 + (y1-y0)*soc_vec;
x_vec = x0 + (x1-x0)*soc_vec;


% OCP interpolation
OCPp_vec = interp1(y_data,OCPp_data,y_vec);
OCPn_vec = interp1(x_data,OCPn_data,x_vec);

% OCV= OCPp-OCPn
OCV_vec = OCPp_vec - OCPn_vec;



% plot
figure(2)
yyaxis left
plot(soc_vec,OCV_vec,'k-'); hold on
plot(soc_vec,OCPp_vec,'b-')
yyaxis right
plot(soc_vec,OCPn_vec,'-r')
xline(0)
xline(1)


return
% compare to OCV data (fullcell coin cell)
load(filename_OCV)
soc_data = OCV_golden.OCVchg(:,1);
ocv_data =OCV_golden.OCVchg(:,2);

figure(2); hold on
plot(soc_data,ocv_data,'g--')
legend({'OCV model','OCV data'})
