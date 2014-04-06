%Class that is a template for voltage sources in the circuit
classdef VSource<handle
    properties
        voltage %Voltage on the voltage source
        current %Calculated current on voltage source
        power %Calculated power on voltage source
        node1 %Node (id) connected to positive terminal
        node2 %Node (id) connected to negative terminal
        id
        inLoop=false;
    end
    methods
        function obj = VSource(v, n1, n2, i) %Contructor; takes voltage, node 1 (id) and node 2 (id)
            obj.voltage = v;
            obj.node1 = n1;
            obj.node2 = n2;
            obj.id = i;
        end
        
        function PlacedInLoop(obj)
            obj.inLoop=true;
        end
    end
end
