c=Circuit();
c.AddVSource(100,1,4);
c.AddResistor(10,2,1);
c.AddResistor(10,3,2);
c.AddResistor(10,4,5);
c.SetGround(5);
c.MakeEquations();