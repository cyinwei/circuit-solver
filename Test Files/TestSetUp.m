c=Circuit();
c.AddVSource(10,1,3);
c.AddResistor(1000,1,2);
c.AddResistor(1500,2,3);
c.AddResistor(1000,2,3);
c.SetGround(3);
c.MakeEquations();
