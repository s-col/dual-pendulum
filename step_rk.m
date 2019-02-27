function [t_ret, x_ret] = step_rk(odf, t, x, dt, auxdata)
%STEP_RK 4次のルンゲ=クッタ法でシミュレーションを1ステップ進める

t1 = t;
t2 = t + 0.5 * dt;
t3 = t + dt;

k1 = odf(t1, x, auxdata);
k2 = odf(t2, x + 0.5 * dt .* k1, auxdata);
k3 = odf(t2, x + 0.5 * dt .* k2, auxdata);
k4 = odf(t3, x + dt .* k3, auxdata);

t_ret = t3;
x_ret = x + dt * (k1 + 2.*k2 + 2.*k3 + k4) ./ 6;
end

