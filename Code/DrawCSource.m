function DrawCSource(x_off, y_off, orient)
r=1.0;
N=100;
for k=1:N+1
    x(k)=r*cos(2*pi*k/N);
    y(k)=r*sin(2*pi*k/N);
end
plot(y+x_off,x+y_off,'-b')
axis([-10 10 -10 10])

if orient=='u'
    line([0+x_off 0+x_off], [ -0.5+y_off 0.5+y_off])
    line([-0.25+x_off 0+x_off], [0.25+y_off 0.5+y_off])
    line([0.25+x_off 0+x_off], [0.25+y_off 0.5+y_off])
    line([0+x_off 0+x_off], [1+y_off 2+y_off])
    line([0+x_off 0+x_off], [-1+y_off -2+y_off])
elseif orient=='d'
        line([0+x_off 0+x_off], [ -0.5+y_off 0.5+y_off])
        line([-0.25+x_off 0+x_off], [-0.25+y_off -0.5+y_off])
        line([0.25+x_off 0+x_off], [-0.25+y_off -0.5+y_off])
        line([0+x_off 0+x_off], [1+y_off 2+y_off])
        line([0+x_off 0+x_off], [-1+y_off -2+y_off])
elseif orient=='r'
        line([-0.5+x_off 0.5+x_off], [ 0+y_off 0+y_off])
        line([0.25+x_off 0.5+x_off], [0.25+y_off 0+y_off])
        line([0.5+x_off 0.25+x_off], [0+y_off -0.25+y_off])
        line([0+x_off 0+x_off], [1+y_off 2+y_off])
        line([0+x_off 0+x_off], [-1+y_off -2+y_off])
elseif orient=='l'
        line([-0.5+x_off 0.5+x_off], [ 0+y_off 0+y_off])
        line([-0.25+x_off -0.5+x_off], [0.25+y_off 0+y_off])
        line([-0.5+x_off -0.25+x_off], [0+y_off -0.25+y_off])
        line([0+x_off 0+x_off], [1+y_off 2+y_off])
        line([0+x_off 0+x_off], [-1+y_off -2+y_off])
end 
end