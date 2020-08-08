function auxdata = set_auxdata()
%SET_AUXDATA auxdataを設定する

auxdata.g = 9.80665;  % 重力加速度[m/s^2]

auxdata.m1 = 1.00;  % おもり1の重さ[kg]
auxdata.m2 = 1.00;  % おもり2の重さ[kg]
auxdata.l1 = 0.60;  % ロッド1の長さ[m]
auxdata.l2 = 0.60;  % ロッド2の長さ[m]
auxdata.c1 = 0.00;  % 粘性抵抗1[kgm^2/s]
auxdata.c2 = 0.00;  % 粘性抵抗2[kgm^2/s]
end

