%Class used as template for a node in the circuit
classdef Node<handle
   properties
        id %Node id
        connects=Identifier('n',-1,false,-1,-1); %Array of all identifiers used to identify each circuit element that the node is connected to
        collects=Collection(-1); %Used for traversal algorithm; stores data needed for KCL
        voltage %Calculated voltage on node
        current %This will be changed! (ignore this variable)
        ground %true if node is grounded
        drawn=false;
   end
   methods
       function obj = Node(i) %Constructor; takes node id
           obj.id = i;
           obj.connects(1)=[];
           obj.collects(1)=[];
           obj.ground=false;
       end
       
       function MakeGround(obj) %Called by Circuit class to ground the node
           obj.ground=true;
       end
   end
end