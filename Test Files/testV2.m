<<<<<<< HEAD
c=Circuit();
c.AddVSource(-30,1,5,'V1');
c.AddResistor(1000,2,1,'R1');
c.AddResistor(3000,3,2,'R2');
c.AddResistor(4000,4,3,'R3');
c.AddResistor(7000,5,4,'R4');
c.AddVSource(-15,3,2,'V2');
c.AddVSource(-22,4,3,'V3');
%c.AddVSource(29,4,3,'V4');
c.SetGround(5);
=======
c=Circuit();
c.AddVSource(-30,1,5,'V1');
c.AddResistor(1000,2,1,'R1');
c.AddResistor(3000,3,2,'R2');
c.AddResistor(4000,4,3,'R3');
c.AddResistor(7000,5,4,'R4');
c.AddVSource(-15,3,2,'V2');
c.AddVSource(-22,4,3,'V3');
%c.AddVSource(29,4,3,'V4');
c.SetGround(5);
>>>>>>> 3da1db6a338cf615ebb0ffbac6d91b23be6d27e7
c.MakeEquations();