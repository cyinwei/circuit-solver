classdef Circuit < handle
    properties
        vsources = VSource(-1,-1,-1);
        csources = CSource(-1,-1,-1);
        resistors = Resistor(-1,-1,-1);
        nodes = Node(-1);
    end
    methods
        function obj = Circuit()
            obj.vsources(1)=[];
            obj.csources(1)=[];
            obj.nodes(1)=[];
            obj.resistors(1)=[];
        end
        
        function AddVSource(obj, v, n1, n2)
            if n1 ~= n2
                obj.vsources(numel(obj.vsources)+1) = VSource(v, n1, n2);
                if obj.AddNode(n1)
                    obj.nodes(numel(obj.nodes)).connects(numel(obj.nodes(numel(obj.nodes)).connects)+1)=Identifier('v',numel(obj.vsources), true);
                else
                    for i = 1:numel(obj.nodes)
                        if obj.nodes(i).id==n1
                            obj.nodes(i).connects(numel(obj.nodes(numel(obj.nodes)).connects)+1)=Identifier('v',numel(obj.vsources), true);
                        end
                    end
                end
                
                if obj.AddNode(n2)
                    obj.nodes(numel(obj.nodes)).connects(numel(obj.nodes(numel(obj.nodes)).connects)+1)=Identifier('v',numel(obj.vsources), false);
                else
                    for i = 1:numel(obj.nodes)
                        if obj.nodes(i).id==n2
                            obj.nodes(i).connects(numel(obj.nodes(numel(obj.nodes)).connects)+1)=Identifier('v',numel(obj.vsources), false);
                        end
                    end
                end
            else
                disp('Nodes cannot be the same!');
            end
        end
        
        function AddCSource(obj, c, n1, n2)
            if n1 ~= n2
                obj.csources(numel(obj.csources)+1) = CSource(c, n1, n2);
                if obj.AddNode(n1)
                    obj.nodes(numel(obj.nodes)).connects(numel(obj.nodes(numel(obj.nodes)).connects)+1)=Identifier('c',numel(obj.csources), true);
                else
                    for i = 1:numel(obj.nodes)
                        if obj.nodes(i).id==n1
                            obj.nodes(i).connects(numel(obj.nodes(numel(obj.nodes)).connects)+1)=Identifier('c',numel(obj.csources), true);
                        end
                    end
                end
                
                if obj.AddNode(n2)
                    obj.nodes(numel(obj.nodes)).connects(numel(obj.nodes(numel(obj.nodes)).connects)+1)=Identifier('c',numel(obj.csources), false);
                else
                    for i = 1:numel(obj.nodes)
                        if obj.nodes(i).id==n2
                            obj.nodes(i).connects(numel(obj.nodes(numel(obj.nodes)).connects)+1)=Identifier('c',numel(obj.csources), false);
                        end
                    end
                end
            else
                disp('Nodes cannot be the same!');
            end
        end
        
        function AddResistor(obj, r, n1, n2)
            if n1 ~= n2
                obj.resistors(numel(obj.resistors)+1) = Resistor(r, n1, n2);
                if obj.AddNode(n1)
                    obj.nodes(numel(obj.nodes)).connects(numel(obj.nodes(numel(obj.nodes)).connects)+1)=Identifier('r',numel(obj.resistors), true);
                else
                    for i = 1:numel(obj.nodes)
                        if obj.nodes(i).id==n1
                            obj.nodes(i).connects(numel(obj.nodes(numel(obj.nodes)).connects)+1)=Identifier('r',numel(obj.resistors), true);
                        end
                    end
                end
                
                if obj.AddNode(n2)
                    obj.nodes(numel(obj.nodes)).connects(numel(obj.nodes(numel(obj.nodes)).connects)+1)=Identifier('r',numel(obj.resistors), false);
                else
                    for i = 1:numel(obj.nodes)
                        if obj.nodes(i).id==n2
                            obj.nodes(i).connects(numel(obj.nodes(numel(obj.nodes)).connects)+1)=Identifier('r',numel(obj.resistors), false);
                        end
                    end
                end
            else
                disp('Notes cannot be the same!');
            end
        end
        
        function added = AddNode(obj, id)
            if not(obj.CheckNode(id))
                obj.nodes(numel(obj.nodes)+1) = Node(id);
                added = true;
            else
                added=false;
            end
        end
             
        function found = CheckNode(obj, n)
            found=false;
            for i = 1:numel(obj.nodes)
                if obj.nodes(i).id==n
                    found=true;
                end
            end
        end
        
        function SetGround(obj, ids)
            for i = 1:numel(obj.nodes)
                if obj.nodes(i).id==ids
                    obj.nodes(i).MakeGround();
                end
            end
        end
        
        function Draw(obj)
            %Find the ground
            
        end
    end
end
