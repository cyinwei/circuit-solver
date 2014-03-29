c=Circuit();
c.AddVSource(100,1,3);
c.AddResistor(1000,2,1);
c.AddResistor(1000,3,2);
c.AddResistor(0,3,2);
c.SetGround(3);
c.MakeEquations();