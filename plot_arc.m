% arc drawing function
function arcXY = plot_arc(ang, r, center)
% ang - array of arc angles
% r - arc radius
% center - arc center
x = r*cosd(ang) + center(1); 
y = r*sind(ang) + center(2);
arcXY = [x; y].';
plot(x, y, '--', 'linewidth',3); 
end