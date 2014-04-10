c=Circuit();
c.AddVSource(12,1,8,'V3');
c.AddResistor(100,2,1,'R20');
c.AddResistor(300,4,2,'R4');
c.AddResistor(100,5,4,'R5');
c.AddResistor(200,3,2,'R6');
c.AddCSource(3,5,3,'C2');
c.AddResistor(400,6,5,'R7');
c.AddResistor(350,7,6,'R8');
c.AddCSource(2,7,6,'C5');
c.AddResistor(150,8,7,'R9');
c.AddResistor(200,4,2,'R10');
c.AddResistor(150,5,2,'R11');
c.SetGround(8);
c.MakeEquations();
c.StartDrawTraverse();
c.grid=Grid(c.drawLoops,c.drawCompLoops,c.drawOrients,c.nodeCon);

d = VisualGrid(c, c.grid);