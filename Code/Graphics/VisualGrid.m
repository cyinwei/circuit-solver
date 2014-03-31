%Outputs a formatted circuit, taken in as an 2 dimensional matrix.
%Calculates the square size, the overall size.  Includes the GUI.

classdef VisualGrid < handle 
   properties
       %backend stuff
       dimensionSize;
       squareSize; %the size of each individual square inside the grid
       blueprint; %input matrix

       %passed into
       circuit;
       grid;

       %frontend stuff
       mainWindow;
       component;
       
       %helper stuff
       name;
       
   end
   
   methods
       function obj = VisualGrid(c, g)
           circuit = c;
           grid = g;

           obj.windowSize = getWindowSize(obj); %helper function that does a percentage of our overall size
           blueprint = grid.gridM %assumes blue print is 2 dimensional square matrix
           obj.dimensionSize = numel(blueprintMatrix(1));
           obj.squareSize = 50; %fixed
           
           obj.draw();
       end
       
       function draw(obj) %main function that draws everything
           
         %drawing our main window....  
           
           %position and name of our main window
           obj.name = 'Circuit Solver';
           obj.mainWindow = figure('Position', [1 obj.graphSize obj.graphSize obj.graphSize], ...
                                                'Name', obj.name, 'NumberTitle', 'Off');
                                            
           %draws a SQUARE grid within our window
           image = imread('images/horizontal-resistor.png');
           
           for i=1:dimensionSize
           		for j=1:dimensionSize %input grid SHOULD be square....
               	%initialize the button
            		if blueprint(i, j) == []
            			%put in an empty tile
            			component(i, j) = uicontrol('Position',[10,10+100*i,100,100], 'Background','white');
            		elseif


               	
               
               %string callback...
               set(component(i, j), 'Callback', 'showData()');
               
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
       
       %display data here
       function showData(obj)
           
       end
   end
           
   
      
end
