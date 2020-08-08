%2重振子の運動シミュレーション

clear; close all;

%% シミュレーション設定
odf = @odefun;      % 常微分方程式を定める関数
t_simu = 30;        % シミュレーション時間[s]
tol = 1e-8;         % 許容誤差
dt_min = 0.000;       % 刻み幅下限
dt_max = 0.005;       % 刻み幅上限

freq_save = 1;    % 記録間隔[steps]
freq_disp = 50;  % 進捗表示間隔[steps]

%% auxdataを取得
auxdata = set_auxdata();

%% シミュレーション

[t, x] = init();  % 初期値を設定
dt_simu = dt_max;

% 結果を格納する配列
ts = [];
xs = [];
flg = 0;
steps = 0;

ts(1) = t;
xs(:, 1) = x;

while flg == 0
    steps = steps + 1;
    
    % シミュレーションを1ステップ進める
    [t, x, dt_simu, flg] = step_rk45(odf, t, x, dt_simu, dt_min, dt_max, tol, t_simu);
    
    % 角度を正規化
    % x(1:2) = normalize_angle(x(1:2)); 
    
    % 記録
    if mod(steps, freq_save) == 0
        ts(end+1) = t;
        xs(:, end+1) = x;
    end
    
    % 進捗表示
    if mod(steps, freq_disp) == 0
        fprintf('time = %.2f  dt = %.7f\n', t, dt_simu);
    end 
end

%% flg の表示
fprintf("flg = %d\n", flg)

%% 力学的エネルギーを計算
g = auxdata.g;
m1 = auxdata.m1;
l1 = auxdata.l1;
m2 = auxdata.m2;
l2 = auxdata.l2;

Ts = 0.5.*(m1+m2).*l1.^2.*xs(3, :).^2 + m2.*l1.*l2.*xs(3, :).*xs(4, :).*cos(xs(1, :)-xs(2, :)) + 0.5.*m2.*l2.^2.*xs(4, :).^2;
Us = - (m1+m2).*l1.*g.*cos(xs(1, :)) - m2.*l2.*g.*cos(xs(2, :));
Es = Ts + Us;

%% プロット
simu_plot

%% アニメーション
simu_animation