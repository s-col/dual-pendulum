%SIMU_ANIMATION 結果のアニメーションを生成する

fps = 60;
n_data = size(ts, 2);

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
        t_prev = 0;
        for k = (1+skip_frames):skip_frames:n_data
            pause(ts(k) - t_prev)
            t_prev = ts(k);

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
        end
        
%     case 'Yes(gif)'
%         inp = inputdlg({'File Name'}, 'Save gif', [1 35]);
%         if isempty(inp)
%             filename = 'output.gif';
%         else
%             filename = inp{1};
%         end
%         
%         fig = figure(fn_ani);
%         i_im = 1;
%         frame = getframe(fig);
%         im{i_im} = frame2im(frame);
%         for k = (1+skip_frames):skip_frames:n_data
%             i_im = i_im + 1;
%             
%             r1 = l1.*[sin(xs(1, k)); -cos(xs(1, k))];
%             r2 = r1 + l2.*[sin(xs(2, k)); -cos(xs(2, k))];
% 
%             p1.XData = [0 r1(1)];
%             p1.YData = [0 r1(2)];
%             p2.XData = [r1(1) r2(1)];
%             p2.YData = [r1(2) r2(2)];
%             p3.XData = r1(1);
%             p3.YData = r1(2);
%             p4.XData = r2(1);
%             p4.YData = r2(2);
% 
%             x_traj1 = circshift(x_traj1, -skip_frames);
%             x_traj1((end-skip_frames+1):end) = l1*sin(xs(1, (k-skip_frames+1):k));
%             y_traj1 = circshift(y_traj1, -skip_frames);
%             y_traj1((end-skip_frames+1):end) = -l1*cos(xs(1, (k-skip_frames+1):k));
% 
%             x_traj2 = circshift(x_traj2, -skip_frames);
%             x_traj2((end-skip_frames+1):end) = x_traj1((end-skip_frames+1):end) + l2*sin(xs(2, (k-skip_frames+1):k));
%             y_traj2 = circshift(y_traj2, -skip_frames);
%             y_traj2((end-skip_frames+1):end) = y_traj1((end-skip_frames+1):end) - l2*cos(xs(2, (k-skip_frames+1):k));
%             p6.XData = x_traj2;
%             p6.YData = y_traj2;
% 
%             t_text.String = sprintf('t = %.2f', dt_simu*freq_save*(double(k)-1));
% 
%             drawnow
%             frame = getframe(fig);
%             im{i_im} = frame2im(frame);
%         end
% 
%         for i = 1:i_im
%             [A, map] = rgb2ind(im{i}, 256);
%             if i == 1
%                 imwrite(A, map, filename, 'gif', ...
%                     'DisposalMethod', 'leaveInPlace', ...
%                     'LoopCount', Inf, 'DelayTime', dt_frames)
%             else
%                 imwrite(A, map, filename, 'gif', ...
%                     'DisposalMethod', 'leaveInPlace', ...
%                     'WriteMode', 'append', 'DelayTime', dt_frames)
%             end
%         end
end