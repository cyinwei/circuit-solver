%Outputs a formatted circuit, taken in as an 2 dimensional matrix.
%Calculates the square size, the overall size.  Includes the GUI.

classdef VisualGrid < handle 
   properties
       %backend stuff
       dimensionSize;
       squareSize; %the size of each individual square inside the grid
       blueprint; %input matrix
       windowSize;

       %passed into
       circuit;
       grid;

       %frontend stuff
       mainWindow;
       infoWindow;
       infoVis=false;
       component;
       
       %helper stuff
       name;
       
   end
   
   methods
       function obj = VisualGrid(c, g)
           obj.circuit = c;
           obj.grid = g;

           obj.windowSize = getWindowSize(obj); %helper function that does a percentage of our overall size
           obj.blueprint = obj.grid.gridM; %assumes blue print is 2 dimensional square matrix
           obj.dimensionSize = 8;
           obj.squareSize = 50; %fixed
           
           obj.draw();
       end
       
       function draw(obj) %main function that draws everything
           
           %position and name of our main window
           obj.name = 'Circuit Solver';
           obj.infoWindow = figure('Position', [850 500 200 200], 'Name', 'Component Info', 'NumberTitle', 'Off', 'Visible', 'off');
           obj.mainWindow = figure('Position', [100 300 700 700], ...
                                                'Name', obj.name, 'NumberTitle', 'Off');
           
                                            

           disp(obj.dimensionSize);  
           
           iterator = 1;
           for j=1:obj.dimensionSize
           		for i=1:obj.dimensionSize
               	%initialize the button
                    currentElem=obj.grid.gridM{obj.dimensionSize-j+1,i};
                    %disp(currentElem);
                    
                    %disp(obj.dimensionSize);
            		if isempty(currentElem)
            			%put in an empty tile
            			%component(i, j) = uicontrol('Position',[10+50*i,(700-10-50*j),50,50], 'Background','white');
                        disp('empty tile');
                    elseif ~(isempty(currentElem))    
                        id = currentElem.elem_id;
                        disp(id);
                        if ~(id == 'S')
                            %currentComponent = obj.circuit.GetComp(id);
                            %voltage = currentComponent.voltage;
                            %current = currentComponent.current;
                            %power = currentComponent.power;
                        end
                        if currentElem.type == 'v'
                            if strcmp(currentElem.direction,  'up') > 0
                                image = imread('images/voltage-source-vertical-positive.png');
                               
                                obj.component(i, j) = uicontrol('Position',[10+50*i,(700-10-50*j),50,50], 'cdata', image); %...
                                                  %'Callback',  'disp(id)', 'disp(voltage)', 'disp(current)', 'disp(power)') ;  
                                disp('vs-up');

                                %callback
                                %set(component(i, j), 'Callback', 'showData(grid, circuit, i, j)');
                            elseif strcmp(currentElem.direction,  'down') > 0
                                image = imread('images/voltage-source-vertical-negative.png');
                                
                               
                                obj.component(i, j) = uicontrol('Position',[10+50*i,(700-10-50*j),50,50], 'cdata', image);
                                                  %'Callback',  'disp(id)', 'disp(voltage)', 'disp(current)', 'disp(power)') ;

                                %callback
                                %set(component(i, j), 'Callback', 'showData(grid, circuit, i, j)');

                            elseif strcmp(currentElem.direction,  'left') > 0
                                image = imread('images/voltage-source-horizontal-positive.png');
                               
                                obj.component(i, j) = uicontrol('Position',[10+50*i,(700-10-50*j),50,50], 'cdata', image); %...
                                                  %'Callback',  'disp(id)', 'disp(voltage)', 'disp(current)', 'disp(power)') ;
                                disp('vs-left');

                                %callback
                                %set(component(i, j), 'Callback', 'showData(grid, circuit, i, j)');

                            else %right
                                image = imread('images/voltage-source-horizontal-negative.png');
                             
                                obj.component(i, j) = uicontrol('Position',[10+50*i,(700-10-50*j),50,50], 'cdata', image); % ...
                                                  %'Callback',  'disp(id)', 'disp(voltage)', 'disp(current)', 'disp(power)') ;
                                disp('vs-right');

                                %callback
                                %set(component(i, j), 'Callback', 'showData(grid, circuit, i, j)');
                            end
                        elseif currentElem.type == 'r'
                            if strcmp(currentElem.direction,  'up') > 0
                                image = imread('images/resistor-vertical-postive.png');
                                
                                obj.component(i, j) = uicontrol('Position',[10+50*i,(700-10-50*j),50,50], 'cdata', image);% ...
                                                  %'Callback',  'disp(id)', 'disp(voltage)', 'disp(current)', 'disp(power)') ;
                                disp('vs-up');

                                %callback
                                %set(component(i, j), 'Callback', 'showData(grid, circuit, i, j)');
                            elseif strcmp(currentElem.direction,  'down') > 0
                                image = imread('images/resistor-vertical-negative.png');
                                
                                obj.component(i, j) = uicontrol('Position',[10+50*i,(700-10-50*j),50,50], 'cdata', image);% ...
                                                  %'Callback',  'disp(id)', 'disp(voltage)', 'disp(current)', 'disp(power)') ;
                                disp('vs-down');

                                %callback
                                %set(component(i, j), 'Callback', 'showData(grid, circuit, i, j)');

                            elseif strcmp(currentElem.direction,  'left') > 0
                                image = imread('images/resistor-horizontal-positive.png');
                               
                                obj.component(i, j) = uicontrol('Position',[10+50*i,(700-10-50*j),50,50], 'cdata', image);% ...
                                                  %'Callback',  'disp(id)', 'disp(voltage)', 'disp(current)', 'disp(power)') ;
                                disp('vs-left');

                                %callback
                                %set(component(i, j), 'Callback', 'showData(grid, circuit, i, j)');

                            else %right
                                image = imread('images/resistor-horizontal-negative.png');
                                
                                obj.component(i, j) = uicontrol('Position',[10+50*i,(700-10-50*j),50,50], 'cdata', image);% ...
                                                  %'Callback',  'disp(id)', 'disp(voltage)', 'disp(current)', 'disp(power)') ;
                                disp('vs-right');

                                %callback
                                %set(component(i, j), 'Callback', 'showData(grid, circuit, i, j)');
                            end
                        
                        elseif currentElem.type == 'c'
                            if strcmp(currentElem.direction,  'up') > 0
                                image = imread('images/current-source-vertical-postive.png');
                              
                                obj.component(i, j) = uicontrol('Position',[10+50*i,(700-10-50*j),50,50], 'cdata', image);%, ...
                                                  %'Callback',  'disp(id)', 'disp(voltage)', 'disp(current)', 'disp(power)') ;
                                disp('vs-up');

                                %callback
                                %set(component(i, j), 'Callback', 'showData(grid, circuit, i, j)');
                            elseif strcmp(currentElem.direction,  'down') > 0
                                image = imread('images/current-source-vertical-negative.png');
                             
                                obj.component(i, j) = uicontrol('Position',[10+50*i,(700-10-50*j),50,50], 'cdata', image);%, ...
                                                  %'Callback',  'disp(id)', 'disp(voltage)', 'disp(current)', 'disp(power)') ;
                                disp('vs-down');

                                %callback
                                %set(component(i, j), 'Callback', 'showData(grid, circuit, i, j)');

                            elseif strcmp(currentElem.direction,  'left') > 0
                                image = imread('images/current-source-vertical-negative.png');
                              
                                obj.component(i, j) = uicontrol('Position',[10+50*i,(700-10-50*j),50,50], 'cdata', image);%, ...
                                                  %'Callback',  'disp(id)', 'disp(voltage)', 'disp(current)', 'disp(power)') ;
                                disp('vs-left');

                                %callback
                                %set(component(i, j), 'Callback', 'showData(grid, circuit, i, j)');

                            else %right
                                image = imread('images/current-source-vertical-negative.png');
                               
                                obj.component(i, j) = uicontrol('Position',[10+50*i,(700-10-50*j),50,50], 'cdata', image);%, ...
                                                  %'Callback',  'disp(id)', 'disp(voltage)', 'disp(current)', 'disp(power)') ;
                                disp('vs-right');

                                %callback
                                %set(component(i, j), 'Callback', 'showData(grid, circuit, i, j)');
                            end
                            
                        elseif currentElem.type == 's'
                            if strcmp(currentElem.direction,  'up')>0 || strcmp(currentElem.direction,  'down')>0
                                image = imread('images/wire-vertical.png');
                                obj.component(i, j) = uicontrol('Position',[10+50*i,(700-10-50*j),50,50], 'cdata', image);
                                disp('vs-up');
                                
                            elseif strcmp(currentElem.direction,  'right')>0 || strcmp(currentElem.direction,  'left')>0
                                image = imread('images/wire-horizontal.png');
                                obj.component(i, j) = uicontrol('Position',[10+50*i,(700-10-50*j),50,50], 'cdata', image);
                                disp('vs-up');
                                
                            elseif strcmp(currentElem.direction,  'elbow')>0
                                if (currentElem.up_filled) && currentElem.right_filled 
                                    image = imread('images/wire-up-right.png');
                                    obj.component(i, j) = uicontrol('Position',[10+50*i,(700-10-50*j),50,50], 'cdata', image);
                                    disp('vs-up');
                                elseif (currentElem.up_filled) && currentElem.left_filled 
                                    image = imread('images/wire-up-left.png');
                                    obj.component(i, j) = uicontrol('Position',[10+50*i,(700-10-50*j),50,50], 'cdata', image);
                                    disp('vs-up');
                                    
                                elseif (currentElem.down_filled) && currentElem.right_filled 
                                    image = imread('images/wire-down-right.png');
                                    obj.component(i, j) = uicontrol('Position',[10+50*i,(700-10-50*j),50,50], 'cdata', image);
                                    disp('vs-up'); 
                                    
                                elseif (currentElem.down_filled) && currentElem.left_filled 
                                    image = imread('images/wire-down-left.png');
                                    obj.component(i, j) = uicontrol('Position',[10+50*i,(700-10-50*j),50,50], 'cdata', image);
                                    disp('vs-up'); 
                                end
                            end
                        elseif currentElem.type=='n'
                            image = imread('images/node.png');
                            obj.component(i, j) = uicontrol('Position',[10+50*i,(700-10-50*j),50,50], 'cdata', image);
                        end
                        if currentElem.type~='s'
                            MyBox=uicontrol('Style','text');
                            set(MyBox,'String',currentElem.elem_id);
                            set(MyBox,'Position',[10+50*i,(700-10-50*j),15,15]);
                        end
                    end
                end
           end
       end

                                
                    
 
       
       
       
       
       
       
       
       %helper functions
       %------------------------------------------------------------------
       function screenSize = getWindowSize(obj)
           %find our total screen size
           screenSize = get(0, 'ScreenSize');
           screenSize = screenSize/1.5; %scaling
           %debugging
%            disp(screenSize);
%            disp(screenSize(4)/1.5);
%            disp(screenSize(3)/1.5);

       end
   end
   
      
end
