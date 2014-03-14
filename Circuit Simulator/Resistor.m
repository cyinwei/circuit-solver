classdef Resistor
    properties
        resistance
        voltage
        current
        power
        node1
        node2
    end
    methods
        function obj = Resistor(r, n1, n2)
            obj.resistance = r;
            obj.node1 = n1;
            obj.node2 = n2;
        end
    end
end
