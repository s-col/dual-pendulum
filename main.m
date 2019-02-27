%2�d�U�q�̉^���V�~�����[�V����

clear; close all;

%% �V�~�����[�V�����ݒ�
odf = @odefun;      % ��������������߂�֐�
t_simu = 30;       % �V�~�����[�V��������[s]
dt_simu = 0.001;    % �V�~�����[�V��������[s]

freq_save = 10;    % �L�^�Ԋu[steps]
freq_disp = 5000;  % �i���\���Ԋu[steps]

%% auxdata���擾
auxdata = set_auxdata();

%% �V�~�����[�V����
steps = int64(0);
steps_f = int64(t_simu/dt_simu);
n_data = steps_f / freq_save + 1;

[t, x] = init();  % �����l��ݒ�

% ���ʂ��i�[����z��
ts = zeros(1, n_data);
xs = zeros(size(x, 1), n_data);

ts(1) = t;
xs(:, 1) = x;

idx_data = 2;

while steps <= steps_f
    steps = steps + 1;
    
    % �V�~�����[�V������1�X�e�b�v�i�߂�
    [t, x] = step_rk(odf, t, x, dt_simu, auxdata);
    
    % �p�x�𐳋K��
    % x(1:2) = normalize_angle(x(1:2)); 
    
    % �L�^
    if mod(steps, freq_save) == 0
        ts(idx_data) = t;
        xs(:, idx_data) = x;
        idx_data = idx_data + 1;
    end
    
    % �i���\��
    if mod(steps, freq_disp) == 0
        fprintf('time = %.2f\n', t);
    end 
end

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