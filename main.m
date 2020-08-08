%2重振子の運動シミュレーション

clear; close all;

%% シミュレーション設定
odf = @odefun;      % 常微分方程式を定める関数
t_simu = 50;        % シミュレーション時間[s]
tol = 1e-9;         % 許容誤差
dt_min = 0.000;       % 刻み幅下限
dt_max = 0.010;       % 刻み幅上限

freq_save = 1;    % 記録間隔[steps]
freq_disp = 50;  % 進捗表示間隔[steps]

%% auxdataを取得
auxdata = set_auxdata();

%% シミュレーション

tic

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

elapsed_time = toc;
fprintf("elapsed_time = %.3f\n", elapsed_time*1000);

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
% theta
figure()
subplot(2, 1, 1)
hold on
plot(ts, xs(1, :))
plot(ts, xs(2, :))
xlabel('time [s]')
ylabel('Angles [rad]')
legend('\theta_1', '\theta_2')
grid on

% theta_dot
subplot(2, 1, 2)
hold on
plot(ts, xs(3, :))
plot(ts, xs(4, :))
xlabel('time [s]')
ylabel('Angular Velocities [rad/s]')
legend('\theta_1', '\theta_2')
grid on

% 力学的エネルギー
figure()
plot(ts, Es)
xlabel('time [s]')
ylabel('Mechanical Energy [J]')
grid on

% 力学的エネルギーの変動
figure()
semilogy(ts, abs(1-Es./Es(1)))
xlabel('time [s]', 'Interpreter', 'latex')
ylabel('$|1 - E/E_0|$ [J]', 'Interpreter', 'latex')
grid on

%% アニメーション
fps = 20;
n_data = size(ts, 2);
t_term = ts(end);

ax_r = l1 + l2;

fig = figure('Color', 'w', 'ToolBar', 'none');
fn_ani = fig.Number;
ax = axes;
hold on
axis equal
box on
xlabel('x [m]')
ylabel('y [m]')
xlim([-1.1*ax_r 1.1*ax_r])
ylim([-1.1*ax_r 1.1*ax_r])
plot([-1.1*ax_r 1.1*ax_r], [0 0], '--k')  % 横線
plot([0 0], [-1.1*ax_r 1.1*ax_r], '--k') % 縦線

co_b = [0 0.4470 0.7410];
co_r = [0.8500 0.3250 0.0980];

r1 = l1.*[sin(xs(1, 1)); -cos(xs(1, 1))];
r2 = r1 + l2.*[sin(xs(2, 1)); -cos(xs(2, 1))];

n_traj = 300;  % 軌跡の長さ

% 軌跡
x_traj1 = r1(1).*ones(1, n_traj);
y_traj1 = r1(2).*ones(1, n_traj);
x_traj2 = r2(1).*ones(1, n_traj);
y_traj2 = r2(2).*ones(1, n_traj);
p6 = plot(x_traj2, y_traj2, '.', 'Color', co_r, 'LineWidth', 1);

% ロッド1
p1 = plot([0 r1(1)], [0 r1(2)],...
    'k', 'LineWidth', 1);
% ロッド2
p2 = plot([r1(1) r2(1)], [r1(2) r2(2)],...
    'k', 'LineWidth', 1);
% おもり1
p3 = plot(r1(1), r1(2),...
    'ok', 'LineWidth', 1, 'MarkerSize', 10, 'MarkerFaceColor', co_b);
% おもり2
p4 = plot(r2(1), r2(2),...
    'ok', 'LineWidth', 1, 'MarkerSize', 10, 'MarkerFaceColor', co_r);

% 時刻
t_text = text(-ax_r, ax_r, 't = 0.00');

q_ans = questdlg('Play animation?',...
    'Animation',...
    'Yes', 'Yes(gif)', 'No', 'Yes');

switch q_ans
    case 'Yes'
        figure(fn_ani)
        pause(1)
        t_cur = 0;
        k = 1;
        et = 0;
        while t_cur < t_term
            pause(1/fps - et)
            
            tic
            
            k_prev = k;
            while k <= n_data && ts(k) < t_cur
                k = k + 1;
            end
            skip_frames = k - k_prev;


            r1 = l1.*[sin(xs(1, k)); -cos(xs(1, k))];
            r2 = r1 + l2.*[sin(xs(2, k)); -cos(xs(2, k))];

            p1.XData = [0 r1(1)];
            p1.YData = [0 r1(2)];
            p2.XData = [r1(1) r2(1)];
            p2.YData = [r1(2) r2(2)];
            p3.XData = r1(1);
            p3.YData = r1(2);
            p4.XData = r2(1);
            p4.YData = r2(2);

            x_traj1 = circshift(x_traj1, -skip_frames);
            x_traj1((end-skip_frames+1):end) = l1*sin(xs(1, (k-skip_frames+1):k));
            y_traj1 = circshift(y_traj1, -skip_frames);
            y_traj1((end-skip_frames+1):end) = -l1*cos(xs(1, (k-skip_frames+1):k));

            x_traj2 = circshift(x_traj2, -skip_frames);
            x_traj2((end-skip_frames+1):end) = x_traj1((end-skip_frames+1):end) + l2*sin(xs(2, (k-skip_frames+1):k));
            y_traj2 = circshift(y_traj2, -skip_frames);
            y_traj2((end-skip_frames+1):end) = y_traj1((end-skip_frames+1):end) - l2*cos(xs(2, (k-skip_frames+1):k));
            p6.XData = x_traj2;
            p6.YData = y_traj2;

            t_text.String = sprintf('t = %.2f', ts(k));

            drawnow limitrate
            
            t_cur = t_cur + 1/fps;
            et = toc;
        end
end