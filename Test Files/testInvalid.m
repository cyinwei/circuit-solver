c=Circuit();
c.AddVSource(12,1,2);
c.AddVSource(8,1,2);
c.SetGround(2);
c.MakeEquations();