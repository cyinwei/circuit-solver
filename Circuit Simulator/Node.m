classdef Node<handle
   properties
        id
        connects=Identifier('n',-1,false);
        voltage
        current
        ground
   end
   methods
       function obj = Node(i)
           obj.id = i;
           obj.connects(1)=[];
           obj.ground=false;
       end
       
       function MakeGround(obj)
           obj.ground=true;
       end
   end
end