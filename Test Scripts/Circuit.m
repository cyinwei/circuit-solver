
%Circuit class that stores all circuit elements and contains all function for solving algorithm
classdef Circuit < handle
    properties
        vsources = VSource(-1,-1,-1); %Array of all voltage sources, initialize with dummy vsource
        csources = CSource(-1,-1,-1); %Array of all current sources, initialize with dummy csource
        resistors = Resistor(-1,-1,-1); %Array of all resistors, initialize with dummy resistor
        nodes = Node(-1); %Array of all nodes in the circuit, initialize with dummy node
        isClosed=false;
        firstNode=-1;
    end
    methods
        %Circuit constructor, declare all properties as arrays and clear them of dummies
        function obj = Circuit()
            obj.vsources(1)=[];
            obj.csources(1)=[];
            obj.nodes(1)=[];
            obj.resistors(1)=[];
        end
        
        %Function that adds a voltage source to the circuit, adds new nodes as needed
        %the voltage (v), positive node (n1) and negative node (n2) are given
        function AddVSource(obj, v, n1, n2)
            if n1 ~= n2 %Ensure that n1 is not equal to n2 (that would be an error, since you need 2 different nodes)
                obj.vsources(end+1) = VSource(v, n1, n2); %Add the vsource to the circuit
                if obj.AddNode(n1) %If n1 does not exist (ie- the AddNode function added a new node)                    
                    obj.nodes(end).connects(end+1)=Identifier('v',numel(obj.vsources), true,n2); %Add identifier to n1 to identify new vsource connected to n1
                else %If n1 exists, find it
                    for i = 1:numel(obj.nodes)
                        if obj.nodes(i).id==n1
                            obj.nodes(i).connects(end+1)=Identifier('v',numel(obj.vsources), true,n2); %Add identifier to n1 to identify new vsource connected to n1
                            break;
                        end
                    end
                end
                
                if obj.AddNode(n2) %If n2 does not exist (ie- the AddNode function added a new node)
                    obj.nodes(end).connects(end+1)=Identifier('v',numel(obj.vsources), false,n1);  %Add identifier to n2 to identify new vsource connected to n2
                else  %If n2 exists, find it
                    for i = 1:numel(obj.nodes)
                        if obj.nodes(i).id==n2
                            obj.nodes(i).connects(end+1)=Identifier('v',numel(obj.vsources), false,n1); %Add identifier to n2 to identify new vsource connected to n2
                            break;
                        end
                    end
                end
            else %If n1=n2
                disp('In function AddVSource: Nodes cannot be the same!');
            end
        end
        
        %Function that adds a current source to the circuit, adds new nodes as needed
        %the current (c), positive node (n1) and negative node (n2) are given
        function AddCSource(obj, c, n1, n2)
            if n1 ~= n2 %Ensure that n1 is not equal to n2 (that would be an error)
                obj.csources(end+1) = CSource(c, n1, n2); %Add the csource to the circuit
                if obj.AddNode(n1) %If n1 does not exist (ie- the AddNode function added a new node)
                    obj.nodes(end).connects(end+1)=Identifier('c',numel(obj.csources), true,n2); %Add identifier to n1 to identify new csource connected to n1
                else %If n1 exists, find it
                    for i = 1:numel(obj.nodes)
                        if obj.nodes(i).id==n1
                            obj.nodes(i).connects(numel(obj.nodes(i).connects)+1)=Identifier('c',numel(obj.csources), true,n2); %Add identifier to n1 to identify new csource connected to n1
                            break;
                        end
                    end
                end
                
                if obj.AddNode(n2) %If n2 does not exist (ie- the AddNode function added a new node)
                    obj.nodes(end).connects(end+1)=Identifier('c',numel(obj.csources), false,n1); %Add identifier to n2 to identify new csource connected to n2
                else %If n2 exists, find it
                    for i = 1:numel(obj.nodes)
                        if obj.nodes(i).id==n2
                            obj.nodes(i).connects(end+1)=Identifier('c',numel(obj.csources), false,n1); %Add identifier to n2 to identify new csource connected to n2
                            break;
                        end
                    end
                end
            else
                disp('In function AddCSource: Nodes cannot be the same!');
            end
        end
        
        %Function that adds a resistor to the circuit, adds new nodes as needed
        %the current (r), declared positive node (n1) and declared negative node (n2) are given
        function AddResistor(obj, r, n1, n2)
            if n1 ~= n2 %Ensure that n1 is not equal to n2 (that would be an error)
                obj.resistors(end+1) = Resistor(r, n1, n2); %Add the resistor to the circuit
                if obj.AddNode(n1) %If n1 does not exist (ie- the AddNode function added a new node)
                    obj.nodes(end).connects(end+1)=Identifier('r',numel(obj.resistors), true,n2); %Add identifier to n1 to identify new resistor connected to n1
                else %If n1 exists, find it
                    for i = 1:numel(obj.nodes)
                        if obj.nodes(i).id==n1
                            obj.nodes(i).connects(end+1)=Identifier('r',numel(obj.resistors), true,n2); %Add identifier to n1 to identify new resistor connected to n1
                            break;
                        end
                    end
                end
                
                if obj.AddNode(n2) %If n2 does not exist (ie- the AddNode function added a new node)
                    obj.nodes(end).connects(end+1)=Identifier('r', numel(obj.resistors), false,n1); %Add identifier to n2 to identify new resistor connected to n2
                else %If n2 exists, find it
                    for i = 1:numel(obj.nodes)
                        if obj.nodes(i).id==n2
                             obj.nodes(i).connects(end+1)=Identifier('r',numel(obj.resistors), false,n1); %Add identifier to n2 to identify new resistor connected to n2
                            break;
                        end
                    end
                end
            else
                disp('Nodes cannot be the same!');
            end
        end
        
        %Adds a new node to the circuit; called by AddVSource, AddCSource and AddResistor
        %Creates a new node with given id if it does not exist
        %Returns true if the node was added (ie- did not already) exist, false otherwise
        function added = AddNode(obj, id)
            if not(obj.CheckNode(id)) %Make sure the node does not already exist
                obj.nodes(end+1) = Node(id);
                added = true;
            else
                added=false;
            end
        end
        
        %Checks if a node with id n already exists in the circuit
        %Resturns true if the node was already exists, false otherwise
        function found = CheckNode(obj, n)
            found=false;
            for i = 1:numel(obj.nodes)
                if obj.nodes(i).id==n
                    found=true;
                end
            end
        end
        
        %Returns a node object corresponding to the node in the circuit with given id n
        function theNode = GetNode(obj, n)
            for i = 1:numel(obj.nodes)
                if obj.nodes(i).id==n
                    theNode = obj.nodes(i);
                end
            end
        end
        
        %Function that sets the ground status for a given node with id ids to true (ie- connects that node to ground)
        function SetGround(obj, ids)
            for i = 1:numel(obj.nodes)
                if obj.nodes(i).id==ids
                    obj.nodes(i).MakeGround();
                end
            end
        end
        
        %Function that may/may not be used (part of graphics)
        function Draw(obj)
             
        end
        
        %Initialization part of algroithm that finds the first grounded node and makes the first call for the traversal algorithm to accumulate KCL data
        %This function should probably be renamed at some point
        function MakeEquations(obj)
            Node temp; %Variable that will reference the grounded node
            found=false;
            for i = 1:numel(obj.nodes) %Find the first grounded node
                if obj.nodes(i).ground
                    temp = obj.nodes(i);
                    found=true;
                    break;
                end
            end
            
            if found %If a grounded node was found
                obj.Traverse(temp); %Start the traversal algorithm from the grounded node
                if obj.isClosed
                    obj.SolveCircuit(); %With accumulated data for KCLs from traversal algorithm, solve the node voltages
                    obj.ValueResistors(); %With node voltages, find the voltage and current on each resistor
                    obj.ValueOpenNodes();
                else
                    disp('Error: Circuit is not closed!');
                end
                
            else %If grounded node not found, bail out
                disp('Ground is not set!');
            end
        end
        
        %Function that takes collected KCL data and solves for node voltages
        %Converts collected KCL data and puts it into matrix form
        %Stores all the solved voltages on each node in the circuit
        function SolveCircuit(obj)
            A=[]; %[A][X]
            B=[]; %=[B]
            nodeEnum=[]; %Enumeration array used to translate node ids to index in node array
            nonGroundCount=0; %Counts number of non-grounded nodes found
            groundCount=0; %Counts number of grounded nodes found
            for i=1:numel(obj.nodes); %Setup up the enumeration array
                if ~obj.nodes(i).ground
                    nodeEnum(obj.nodes(i).id) = i-groundCount;
                    nonGroundCount = nonGroundCount+1;
                else
                    groundCount=groundCount+1;
                end
            end
            
            for i=1:numel(obj.nodes); %Make the matrices
                tempA = zeros(1,nonGroundCount); %Current working row in matrix A
                tempB = 0; %Current working entry in matrix B
                if ~(numel(obj.nodes(i).collects)<2)
                    for j=1:numel(obj.nodes(i).collects) %Go through each Collection on the node
                        tempC = obj.nodes(i).collects(j);
                        resCorr=false; %Determine if we need to take into account that we have no resistance in the Collection
                        if tempC.resistance == 0 %Special cases where we have no resistance
                            if tempC.current == 0 && tempC.voltage ~= 0 && ~(numel(tempC.prev_node.connects)<2) %Special case: only have voltage on Collection, just stick a 1 into [A] and voltage value on [B]
                                tempA = zeros(1,nonGroundCount);
                                tempA(nodeEnum(obj.nodes(i).id)) = 1;
                                tempB = -tempC.voltage;
                                break;
                            else %Special case: set resistance to 1 so we don't divide by 0
                                tempC.resistance = 1;
                                resCorr=true;
                            end
                        end
                        tempB = tempB - (tempC.voltage/tempC.resistance);  %Set the entry in [B] for current row
                        tempB = tempB + tempC.current;
                        if ~resCorr %Take into account previous node if we have current and/or resistance on Collection
                            tempA(nodeEnum(obj.nodes(i).id)) = tempA(nodeEnum(obj.nodes(i).id)) - 1/tempC.resistance;
                        end
                        if ~tempC.prev_node.ground && ~resCorr && ~(numel(tempC.prev_node.connects)<2) %Don't use previous node if it is grounded or open node
                            tempA(nodeEnum(tempC.prev_node.id)) = tempA(nodeEnum(tempC.prev_node.id)) + 1/tempC.resistance;
                        end
                    end
                end
                A=[A;tempA]; %Add row entry into [A]
                B=[B;tempB]; %Add row entry into [B]
            end
            disp(A);
            disp(B);
            
            nodeVolts = linsolve(A,B); %Solve the matrix equation
            disp(nodeVolts);
            j = 1;
            for i=1:numel(obj.nodes) %Put the solved node voltages onto corresponding nodes
                if ~obj.nodes(i).ground
                    obj.nodes(i).voltage = nodeVolts(j);
                    disp(obj.nodes(i).id);
                    disp(nodeVolts(j));
                    j=j+1;
                else
                    obj.nodes(i).voltage=0; %Put 0 volts on grounded nodes
                end
            end
        end
        
        %Function that takes solved node voltages and solves for voltage, current, and power on each resistor
        function ValueResistors(obj)
            for i=1:numel(obj.resistors)
                obj.resistors(i).voltage = abs(obj.GetNode(obj.resistors(i).node1).voltage - obj.GetNode(obj.resistors(i).node2).voltage);
                obj.resistors(i).current = obj.resistors(i).voltage/obj.resistors(i).resistance;
                obj.resistors(i).power = obj.resistors(i).voltage * obj.resistors(i).current;
            end
        end
        
        %Function that takes solved node voltages and solves for voltage and power on each csource
        function ValueCSources(obj)
            for i=1:numel(obj.csources)
                obj.csources(i).voltage = abs(obj.GetNode(obj.csources(i),node1).voltage - obj.GetNode(obj.csources(i).node2).voltage);
                obj.csources(i).power = obj.csources(i).voltage * obj.csources(i).current;
            end
        end    
        
        function ValueOpenNodes(obj)
            for i=1:numel(obj.nodes)
                if (obj.nodes(i).voltage==0 && ~obj.nodes(i).ground && (obj.nodes(i).connects(1).type=='r'))
                    obj.nodes(i).voltage = obj.GetNode(obj.nodes(i).connects(1).adjNode).voltage;
                end
            end
        end
        
        %Traversal method for Collection algorithm; Collects the KCL data for all nodes
        %Recursively
        function Traverse(obj, curNode)
            if (obj.firstNode == -1 && ~curNode.ground)
                obj.firstNode = curNode.id
            end
            for i = 1:numel(curNode.connects)
                t = Collection(curNode); %Setup a Collection object to stick on node we are going to
                if ~curNode.connects(i).traversed %Make sure the connection has not been traversed
                    curNode.connects(i).traversed=true;
                    if obj.GetNode(curNode.connects(i).adjNode).ground && curNode.id ~= obj.firstNode
                        obj.isClosed=true;
                    end
                    if curNode.connects(i).type=='v' %We found a voltage source
                        if curNode.connects(i).positive && ~obj.GetNode(obj.vsources(curNode.connects(i).index).node2).ground %If we are coming from the positive terminal of the vsource
                            t.voltage = t.voltage + obj.vsources(curNode.connects(i).index).voltage;
                            obj.GetNode(obj.vsources(curNode.connects(i).index).node2).collects(numel(obj.GetNode(obj.vsources(curNode.connects(i).index).node2).collects)+1) = t;
                            obj.Traverse(obj.GetNode(obj.vsources(curNode.connects(i).index).node2));
                        elseif ~curNode.connects(i).positive && ~obj.GetNode(obj.vsources(curNode.connects(i).index).node1).ground %If we are coming from the negative terminal of the vsource
                            t.voltage = t.voltage - obj.vsources(curNode.connects(i).index).voltage;
                            obj.GetNode(obj.vsources(curNode.connects(i).index).node1).collects(numel(obj.GetNode(obj.vsources(curNode.connects(i).index).node1).collects)+1) = t;
                            obj.Traverse(obj.GetNode(obj.vsources(curNode.connects(i).index).node1));
                        end
                    elseif curNode.connects(i).type=='c' %We found a current source
                        if curNode.connects(i).positive && ~obj.GetNode(obj.csources(curNode.connects(i).index).node2).ground %If we are coming from the positive terminal of the csource
                            t.current = t.current + obj.csources(curNode.connects(i).index).current;
                            obj.GetNode(obj.csources(curNode.connects(i).index).node2).collects(numel(obj.GetNode(obj.csources(curNode.connects(i).index).node2).collects)+1) = t;
                            obj.Traverse(obj.GetNode(obj.csources(curNode.connects(i).index).node2));
                        elseif ~curNode.connects(i).positive && ~obj.GetNode(obj.csources(curNode.connects(i).index).node1).ground %If we are coming from the negative terminal of the csource
                            t.current = t.current - obj.csources(curNode.connects(i).index).current;
                            obj.GetNode(obj.csources(curNode.connects(i).index).node1).collects(numel(obj.GetNode(obj.csources(curNode.connects(i).index).node1).collects)+1) = t;
                            obj.Traverse(obj.GetNode(obj.csources(curNode.connects(i).index).node1));
                        end
                    elseif curNode.connects(i).type=='r' %We found a resistor
                        if curNode.connects(i).positive && ~obj.GetNode(obj.resistors(curNode.connects(i).index).node2).ground
                            t.resistance = t.resistance + obj.resistors(curNode.connects(i).index).resistance;
                            obj.GetNode(obj.resistors(curNode.connects(i).index).node2).collects(numel(obj.GetNode(obj.resistors(curNode.connects(i).index).node2).collects)+1) = t;
                            obj.Traverse(obj.GetNode(obj.resistors(curNode.connects(i).index).node2));
                        elseif ~curNode.connects(i).positive && ~obj.GetNode(obj.resistors(curNode.connects(i).index).node1).ground
                            t.resistance = t.resistance + obj.resistors(curNode.connects(i).index).resistance;
                            obj.GetNode(obj.resistors(curNode.connects(i).index).node1).collects(numel(obj.GetNode(obj.resistors(curNode.connects(i).index).node1).collects)+1) = t;
                            obj.Traverse(obj.GetNode(obj.resistors(curNode.connects(i).index).node1));
                        end
                    end
                end
            end
        end
        
        %Print out all nodes with IDs and solved node voltages
        function PrintNodeVoltages(obj)
            for i=1:numel(obj.nodes)
                fprintf('Node %d: %fV', obj.nodes(i).id,obj.nodes(i).voltage);
                disp(' ');
            end
        end
    end
end



