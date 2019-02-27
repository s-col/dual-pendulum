function angle_n = normalize_angle(angle)
%NORMALIZE_ANGLE Šp“x‚ð-pi`pi‚É³‹K‰»‚·‚é

angle_n = angle - floor(angle/(2*pi)).*(2*pi);

over_pi = angle_n > pi;
angle_n(over_pi) = - 2*pi + angle_n(over_pi);
end

