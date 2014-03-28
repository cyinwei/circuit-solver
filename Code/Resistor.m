%Class used as a template for a resistor in the circuit
classdef Resistor
    properties
        resistance %Resistance on resistor
        voltage %Calculated voltage on resistor
        current %Calculated current on resistor
        power %Calculated power on resistor
        node1 %Node connected to (declared) positive terminal
        node2 %Node connected to (declared) negative terminal
    end
    methods
        function obj = Resistor(r, n1, n2) %Constructor; takes resistance value, node 1 (id), and node 2 (id)
            obj.resistance = r;
            obj.node1 = n1;
            obj.node2 = n2;
        end
    end
end
