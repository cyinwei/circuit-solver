function DrawVSource(x_off, y_off, orient)
r=1.0;
N=100;
for k=1:N+1
    x(k)=r*cos(2*pi*k/N);
    y(k)=r*sin(2*pi*k/N);
end
plot(y+x_off,x+y_off,'-b')
axis([-10 10 -10 10])

if orient=='u'
    line([-0.2+x_off 0.2+x_off], [0.45+y_off 0.45+y_off])
    line([0+x_off 0+x_off], [0.6+y_off 0.2+y_off])
    line([-0.2+x_off 0.2+x_off], [-0.45+y_off -0.45+y_off])
    line([0+x_off 0+x_off], [1+y_off 2+y_off])
    line([0+x_off 0+x_off], [-1+y_off -2+y_off])
    %It endpoints are at (x: 0,0 y:y_off + 2, y_off-2)
elseif orient=='d'
        line([-0.2+x_off 0.2+x_off], [-0.45+y_off -0.45+y_off])
        line([0+x_off 0+x_off], [-0.6+y_off -0.2+y_off])
        line([-0.2+x_off 0.2+x_off], [0.45+y_off 0.45+y_off])
        line([0+x_off 0+x_off], [1+y_off 2+y_off])
        line([0+x_off 0+x_off], [-1+y_off -2+y_off])
elseif orient=='r'
        line([0.5+x_off 0.5+x_off], [-0.2+y_off 0.2+y_off])
        line([0.25+x_off 0.65+x_off], [0+y_off 0+y_off])
        line([-0.75+x_off -0.35+x_off], [0+y_off 0+y_off])
        line([0+x_off 0+x_off], [1+y_off 2+y_off])
        line([0+x_off 0+x_off], [-1+y_off -2+y_off])
elseif orient=='l'
        line([-0.5+x_off -0.5+x_off], [-0.2+y_off 0.2+y_off])
        line([-0.25+x_off -0.65+x_off], [0+y_off 0+y_off])
        line([0.75+x_off 0.35+x_off], [0+y_off 0+y_off])
        line([0+x_off 0+x_off], [1+y_off 2+y_off])
        line([0+x_off 0+x_off], [-1+y_off -2+y_off])
end
end