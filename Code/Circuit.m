
%Circuit class that stores all circuit elements and contains all function for solving algorithm
classdef Circuit < handle
    properties
        vsources = VSource(-1,-1,-1,-1); %Array of all voltage sources, initialize with dummy vsource
        csources = CSource(-1,-1,-1,-1); %Array of all current sources, initialize with dummy csource
        resistors = Resistor(-1,-1,-1,-1); %Array of all resistors, initialize with dummy resistor
        nodes = Node(-1); %Array of all nodes in the circuit, initialize with dummy node
        isClosed=false; %Check if we have a closed loop
        firstNode=-1;
        loops=[]; %Temporary loops per traversal
        drawLoops=[]; %Chosen loops for draw
        compLoops=[]; %Temporary component loops
        orients=[]; %Chosen draw components orientations
        drawCompLoops=[]; %Chosen looops for draw components
        drawOrients=[];
        grid
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
        function AddVSource(obj, v, n1, n2, id)
            if n1 ~= n2 %Ensure that n1 is not equal to n2 (that would be an error, since you need 2 different nodes)
                obj.vsources(end+1) = VSource(v, n1, n2, id); %Add the vsource to the circuit
                if obj.AddNode(n1) %If n1 does not exist (ie- the AddNode function added a new node)                    
                    obj.nodes(end).connects(end+1)=Identifier('v',numel(obj.vsources), true,n2, id); %Add identifier to n1 to identify new vsource connected to n1
                else %If n1 exists, find it
                    for i = 1:numel(obj.nodes)
                        if obj.nodes(i).id==n1
                            obj.nodes(i).connects(end+1)=Identifier('v',numel(obj.vsources), true,n2, id); %Add identifier to n1 to identify new vsource connected to n1
                            break;
                        end
                    end
                end
                
                if obj.AddNode(n2) %If n2 does not exist (ie- the AddNode function added a new node)
                    obj.nodes(end).connects(end+1)=Identifier('v',numel(obj.vsources), false,n1, id);  %Add identifier to n2 to identify new vsource connected to n2
                else  %If n2 exists, find it
                    for i = 1:numel(obj.nodes)
                        if obj.nodes(i).id==n2
                            obj.nodes(i).connects(end+1)=Identifier('v',numel(obj.vsources), false,n1, id); %Add identifier to n2 to identify new vsource connected to n2
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
        function AddCSource(obj, c, n1, n2, id)
            if n1 ~= n2 %Ensure that n1 is not equal to n2 (that would be an error)
                obj.csources(end+1) = CSource(c, n1, n2, id); %Add the csource to the circuit
                if obj.AddNode(n1) %If n1 does not exist (ie- the AddNode function added a new node)
                    obj.nodes(end).connects(end+1)=Identifier('c',numel(obj.csources), true,n2, id); %Add identifier to n1 to identify new csource connected to n1
                else %If n1 exists, find it
                    for i = 1:numel(obj.nodes)
                        if obj.nodes(i).id==n1
                            obj.nodes(i).connects(numel(obj.nodes(i).connects)+1)=Identifier('c',numel(obj.csources), true,n2, id); %Add identifier to n1 to identify new csource connected to n1
                            break;
                        end
                    end
                end
                
                if obj.AddNode(n2) %If n2 does not exist (ie- the AddNode function added a new node)
                    obj.nodes(end).connects(end+1)=Identifier('c',numel(obj.csources), false,n1, id); %Add identifier to n2 to identify new csource connected to n2
                else %If n2 exists, find it
                    for i = 1:numel(obj.nodes)
                        if obj.nodes(i).id==n2
                            obj.nodes(i).connects(end+1)=Identifier('c',numel(obj.csources), false,n1, id); %Add identifier to n2 to identify new csource connected to n2
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
        function AddResistor(obj, r, n1, n2, id)
            if n1 ~= n2 %Ensure that n1 is not equal to n2 (that would be an error)
                obj.resistors(end+1) = Resistor(r, n1, n2, id); %Add the resistor to the circuit
                if obj.AddNode(n1) %If n1 does not exist (ie- the AddNode function added a new node)
                    obj.nodes(end).connects(end+1)=Identifier('r',numel(obj.resistors), true,n2, id); %Add identifier to n1 to identify new resistor connected to n1
                else %If n1 exists, find it
                    for i = 1:numel(obj.nodes)
                        if obj.nodes(i).id==n1
                            obj.nodes(i).connects(end+1)=Identifier('r',numel(obj.resistors), true,n2, id); %Add identifier to n1 to identify new resistor connected to n1
                            break;
                        end
                    end
                end
                
                if obj.AddNode(n2) %If n2 does not exist (ie- the AddNode function added a new node)
                    obj.nodes(end).connects(end+1)=Identifier('r', numel(obj.resistors), false,n1, id); %Add identifier to n2 to identify new resistor connected to n2
                else %If n2 exists, find it
                    for i = 1:numel(obj.nodes)
                        if obj.nodes(i).id==n2
                             obj.nodes(i).connects(end+1)=Identifier('r',numel(obj.resistors), false,n1, id); %Add identifier to n2 to identify new resistor connected to n2
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
        
        function comp = GetComp(obj, n)
           tempT = n(1);
           n = n(2:end);
           if tempT=='V'
               comp = obj.vsources(str2double(n));
           elseif tempT=='C'
               comp = obj.csources(str2double(n));
           else tempT=='R'
               comp = obj.resistors(str2double(n));
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
        
        function [As,Bs]= MakeSuper(obj,curNode,otherNode,diffV,nodeEnum,first,nGC)
            disp('Super Call');
            disp(curNode.id);
            SA = zeros(1,nGC);
            SA(nodeEnum(curNode.id)) = 1;
            SA(nodeEnum(otherNode.id)) = -1;
            SB = -diffV;
            tempA=zeros(1,nGC);
            tempB=0;
            for i=1:numel(curNode.collects)
                if curNode.collects(i).prev_node.id ~= otherNode.id
                    tempC = curNode.collects(i);
                    resCorr=false; %Determine if we need to take into account that we have no resistance in the Collection
                    if tempC.resistance == 0 %Special cases where we have no resistance
                        if tempC.current == 0 && tempC.voltage ~= 0 && ~(numel(tempC.prev_node.connects)<2) %Special case: only have voltage on Collection, just stick a 1 into [A] and voltage value on [B]
                            if tempC.prev_node.ground
                               tempA = zeros(1,nGC);
                               tempA(nodeEnum(curNode.id)) = 1; 
                               tempB = -tempC.voltage;
                               break;
                            else %supernode
                                %tempA = zeros(1,nonGroundCount);
                                %tempA(nodeEnum(obj.nodes(i).id)) = 1;
                                %tempA(nodeEnum(tempC.prev_node.id)) = -1;
                                %tempB = -tempC.voltage;
                                [tA,tB]=obj.MakeSuper(curNode.collects(i).prev_node,curNode,-tempC.voltage,nodeEnum,false,nGC);
                                tempA=tA;
                                tempB=tB;
                               
                                break;
                            end

                        else %Special case: set resistance to 1 so we don't divide by 0
                            tempC.resistance = 1;
                            resCorr=true;
                        end
                    end
                    tempB = tempB - (tempC.voltage/tempC.resistance);  %Set the entry in [B] for current row
                    tempB = tempB + tempC.current;
                    if ~resCorr %Take into account previous node if we have current and/or resistance on Collection
                        tempA(nodeEnum(curNode.id)) = tempA(nodeEnum(curNode.id)) - 1/tempC.resistance;
                    end
                    if ~tempC.prev_node.ground && ~resCorr && ~(numel(tempC.prev_node.connects)<2) %Don't use previous node if it is grounded or open node
                        tempA(nodeEnum(tempC.prev_node.id)) = tempA(nodeEnum(tempC.prev_node.id)) + 1/tempC.resistance;
                    end

                end
            end
            oA=[];
            oB=[];
            if first
                [oA,oB]=obj.MakeSuper(otherNode,curNode,-diffV,nodeEnum,false,nGC);
                 disp('after rec');
                 disp(oA);
                 disp(oB);
            end
            if (numel(oA)~=0)
                disp(numel(tempA(1,:)));
                disp(numel(oA(1,:)));
                tempA(1,:)=tempA(1,:)+oA(1,:);
                oA(1,:)=zeros(1,numel(oA(1,:)));
            end
            As=[tempA;SA;oA];
            Bs=[tempB;SB;oB];
            disp(As);
            disp('end');
            
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
                            disp(tempC.current);
                            disp(tempC.voltage);
                            if (tempC.current==0) && (tempC.voltage~=0) && ~(numel(tempC.prev_node.connects)<2) %Special case: only have voltage on Collection, just stick a 1 into [A] and voltage value on [B]
                                if tempC.prev_node.ground
                                   tempA = zeros(1,nonGroundCount);
                                   tempA(nodeEnum(obj.nodes(i).id)) = 1; 
                                   tempB = -tempC.voltage;
                                   break;
                                else %supernode
                                    %tempA = zeros(1,nonGroundCount);
                                    %tempA(nodeEnum(obj.nodes(i).id)) = 1;
                                    %tempA(nodeEnum(tempC.prev_node.id)) = -1;
                                    %tempB = -tempC.voltage;
                                    [tempA,tempB]=obj.MakeSuper(obj.nodes(i),tempC.prev_node,tempC.voltage,nodeEnum,true,nonGroundCount);
                                    break;
                                end
                               
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
                obj.firstNode = curNode.id;
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
        
        function StartDrawTraverse(obj)
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
                tempR=0;
                for i=1:numel(obj.resistors)
                    if numel(obj.GetNode(obj.resistors(i).node1).connects)>1 && numel(obj.GetNode(obj.resistors(i).node2).connects)>1
                        tempR = tempR+1;
                    end
                end

                tempV=0;
                for i=1:numel(obj.vsources)
                    if numel(obj.GetNode(obj.vsources(i).node1).connects)>1 && numel(obj.GetNode(obj.vsources(i).node2).connects)>1
                        tempV = tempV+1;
                    end
                end

                tempC=0;
                for i=1:numel(obj.csources)
                    if numel(obj.GetNode(obj.csources(i).node1).connects)>1 && numel(obj.GetNode(obj.csources(i).node2).connects)>1
                        tempC = tempC+1;
                    end
                end

                numComp = tempR + tempV + tempC;
                compUsed = 0;
                
                obj.DrawTraverse(temp, 'none', [], [], []);
                compUsed = compUsed + obj.BiggestLoop();
                
                loopInd=1;
                while(compUsed < numComp)
                    disp('loop')
                    disp(loopInd);
                    disp(compUsed);
                    disp(numComp);
                    tempRow=obj.drawLoops{loopInd};
                    disp(tempRow);
                    for i=1:numel(tempRow)
                        tempNode = obj.GetNode(tempRow(i));
                        obj.DrawTraverse2(tempNode, 'none', [], [], [], tempRow);
                        compUsed = compUsed + obj.BiggestLoop();
                    end
                
                    loopInd = loopInd+1;
                end
                if ~obj.CheckCircuit()
                    disp('Invalid Circuit!');
                else
                    obj.grid=Grid(obj.drawLoops,obj.drawCompLoops,obj.drawOrients);
                end
               
            else %If grounded node not found, bail out
                disp('Ground is not set!');
            end
        end
        
        function good = CheckCircuit(obj)
            good=true;
            volts=0;
            for j=1:numel(obj.drawCompLoops{1})
                if obj.drawCompLoops{1}{j}(1)=='R' || obj.drawCompLoops{1}{j}(1)=='C'
                    volts=volts + (obj.GetNode(obj.drawLoops{1}(j)).voltage - obj.GetNode(obj.drawLoops{1}(j+1)).voltage);
                    %disp(strcat('+',num2str(obj.GetNode(obj.drawLoops{i}(j)).voltage - obj.GetNode(obj.drawLoops{i}(j+1)).voltage)));
                elseif obj.drawCompLoops{1}{j}(1)=='V'
                    if obj.drawOrients{1}(j)==1
                        volts=volts-obj.GetComp(obj.drawCompLoops{1}{j}).voltage;
                        %disp(strcat('-',num2str(obj.GetComp(obj.drawCompLoops{i}{j}).voltage)));
                    else
                        volts=volts+obj.GetComp(obj.drawCompLoops{1}{j}).voltage;
                       % disp(strcat('+',num2str(obj.GetComp(obj.drawCompLoops{i}{j}).voltage)));
                    end
                end
            end
            if volts~=0
                good=false;
            end
            
            
            
        end
        
        function loopComp = BiggestLoop(obj)
            if numel(obj.loops)>0
                largest=0;
                ind=0;
                for i=1:numel(obj.loops)
                    if numel(obj.loops{i}) > largest
                        largest=numel(obj.loops{i});
                        ind=i;
                    end
                end

                temp=obj.loops{ind};
                obj.drawLoops{end+1}=temp;
                obj.drawCompLoops{end+1}=obj.compLoops{ind};
                disp('orients');
                disp(obj.orients);
                obj.drawOrients{end+1}=obj.orients{ind};
                loopComp=numel(obj.compLoops{ind});
                obj.loops=[];
                obj.orients=[];

                for i=1:numel(obj.compLoops{ind})
                    %disp('Here');
                    %disp(obj.compLoops{ind}(i));
                    obj.GetComp(obj.compLoops{ind}{i}).PlacedInLoop();
                end
                
                obj.compLoops=[];
            else
                loopComp=0;
            end
        end
        
        function DrawTraverse(obj, curNode, traversed, visited, compV, dirs)
            disp(curNode.id);
            if ~strcmp(traversed,'none')
                compV{end+1} = traversed;
                tempComp = obj.GetComp(traversed);
                if tempComp.node1 == curNode.id
                       dirs(end+1) = 1; %positive pointing in forward traverse
                   else
                       dirs(end+1) = 0; %positive end pointing against traverse
                end
            end
            
            visited(end+1) = curNode.id;
            %disp(compV);
            
            if ~(curNode.id == visited(1)) || numel(visited)==1
                for i=1:numel(curNode.connects)
                    %disp('loop:');
                    %disp(curNode.connects(i).adjNode);
                    %disp(curNode.connects(i).cId);
                    %disp(traversed);
                    if ~(strcmp(curNode.connects(i).cId,traversed))

                        if ~(ismember(curNode.connects(i).adjNode,visited)) || (curNode.connects(i).adjNode==visited(1))
                            obj.DrawTraverse(obj.GetNode(curNode.connects(i).adjNode), curNode.connects(i).cId, visited, compV, dirs);
                        end
                    end
                end
            else
                disp('finish');
                disp(visited);
                disp(compV);
                obj.loops{end+1}=visited;
                obj.compLoops{end+1}=compV;
                obj.orients{end+1}=dirs;
            end  
        end
        
        function DrawTraverse2(obj, curNode, traversed, visited, compV, dirs, masterLoop)
            disp('traverse');
            disp(curNode.id);
            if ~strcmp(traversed,'none')
               compV{end+1} = traversed;
               tempComp = obj.GetComp(traversed);
               if tempComp.node1 == curNode.id
                   dirs(end+1) = 1; %positive pointing in forward traverse
               else
                   dirs(end+1) = 0; %positive end pointing against traverse
               end
            end
            visited(end+1) = curNode.id;
            disp(visited);
            
            if ~(ismember(curNode.id,masterLoop)) || numel(visited)==1
                for i=1:numel(curNode.connects)
                    %disp('loop:');
                    %disp(curNode.connects(i).adjNode);
                    %disp(curNode.connects(i).cId);
                    %disp(traversed);
                    if ~(strcmp(curNode.connects(i).cId,traversed)) && ~(obj.GetComp(curNode.connects(i).cId).inLoop)
                        disp('Not in loop')
                        disp(curNode.connects(i).cId);
                        if ~(ismember(curNode.connects(i).adjNode,visited)) || curNode.connects(i).adjNode==visited(1)
                            obj.DrawTraverse2(obj.GetNode(curNode.connects(i).adjNode), curNode.connects(i).cId, visited, compV, dirs, masterLoop);
                        end
                    end
                end
            else
                disp('finish');
                disp(visited);
                obj.loops{end+1}=visited;
                obj.compLoops{end+1}=compV;
                obj.orients{end+1}=dirs;
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