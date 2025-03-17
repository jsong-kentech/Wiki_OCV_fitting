clear; clc; close all
% Config
filename_OCPp = 'CHC_(5)_OCV_C20.mat';
filename_OCPn = 'AHC_(5)_OCV_C20.mat';
filename_OCV = 'FCC_(5)_OCV_C20.mat';

x0 = 0.02;
x1 = 0.925;
y0 = 0.9867;
y1 = 0.2180;

para_0 = [x0, x1, y0, y1];

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

% model -> function

% cost -> function 
cost_eval = cost(soc_data,para_0,y_data,OCPp_data,x_data,OCPn_data,ocv_data);

% minimier
fhandle_cost =@(para)cost(soc_data,para,y_data,OCPp_data,x_data,OCPn_data,ocv_data);
options = optimoptions(@fmincon,'Display','iter','MaxIterations',1);

para_hat = fmincon(cost,para_0,[],[],[],[],[0 0.5 0.5 0],[0.5 1 1 0.5],[],options);


% present results





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

