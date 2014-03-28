function DrawResistor(x_off, y_off, orient)
if orient=='h'
   line([-1+x_off -0.75+x_off], [0+y_off -0.5+y_off])
   line([-0.75+x_off -0.5+x_off], [-0.5+y_off 0+y_off])
   line([-0.5+x_off -0.25+x_off], [0+y_off 0.5+y_off])
   line([-0.25+x_off 0+x_off], [0.5+y_off 0+y_off])
   line([0+x_off 0.25+x_off], [0+y_off -0.5+y_off])
   line([0.25+x_off 0.5+x_off], [-0.5+y_off 0+y_off])
   line([0.5+x_off 0.75+x_off], [0+y_off 0.5+y_off])
   line([0.75+x_off 1+x_off], [0.5+y_off 0+y_off])
   %endpoint lines
   line([-2+x_off -1+x_off], [y_off, y_off])
   line([1+x_off 2+x_off], [y_off, y_off])
   
   axis([-10 10 -10 10])
elseif orient=='v'
   line([0+x_off -0.5+x_off], [-1+y_off -0.75+y_off])
   line([-0.5+x_off 0+x_off], [-0.75+y_off -0.5+y_off])
   line([0+x_off 0.5+x_off], [-0.5+y_off -0.25+y_off])
   line([0.5+x_off 0+x_off], [-0.25+y_off 0+y_off])
   line([0+x_off -0.5+x_off], [0+y_off 0.25+y_off])
   line([-0.5+x_off 0+x_off], [0.25+y_off 0.5+y_off])
   line([0+x_off 0.5+x_off], [0.5+y_off 0.75+y_off])
   line([0.5+x_off 0+x_off], [0.75+y_off 1+y_off])
   %endpoint lines
   line([x_off, x_off], [-2+y_off -1+y_off])
   line([x_off, x_off], [1+y_off 2+y_off])
   axis([-10 10 -10 10])
end
end