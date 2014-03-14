classdef Identifier
    properties
        type='';
        index=-1;
        %for node analysis
        positive=false;
    end
    methods
        function obj = Identifier(t,ind,p)
            obj.type=t;
            obj.index=ind;
            obj.positive=p;
        end
    end
end
