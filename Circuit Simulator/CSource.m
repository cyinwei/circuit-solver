classdef CSource
    properties
        current
        voltage
        power
        node1
        node2
    end
    methods
        function obj = CSource(c, n1, n2)
            obj.current = c;
            obj.node1 = n1;
            obj.node2 = n2;
        end
    end
end
