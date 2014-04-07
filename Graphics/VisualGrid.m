%Outputs a formatted circuit, taken in as an 2 dimensional matrix.
%Fixed tile size.

classdef VisualGrid < handle 
   properties
       %backend stuff
       dimensionSize;
       squareSize; %the size of each individual square inside the grid
       blueprint; %input matrix
       windowSize;
       scaleFactor;

       %passed into
       circuit;
       grid;

       %frontend stuff
       mainWindow;
       infoWindow;
       infoVis=false;
       component;
       
       %stuff for infowindow
       textName;
       textVoltage;
       textCurrent;
       textPower;
       textResistance;
       
       
       %helper stuff
       name;
       
   end
   
   methods(Access=public)
       function obj = VisualGrid(c, g)
           obj.circuit = c;
           obj.grid = g;

           obj.windowSize = 700;%getWindowSize(obj); %helper function that does a percentage of our overall size
           obj.blueprint = obj.grid.gridM; %assumes blue print is 2 dimensional square matrix
           obj.dimensionSize = 8;
           obj.squareSize = 41; %fixed
           obj.scaleFactor = (41/51);
           
           obj.draw();
       end
       
       function draw(obj) %main function that draws everything
           
           %position and name of our main window
           obj.name = 'Circuit Solver';
           %side window for data------------------------------------------- 
           obj.infoWindow = figure('Position', [850 500 200 200], 'Name', 'Component Info', 'NumberTitle', 'Off', 'Visible', 'off');
           %some initial stuff for the text
           obj.textName = uicontrol('Style', 'text');
           obj.textVoltage = uicontrol('Style', 'text');
           obj.textCurrent = uicontrol('Style', 'text');
           obj.textPower = uicontrol('Style', 'text');
           obj.textResistance = uicontrol('Style', 'text');
           %---------------------------------------------------------------
           
           %our main window
           obj.mainWindow = figure('Position', [100 100 700 700], ...
                                                'Name', obj.name, 'NumberTitle', 'Off');
           
           %loops through a 2 dimensional vector, and draws all the
           %components
           for j=1:obj.dimensionSize
           		for i=1:obj.dimensionSize
                    currentElem=obj.grid.gridM{obj.dimensionSize-j+1,i};
            		if isempty(currentElem)
            			%put in an empty tile, nothing to do
        
                    elseif ~(isempty(currentElem))    
                        id = currentElem.elem_id;
                        disp(id);
                        
                        if currentElem.type == 'v'
                            if strcmp(currentElem.direction,  'up') > 0                               
                                obj.drawComponent(currentElem, 'images/voltage-source-vertical-positive.png', i, j, obj.squareSize, true);
                               
                            elseif strcmp(currentElem.direction,  'down') > 0
                                obj.drawComponent(currentElem, 'images/voltage-source-vertical-negative.png', i, j, obj.squareSize, true);
                                
                            elseif strcmp(currentElem.direction,  'left') > 0
                                obj.drawComponent(currentElem, 'images/voltage-source-horizontal-positive.png', i, j, obj.squareSize, true);                            
                                                
                            else %right
                                obj.drawComponent(currentElem, 'images/voltage-source-horizontal-negative.png', i, j, obj.squareSize, true);                            
                                                               
                            end
                        elseif currentElem.type == 'r'
                            if strcmp(currentElem.direction,  'up') > 0
                                obj.drawComponent(currentElem, 'images/resistor-vertical-plus.png', i, j, obj.squareSize, true);
                                
                            elseif strcmp(currentElem.direction,  'down') > 0
                                obj.drawComponent(currentElem, 'images/resistor-vertical-minus.png', i, j, obj.squareSize, true);                               
                              
                            elseif strcmp(currentElem.direction,  'left') > 0
                                obj.drawComponent(currentElem, 'images/resistor-horizontal-plus.png', i, j, obj.squareSize, true);
                             
                            else %right
                                obj.drawComponent(currentElem, 'images/resistor-horizontal-minus.png', i, j, obj.squareSize, true);
                                
                            end
                        
                        elseif currentElem.type == 'c'
                            if strcmp(currentElem.direction,  'up') > 0
                                obj.drawComponent(currentElem, 'images/current-source-vertical-postive.png', i, j, obj.squareSize, true);                                                       
                                
                            elseif strcmp(currentElem.direction,  'down') > 0
                                obj.drawComponent(currentElem, 'images/current-source-vertical-negative.png', i, j, obj.squareSize, true);
                             
                            elseif strcmp(currentElem.direction,  'left') > 0
                                obj.drawComponent(currentElem, 'images/current-source-vertical-negative.png', i, j, obj.squareSize, true);                                                             
                               
                            else %right
                                obj.drawComponent(currentElem, 'images/current-source-vertical-negative.png', i, j, obj.squareSize, true);
                              
                            end
                            
                        elseif currentElem.type == 's'
                            if strcmp(currentElem.direction,  'up')>0 || strcmp(currentElem.direction,  'down')>0
                                obj.drawComponent(currentElem, 'images/wire-vertical.png', i, j, obj.squareSize, false);
                             
                            elseif strcmp(currentElem.direction,  'right')>0 || strcmp(currentElem.direction,  'left')>0
                                obj.drawComponent(currentElem, 'images/wire-horizontal.png', i, j, obj.squareSize, false);
                              
                            elseif strcmp(currentElem.direction,  'elbow')>0
                                if (currentElem.up_filled) && currentElem.right_filled 
                                    obj.drawComponent(currentElem, 'images/wire-up-right.png', i, j, obj.squareSize, false);
                                    
                                elseif (currentElem.up_filled) && currentElem.left_filled 
                                    obj.drawComponent(currentElem, 'images/wire-up-left.png', i, j, obj.squareSize, false);
                                    
                                elseif (currentElem.down_filled) && currentElem.right_filled 
                                    obj.drawComponent(currentElem, 'images/wire-down-right.png', i, j, obj.squareSize, false);
                                    
                                elseif (currentElem.down_filled) && currentElem.left_filled 
                                    obj.drawComponent(currentElem, 'images/wire-down-left.png', i, j, obj.squareSize, false);
                                
                                end
                            end
                            
                        elseif currentElem.type=='n'
                            if currentElem.up_filled && currentElem.down_filled && currentElem.left_filled && currentElem.right_filled
                                obj.drawComponent(currentElem, 'images/wire-all.png', i, j, obj.squareSize, true);
                            %triple gates    
                            elseif currentElem.up_filled && currentElem.down_filled && currentElem.left_filled
                                obj.drawComponent(currentElem, 'images/wire-vertical-left.png', i, j, obj.squareSize, true);
                            elseif currentElem.up_filled && currentElem.down_filled && currentElem.right_filled
                                obj.drawComponent(currentElem, 'images/wire-vertical-right.png', i, j, obj.squareSize, true);
                            elseif currentElem.up_filled && currentElem.left_filled && currentElem.right_filled
                                obj.drawComponent(currentElem, 'images/wire-horizontal-up.png', i, j, obj.squareSize, true);
                            elseif currentElem.down_filled && currentElem.left_filled && currentElem.right_filled
                                obj.drawComponent(currentElem, 'images/wire-horizontal-down.png', i, j, obj.squareSize, true);
                            %straight
                            elseif currentElem.up_filled && currentElem.down_filled
                                obj.drawComponent(currentElem, 'images/wire-vertical.png', i, j, obj.squareSize, true);
                            elseif currentElem.left_filled && currentElem.right_filled
                                obj.drawComponent(currentElem, 'images/wire-horizontal.png', i, j, obj.squareSize, true);
                            %elbows
                            elseif currentElem.up_filled && currentElem.left_filled
                                obj.drawComponent(currentElem, 'images/wire-up-left.png', i, j, obj.squareSize, true);
                            elseif currentElem.up_filled && currentElem.right_filled
                                obj.drawComponent(currentElem, 'images/wire-up-right.png', i, j, obj.squareSize, true);
                            elseif currentElem.down_filled && currentElem.left_filled
                                obj.drawComponent(currentElem, 'images/wire-down-left.png', i, j, obj.squareSize, true);
                            elseif currentElem.down_filled && currentElem.right_fulled
                                obj.drawComponent(currentElem, 'images/wire-down-right.png', i, j, obj.squareSize, true);                                                             
                            end
                        end
                        
                        %draws the names of the components
                        if currentElem.type~='s'
                            MyBox=uicontrol('Style','text');
                            set(MyBox,'String',currentElem.elem_id);
                            set(MyBox,'Position',[10+obj.squareSize*i,(700-10-obj.squareSize*j),15,15]);
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

       end
       
       function drawComponent(obj, currentElem, image_file, i, j, size, callback) %j = row, i = columns
           image = imread(image_file);
           image2 = image;
           if obj.scaleFactor ~= 1
               image2 = imresize(image, obj.scaleFactor);
           end
           obj.component(i, j) = uicontrol('Position',[10+size*i obj.windowSize-10-size*j size size], 'cdata', image2);
           
           %callback
           if callback
               currentElem=obj.grid.gridM{obj.dimensionSize-j+1,i};
               set(obj.component(i, j), 'Callback', {@obj.drawComponentCallback, currentElem});
           end
           
       end
   end
   
   methods(Access=private)
       
       function drawComponentCallback(obj, hObject, eventData, currentElem)
           %calculate data for the component
           %callback is never called on shorts, so we don't need to check
           if currentElem.type ~= 'n'
               currentComp = obj.circuit.GetComp(currentElem.elem_id);
               
               name = num2str(currentElem.elem_id);
               voltage = num2str(currentComp.voltage);
               current = num2str(currentComp.current);
               power = num2str(currentComp.power);
               resistance = 'should not be here...';
               
               if currentElem.type == 'r'
                   resistance = num2str(currentComp.resistance);
               end
               
               %showdata on our infowindow
               %makes sure everything is visible
               set(obj.textCurrent, 'Visible', 'On');
               set(obj.textPower, 'Visible', 'On');
               
               figure(obj.infoWindow); %sets as current figure
               set(obj.textName, 'String', strcat('-----Name:  ',name,'-----'), 'Position', [40 170 120 20]);
               set(obj.textVoltage, 'String', strcat('Voltage:  ', voltage), 'Position', [40 140 120 20]);
               set(obj.textCurrent, 'String', strcat('Current: ', current), 'Position', [40 110 120 20]);
               set(obj.textPower, 'String', strcat('Power:  ', power), 'Position', [40 80 120 20]);
               if currentElem.type == 'r'
                   set(obj.textResistance, 'Visible', 'On');
                   set(obj.textResistance, 'String', strcat('Resistance:  ', resistance), 'Position', [40 50 120 20])
               else 
                   set(obj.textResistance, 'Visible', 'Off');
               end
              
               %display data
               disp(['------- ' name ' -------']);
               disp([name ' voltage: ' voltage]);
               disp([name ' current: ' current]);
               disp([name ' power: ' power]);
               if currentElem.type == 'r'
                   disp([name ' resistance: ' resistance]);
               end
               
           else 
               elem_id = str2num(currentElem.elem_id(2:end));
               currentComp = obj.circuit.GetNode(elem_id);
               name = num2str(currentElem.elem_id);
               voltage = num2str(currentComp.voltage);
               
               %showdata on our infowindow
               figure(obj.infoWindow); %sets as current figure
               set(obj.textName, 'String', strcat('-----Name:  ',name,'-----'), 'Position', [40 170 120 20]);
               set(obj.textVoltage, 'String', strcat('Voltage:  ', voltage), 'Position', [40 140 120 20]);
               set(obj.textCurrent, 'Visible', 'Off');
               set(obj.textPower, 'Visible', 'Off');
               set(obj.textResistance, 'Visible', 'Off');
                   
               
               %display data
               disp(['------- ' name ' -------']);
               disp([name ' voltage: ' voltage]);
           end

       end
       
       
           
           
   end
   
      
end
