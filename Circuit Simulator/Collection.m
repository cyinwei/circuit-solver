%Class that stores node voltage equation data for each node
%Stores voltage (from vsources), resistance (from resistors), and current (from csources) and the previous node as result of each traversal
classdef Collection
    properties
        prev_node
        voltage
        resistance
        current
    end
     methods
        function obj = Collection(n) %Constructor, takes previous node id
            obj.prev_node=n;
            obj.voltage=0;
            obj.resistance=0;
            obj.current=0;
        end
    end
end
