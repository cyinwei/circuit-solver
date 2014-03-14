% This script draws a current source

r=1.0;
N=100;
for k=1:N+1
	x(k)=r*cos(2*pi*k/N);
y(k)=r*sin(2*pi*k/N);
end
plot(x,y)
  axis([-10 10 -10 10])
  line([0 0], [ -0.5 0.5])
  line([-0.25 0], [0.25 0.5])
  line([0.25 0], [0.25 0.5])
  line([0 0], [1 3])
  line([0 0], [-1 -3])
