c=Circuit();
c.AddVSource(12,1,6);
c.AddResistor(10,2,1);
c.AddResistor(8,3,2);
c.AddCSource(8,3,2);
c.AddResistor(7,5,2);
c.AddResistor(50,6,3);
c.AddResistor(10,4,2);
c.AddResistor(21,4,3);
c.AddResistor(36,4,5);
c.AddResistor(18,4,6);
c.AddResistor(24,6,5);
c.AddResistor(0,7,2);
c.AddResistor(0,8,3);
c.AddVSource(8,6,3);
c.SetGround(6);
c.MakeEquations();