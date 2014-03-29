c=Circuit();
c.AddVSource(10,1,5);
c.AddResistor(10,1,2);
c.AddCSource(5,3,2);
c.AddResistor(10,3,4);
c.AddVSource(3,4,5);
c.SetGround(5);