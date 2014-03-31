%Outputs a formatted circuit, taken in as an 2 dimensional matrix.
%Calculates the square size, the overall size.  Includes the GUI.

classdef VisualGrid < handle 
   properties
       %backend stuff
       dimensionSize;
       windowSize; %matrix of the window size
       graphSize; %the square grid WITHIN the windows.
       squareSize; %the size of each individual square inside the grid
       blueprint; %input matrix
       
       %frontend stuff
       mainWindow;
       component;
       
       %helper stuff
       name;
       
   end
   
   methods
       function obj = VisualGrid(blueprintMatrix)
           obj.blueprint = blueprintMatrix;
           obj.windowSize = getWindowSize(obj); %helper function that does a percentage of our overall size
           obj.graphSize = getGraphSize(obj);
           %assumes blue print is 2 dimensional square matrix
           obj.dimensionSize = numel(blueprintMatrix(1));
           obj.squareSize = (obj.windowSize - 40)/obj.dimensionSize;
           
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
           %scale the image
           %f = figure;
           %imagesc(image);
           %set(gca, 'units', 'normalized', 'position', [0 0 1 1]);
           %set(gcf, 'units', 'pixels', 'position', [100 100 
           for i=1:3
               %initialize the button
               component(i) = uicontrol('Position',[10,10+100*i,100,100], 'CData', image, 'Background','white');
               
               %string callback...
               set(component(i), 'Callback', 'showData()');
               
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
       
       function gSize = getGraphSize(obj)
           %note: this function relies in windowsize to be calculated
           %first!
           
           if obj.windowSize(3) > obj.windowSize(4)
               gSize = obj.windowSize(4)-20;
           else
               gSize = obj.windowSize(3)-20;
           end
       end
       
       %display data here
       function showData(obj)
           
       end
   end
           
   
      
end