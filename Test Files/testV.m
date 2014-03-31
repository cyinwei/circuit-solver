c=Circuit();
c.AddVSource(30,1,4,'V1');
c.AddResistor(1000,2,1,'R1');
c.AddResistor(2000,3,2,'R2');
c.AddVSource(15,3,2,'V2');
c.AddResistor(3000,4,3,'R3');
c.SetGround(4);
c.MakeEquations();