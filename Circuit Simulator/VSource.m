classdef VSource
    properties
        voltage
        current
        power
        node1
        node2
    end
    methods
        function obj = VSource(v, n1, n2)
            obj.voltage = v;
            obj.node1 = n1;
            obj.node2 = n2;
        end
    end
end
