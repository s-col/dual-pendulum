%2�d�U�q�̉^���V�~�����[�V����

clear; close all;

%% �V�~�����[�V�����ݒ�
odf = @odefun;      % ��������������߂�֐�
t_simu = 30;        % �V�~�����[�V��������[s]
tol = 1e-8;         % ���e�덷
dt_min = 0.000;       % ���ݕ�����
dt_max = 0.005;       % ���ݕ����

freq_save = 1;    % �L�^�Ԋu[steps]
freq_disp = 50;  % �i���\���Ԋu[steps]

%% auxdata���擾
auxdata = set_auxdata();

%% �V�~�����[�V����

[t, x] = init();  % �����l��ݒ�
dt_simu = dt_max;

% ���ʂ��i�[����z��
ts = [];
xs = [];
flg = 0;
steps = 0;

ts(1) = t;
xs(:, 1) = x;

while flg == 0
    steps = steps + 1;
    
    % �V�~�����[�V������1�X�e�b�v�i�߂�
    [t, x, dt_simu, flg] = step_rk45(odf, t, x, dt_simu, dt_min, dt_max, tol, t_simu);
    
    % �p�x�𐳋K��
    % x(1:2) = normalize_angle(x(1:2)); 
    
    % �L�^
    if mod(steps, freq_save) == 0
        ts(end+1) = t;
        xs(:, end+1) = x;
    end
    
    % �i���\��
    if mod(steps, freq_disp) == 0
        fprintf('time = %.2f  dt = %.7f\n', t, dt_simu);
    end 
end

%% flg �̕\��
fprintf("flg = %d\n", flg)

%% �͊w�I�G�l���M�[���v�Z
g = auxdata.g;
m1 = auxdata.m1;
l1 = auxdata.l1;
m2 = auxdata.m2;
l2 = auxdata.l2;

Ts = 0.5.*(m1+m2).*l1.^2.*xs(3, :).^2 + m2.*l1.*l2.*xs(3, :).*xs(4, :).*cos(xs(1, :)-xs(2, :)) + 0.5.*m2.*l2.^2.*xs(4, :).^2;
Us = - (m1+m2).*l1.*g.*cos(xs(1, :)) - m2.*l2.*g.*cos(xs(2, :));
Es = Ts + Us;

%% �v���b�g
simu_plot

%% �A�j���[�V����
simu_animation