<<<<<<< HEAD
%Class that serves as an abstraction to connect any circuit elements
%(vsource, csource, or resistor) to a node
classdef Identifier
    properties
        type=''; %Identifies the type of element that the identifier is associated with; v=vsource, c=csource, r=resistor
        index=-1; %Stores the index of the vsource, csource, or resistor in its array in th associated Circuit class
        %for node analysis
        positive=false; %Identifies if the element is connected to the positive terminal of the node
        traversed=false; %For traversal algorithm: identifies if the identifier was already used for a traversal
        adjNode;
        cId;
        vCurrent=inf;
    end
    methods
        function obj = Identifier(t,ind,p,aNode, i) %Constructor; takes element type, index, and if it is connected to the nodes positive terminal
            obj.type=t;
            obj.index=ind;
            obj.positive=p;
            obj.traversed=false;
            obj.adjNode=aNode;
            obj.cId=i;
        end
    end
end
=======
%Class that serves as an abstraction to connect any circuit elements
%(vsource, csource, or resistor) to a node
classdef Identifier
    properties
        type=''; %Identifies the type of element that the identifier is associated with; v=vsource, c=csource, r=resistor
        index=-1; %Stores the index of the vsource, csource, or resistor in its array in th associated Circuit class
        %for node analysis
        positive=false; %Identifies if the element is connected to the positive terminal of the node
        traversed=false; %For traversal algorithm: identifies if the identifier was already used for a traversal
        adjNode;
        cId;
        vCurrent=inf;
    end
    methods
        function obj = Identifier(t,ind,p,aNode, i) %Constructor; takes element type, index, and if it is connected to the nodes positive terminal
            obj.type=t;
            obj.index=ind;
            obj.positive=p;
            obj.traversed=false;
            obj.adjNode=aNode;
            obj.cId=i;
        end
    end
end
>>>>>>> 3da1db6a338cf615ebb0ffbac6d91b23be6d27e7
