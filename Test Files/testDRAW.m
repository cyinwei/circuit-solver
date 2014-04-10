<<<<<<< HEAD
c=Circuit();
c.AddVSource(12,1,5,'V1');
c.AddCSource(5,1,2,'C1');
c.AddResistor(100,4,2,'R1');
c.AddResistor(100,2,1,'R2');
c.AddResistor(100,3,2,'R3');
c.AddResistor(100,5,4,'R4');
c.AddResistor(100,4,3,'R5');
c.SetGround(5);
c.MakeEquations();
c.StartDrawTraverse();
c.grid=Grid(c.drawLoops,c.drawCompLoops,c.drawOrients,c.nodeCon);

=======
c=Circuit();
c.AddVSource(12,1,5,'V1');
c.AddCSource(5,1,2,'C1');
c.AddResistor(100,4,2,'R1');
c.AddResistor(100,2,1,'R2');
c.AddResistor(100,3,2,'R3');
c.AddResistor(100,5,4,'R4');
c.AddResistor(100,4,3,'R5');
c.SetGround(5);
c.MakeEquations();
c.StartDrawTraverse();
c.grid=Grid(c.drawLoops,c.drawCompLoops,c.drawOrients);

>>>>>>> 3da1db6a338cf615ebb0ffbac6d91b23be6d27e7
d = VisualGrid(c, c.grid);