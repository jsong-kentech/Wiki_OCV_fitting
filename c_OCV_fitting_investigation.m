% 1. local minimum vs. global minimum
   % cost curve (x1,y0) vs. cost
% 2. effect of initial guess



clear; clc; close all
% Config
filename_OCPp = 'CHC_(5)_OCV_C20.mat';
filename_OCPn = 'AHC_(5)_OCV_C20.mat';
filename_OCV = 'FCC_(5)_OCV_C20.mat';

x0 = 0.02;
x1 = 0.925;
y0 = 0.9867;
y1 = 0.2180;

para_0_1 = [x0, x1, y0, y1]; % initial guess
para_0_2 = [0, 1, 1, 0.21];

load(filename_OCPp)
y_data = OCV_golden.OCVchg(:,1);
OCPp_data = OCV_golden.OCVchg(:,2);
clear OCV_golden OCV_all

load(filename_OCPn)
x_data = OCV_golden.OCVchg(:,1);
OCPn_data = OCV_golden.OCVchg(:,2);

load(filename_OCV)
soc_data = OCV_golden.OCVchg(:,1);
ocv_data =OCV_golden.OCVchg(:,2);

x1_vec = linspace(0.5,1,21);
y0_vec = linspace(0.6,1,31);

N_x1 = length(x1_vec);
N_y0 = length(y0_vec);


% common
fhandle_cost =@(para)cost(soc_data,para,y_data,OCPp_data,x_data,OCPn_data,ocv_data);
options = optimoptions(@fmincon,'Display','iter','MaxIterations',100);
%{
cost_mat = zeros(N_x1,N_y0);
for n_x1 = 1:N_x1
    for n_y0 = 1:N_y0

        para_combi =[x0, x1_vec(n_x1), y0_vec(n_y0), y1];
        cost_mat(n_x1,n_y0) = cost(soc_data,para_combi,y_data,OCPp_data,x_data,OCPn_data,ocv_data);
        %[para_hat,cost(n_x1,n_y0)] = fmincon(fhandle_cost,para_0,[],[],[],[],[0 0.5 0.5 0],[0.5 1 1 0.5],[],options);


    end
end
% model -> function


% present result
figure(2)
surface(y0_vec,x1_vec,cost_mat)
%}
% cost -> function 
%cost_eval = cost(soc_data,para_0,y_data,OCPp_data,x_data,OCPn_data,ocv_data);

% minimier


[para_hat1,feval_hat1] = fmincon(fhandle_cost,para_0_1,[],[],[],[],[0 0.5 0.5 0],[0.5 1 1 0.5],[],options);
[para_hat2,feval_hat2] = fmincon(fhandle_cost,para_0_2,[],[],[],[],[0 0.5 0.5 0],[0.5 1 1 0.5],[],options);


% present results
OCV_0 = ocv_model(soc_data,para_0_1,y_data,OCPp_data,x_data,OCPn_data);
OCV_hat1 = ocv_model(soc_data,para_hat1,y_data,OCPp_data,x_data,OCPn_data);
OCV_hat2 = ocv_model(soc_data,para_hat2,y_data,OCPp_data,x_data,OCPn_data);


figure(1)
plot(soc_data,ocv_data, '-k'); hold on
plot(soc_data,OCV_hat1)
plot(soc_data,OCV_hat2,'--')
legend({'data','model-para0-1','model-para0-2'})


%figure(2); hold on
%scatter3(para_hat1(3),para_hat1(2),feval_hat1,'ro')



function [OCV_MODEL] = ocv_model(soc_data,para,y_data,OCPp_data,x_data,OCPn_data)
    
    x0 = para(1);
    x1 = para(2);
    y0 = para(3);
    y1 = para(4);

    % stoic_vec
    y_vec = y0 + (y1-y0)*soc_data;
    x_vec = x0 + (x1-x0)*soc_data;
    
    
    % OCP interpolation
    OCPp_vec = interp1(y_data,OCPp_data,y_vec,"linear","extrap");
    OCPn_vec = interp1(x_data,OCPn_data,x_vec,"linear","extrap");
    
    % OCV= OCPp-OCPn
    OCV_MODEL = OCPp_vec - OCPn_vec;

end

% cost
function COST = cost(soc_data,para,y_data,OCPp_data,x_data,OCPn_data,OCV_data)

OCV_model = ocv_model(soc_data,para,y_data,OCPp_data,x_data,OCPn_data);

COST = rmse(OCV_model,OCV_data);

end

