c=Circuit();
c.AddCSource(6,1,4);
c.AddResistor(5,2,1);
c.AddResistor(24,3,2);
c.AddResistor(15,4,2);
c.AddResistor(30,4,3);
c.SetGround(4);
c.MakeEquations();