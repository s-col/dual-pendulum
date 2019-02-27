% SIMU_PLOT ���ʂ��v���b�g����

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

% �͊w�I�G�l���M�[
figure()
plot(ts, Es)
xlabel('time [s]')
ylabel('Mechanical Energy [J]')
grid on

% �͊w�I�G�l���M�[�̕ϓ�
figure()
semilogy(ts, abs(1-Es./Es(1)))
xlabel('time [s]', 'Interpreter', 'latex')
ylabel('$|1 - E/E_0|$ [J]', 'Interpreter', 'latex')
grid on