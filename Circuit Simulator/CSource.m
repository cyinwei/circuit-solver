%Class that is a template for current sources
classdef CSource
    properties
        current %Current source current value
        voltage %Calculated voltage on current source
        power %Calculated power on current source
        node1 %Node connected to on posisitive terminal
        node2 %Node connected to negative terminal
    end
    methods
        function obj = CSource(c, n1, n2) %Constructor, takes ids of both nodes connected to
            obj.current = c;
            obj.node1 = n1;
            obj.node2 = n2;
        end
    end
end
