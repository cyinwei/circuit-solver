<<<<<<< HEAD
classdef Grid<handle
    properties
        gridM %Matrix of grid data
        %gridFill=[];
        nodePlaced=[];
        elems %array of all DrawElems in grid
        nodeLoops
        compLoops
        numNodeCon
        loopOrients %list of orientations for each loop
        curDir='up' %which way are we currently going?
        gridDimX=0;
        gridDimY=0;
    end
    methods
        function obj=Grid(nLoops, cLoops, loopDirs, nodeCons)
            obj.nodeLoops=nLoops;
            obj.compLoops=cLoops;
            obj.loopOrients=loopDirs;
            obj.numNodeCon=nodeCons;
            obj.initNodePlaced();
            
            obj.CreateMasterElems();
            obj.FillMiniElems();
            obj.MakeGrid();
        end
        
        function initNodePlaced(obj)
            for i=1:numel(obj.nodeLoops)
               for j=1:numel(obj.nodeLoops{i})
                  obj.nodePlaced{obj.nodeLoops{i}(j)}=0; 
               end
            end
        end
        
        function isAv = Check(obj, x, y)
           isAv=true;
           for i=1:numel(obj.elems)
              if obj.elems{i}.x==x && obj.elems{i}.y==y
                  isAv=false;
                  break;
              end
           end
           %if x==pX && y==pY
            %   isAv=false;
           %end
        end
        
        function FillMiniElems(obj)
            for i=3:numel(obj.nodeLoops)
                disp('starting on loop:');
                disp(obj.nodeLoops{i});
                trySpecial=false;
                for v=1:numel(obj.nodeLoops{i});
                   if obj.nodePlaced{obj.nodeLoops{i}(v)}==0;
                       trySpecial=true;
                   end
               end
               startNode=obj.GetElem(obj.nodeLoops{i}(1));
               startInd=obj.GetElemXY(startNode.x, startNode.y);
               endNode=obj.GetElem(obj.nodeLoops{i}(end));
               disp('endNode');
               disp(endNode);
               startX=startNode.x;
               startY=startNode.y;
               endX=endNode.x;
               endY=endNode.y;
               cX=startX;
               cY=startY;
               cDir='asdasd';
               prevDir=cDir;
               prevX=cX;
               prevY=cY;
               %disp('from')
               %disp(startX);
               %disp(startY);
               %disp('to');
               %disp(endX);
               %disp(endY);     

               %Determine START node terminal to use
               Sup=[];
               Sright=[];
               Sdown=[];
               Sleft=[];
               
               
               %If extended node, pick the furthest points
               if startNode.nodeExt
                  tempN=startNode;
                  while tempN.nodeExt
                      if ~tempN.up_filled
                         Sup=[tempN.x tempN.y];
                      end
                      if ~startNode.right_filled
                          Sright=[tempN.x tempN.y];
                      end 
                      if ~startNode.down_filled
                          Sdown=[tempN.x tempN.y];
                      end
                      if ~startNode.left_filled
                          Sleft=[tempN.x tempN.y];
                      end
                      tempN=tempN.nextNode;
                  end
                  startNode=tempN;
               else
                  if ~startNode.up_filled
                      Sup=[startNode.x startNode.y];
                  end
                  if ~startNode.right_filled
                      Sright=[startNode.x startNode.y];
                  end 
                  if ~startNode.down_filled
                      Sdown=[startNode.x startNode.y];
                  end
                  if ~startNode.left_filled
                      Sleft=[startNode.x startNode.y];
                  end
               end

               setSpecial=false;
               if trySpecial %Special case: need to go outside loop if possible 
                   disp('SPECIAL');
                   if strcmp(startNode.direction,'up')>0
                      if numel(Sleft)>0
                          cX=Sleft(1)-1;
                          cY=Sleft(2);
                          cDir='left';
                          setSpecial=true;
                          obj.elems{startInd}.left_filled=true;
                      end
                   elseif strcmp(startNode.direction,'right')>0
                       if numel(Sup)>0
                          cX=Sup(1);
                          cY=Sup(2)+1;
                          cDir='up';
                          setSpecial=true;
                          obj.elems{startInd}.up_filled=true;
                       end 
                   elseif strcmp(startNode.direction,'down')>0
                       if numel(Sright)>0
                          cX=Sright(1)+1;
                          cY=Sright(2);
                          cDir='right';
                          setSpecial=true;
                          obj.elems{startInd}.right_filled=true;
                       end 
                   elseif strcmp(startNode.direction,'left')>0
                       if numel(Sdown)>0
                          cX=Sdown(1);
                          cY=Sdown(2)-1;
                          cDir='down';
                          setSpecial=true;
                          obj.elems{startInd}.down_filled=true;
                       end 
                   end
               end

               if ~setSpecial
                   if endX>cX %Target is to right
                       if numel(Sright)>0
                           cX=Sright(1)+1;
                           cY=Sright(2);
                           cDir='right';
                           obj.elems{startInd}.right_filled=true;
                       else
                           if endY>cY %Target also above
                               if numel(Sup)>0
                                   cX=Sup(1);
                                   cY=Sup(2)+1;
                                   cDir='up';
                                   obj.elems{startInd}.up_filled=true;
                               else %pick open terminal
                                   if numel(Sdown)>0
                                       cX=Sdown(1);
                                       cY=Sdown(2)-1;
                                       cDir='down';
                                       obj.elems{startInd}.down_filled=true;
                                   elseif numel(Sleft)>0
                                       cX=Sleft(1)-1;
                                       cY=Sleft(2);
                                       cDir='left';
                                       obj.elems{startInd}.left_filled=true;
                                   end
                               end
                           elseif endY<cY %Target is also below
                               if numel(Sdown)>0
                                   cX=Sdown(1);
                                   cY=Sdown(2)-1;
                                   cDir='down';
                                   obj.elems{startInd}.down_filled=true;
                               else %pick open terminal
                                   if numel(Sup)>0
                                       cX=Sup(1);
                                       cY=Sup(2)+1;
                                       cDir='up';
                                       obj.elems{startInd}.up_filled=true;
                                   elseif numel(Sleft)>0
                                       cX=Sleft(1)-1;
                                       cY=Sleft(2);
                                       cDir='left';
                                       obj.elems{startInd}.left_filled=true;
                                   end
                               end
                           end
                       end
                   elseif endX<cX %Target is to left
                       if numel(Sleft)>0
                           cX=Sleft(1)-1;
                           cY=Sleft(2);
                           cDir='left';
                           obj.elems{startInd}.left_filled=true;
                       else
                           if endY>cY %Target also above
                               if numel(Sup)>0
                                   cX=Sup(1);
                                   cY=Sup(2)+1;
                                   cDir='up';
                                   obj.elems{startInd}.up_filled=true;
                               else %pick open terminal
                                   if numel(Sdown)>0
                                       cX=Sdown(1);
                                       cY=Sdown(2)-1;
                                       cDir='down';
                                       obj.elems{startInd}.down_filled=true;
                                   elseif numel(Sright)>0
                                       cX=Sup(1)+1;
                                       cY=Sup(2);
                                       cDir='right';
                                       obj.elems{startInd}.right_filled=true;
                                   end
                               end
                           elseif endY<cY %Target is also below
                               if numel(Sdown)>0
                                   cX=Sdown(1);
                                   cY=Sdown(2)-1;
                                   cDir='down';
                                   obj.elems{startInd}.down_filled=true;
                               else %pick open terminal
                                   if numel(Sup)>0
                                       cX=Sup(1);
                                       cY=Sup(2)+1;
                                       cDir='up';
                                       obj.elems{startInd}.up_filled=true;
                                   elseif numel(Sright)>0
                                       cX=Sup(1)+1;
                                       cY=Sup(2);
                                       cDir='right';
                                       obj.elems{startInd}.right_filled=true;
                                   end
                               end
                           end
                       end
                   elseif endY>cY %Target is directly above
                       if numel(Sup)>0
                           cX=Sup(1);
                           cY=Sup(2)+1;
                           cDir='up';
                           obj.elems{startInd}.up_filled=true;
                       elseif numel(Sright)>0
                           cX=Sright(1)+1;
                           cY=Sup(2);
                           cDir='right';
                           obj.elems{startInd}.right_filled=true;
                       elseif numel(Sleft)>0
                           cX=Sleft(1)-1;
                           cY=Sleft(2);
                           cDir='left';
                           obj.elems{startInd}.left_filled=true;
                       elseif numel(Sdown)>0
                           cX=Sdown(1);
                           cY=Sdown(2)-1;
                           cDir='down';
                           obj.elems{startInd}.down_filled=true;
                       end

                   elseif endY<cY %Target is directly below
                       if numel(Sdown)>0
                           cX=Sleft(1)-1;
                           cY=Sleft(2);
                           cDir='down';
                           obj.elems{startInd}.down_filled=true;
                       elseif numel(Sright)>0
                           cX=Sright(1)+1;
                           cY=Sright(2);
                           cDir='right';
                           obj.elems{startInd}.right_filled=true;
                       elseif numel(Sleft)>0
                           cX=Sleft(1)-1;
                           cY=Sleft(2);
                           cDir='left';
                           obj.elems{startInd}.left_filled=true;
                       elseif numel(Sup)>0
                           cX=Sup(1);
                           cY=Sup(2)-1;
                           cDir='up';
                           obj.elems{startInd}.up_filled=true;
                       end
                   end
               end

               EV=[endNode.x endNode.y];
               EH=[endNode.x endNode.y];
               disp('checking:');
               disp(endNode);
               if endNode.nodeExt
                  tempN=endNode;
                  disp('End node extended!');
                  disp(tempN);
                  while tempN.nodeExt
                      disp('ext while');
                      if ~tempN.nextNode.up_filled && startY>endY
                          EH=[EH; tempN.nextNode.x tempN.nextNode.y];
                      end
                      if ~tempN.nextNode.down_filled && startY<endY
                          EH=[EH; tempN.nextNode.x tempN.nextNode.y];
                      end
                      disp('CHECK');
                      disp(tempN.nextNode);
                      if ~tempN.nextNode.right_filled && startX>endX
                          disp('right not filled');
                          EV=[EV; tempN.nextNode.x tempN.nextNode.y];
                      end
                      if ~tempN.nextNode.left_filled && startX<endX
                          EV=[EV; tempN.nextNode.x tempN.nextNode.y];
                      end
                      tempN=tempN.nextNode;
                  end
                  disp('EH:');
                  disp(EH);
                  disp('EV:');
                  disp(EV);
               end
               disp(cDir);
               %else
                  %if ~endNode.up_filled
                %      Eup=[endNode.x endNode.y];
                  %end
                  %if ~endNode.right_filled
                 %     Eright=[endNode.x endNode.y];
                 % end 
                  %if ~endNode.down_filled
                  %    Edown=[endNode.x endNode.y];
                  %end
                  %if ~endNode.left_filled
                   %   Eleft=[endNode.x endNode.y];
                  %end
               %end
               
               %~
               if strcmp(cDir, 'up')>0
                   if strcmp(endNode.direction,'up')>0
                       if cY>endNode.y
                           endX=EV(end-1);
                           endY=EV(end);
                       end
                   elseif strcmp(endNode.direction,'down')>0
                       if cY<endNode.y
                           endX=EV(end-1);
                           endY=EV(end);
                       end
                   elseif strcmp(endNode.direction,'left')>0
                       if cX<endNode.x
                           endX=EH(end-1);
                           endY=EH(end);
                       end     
                   elseif strcmp(endNode.direction,'right')>0
                       if cX>endNode.x
                           endX=EH(end-1);
                           endY=EH(end);
                       end
                   end
                   
               elseif strcmp(cDir, 'right')>0
                   if strcmp(endNode.direction,'left')>0
                       if cX<endNode.x
                           endX=EH(end-1);
                           endY=EH(end);
                       end     
                   elseif strcmp(endNode.direction,'right')>0
                       if cX>endNode.x
                           endX=EH(end-1);
                           endY=EH(end);
                       end
                   elseif strcmp(endNode.direction,'up')>0
                       if cY>endNode.y
                           endX=EV(end-1);
                           endY=EV(end);
                       end
                   elseif strcmp(endNode.direction,'down')>0
                       if cY<endNode.y
                           endX=EV(end-1);
                           endY=EV(end);
                       end
                   end
                   
               elseif strcmp(cDir, 'down')>0
                   if strcmp(endNode.direction,'up')>0
                       if cY>=endNode.y
                           endX=EV(end,1);
                           endY=EV(end);
                       end
                   elseif strcmp(endNode.direction,'down')>0
                       if cY<=endNode.y
                           endX=EV(end-1);
                           endY=EV(end);
                       end
                   elseif strcmp(endNode.direction,'left')>0
                       if cX<=endNode.x
                           endX=EH(end-1);
                           endY=EH(end);
                       end     
                   elseif strcmp(endNode.direction,'right')>0
                       if cX>=endNode.x
                           endX=EH(end-1);
                           endY=EH(end);
                       end
                   end
                   
               elseif strcmp(cDir, 'left')>0
                   if strcmp(endNode.direction,'left')>0
                       if cX<endNode.x
                           endX=EH(end-1);
                           endY=EH(end);
                       end     
                   elseif strcmp(endNode.direction,'right')>0
                       if cX>endNode.x
                           endX=EH(end-1);
                           endY=EH(end);
                       end
                   elseif strcmp(endNode.direction,'up')>0
                       if cY>endNode.y
                           endX=EV(end-1);
                           endY=EV(end);
                       end
                   elseif strcmp(endNode.direction,'down')>0
                       if cY<endNode.y
                           endX=EV(end-1);
                           endY=EV(end);
                       end
                   end
               end
               %~
               
                   
                   
                   
               disp(strcat('start:',num2str(cX),num2str(cY)));
               disp(strcat('end:',num2str(endX),num2str(endY)));
               iter=1;
               compTurn=true;
               stuck=false;
               stuckWay='';
               while (abs(cX-endX)+abs(cY-endY))>1
                   prevDir=cDir;
                   prevX=cX;
                   prevY=cY;
                   disp(strcat('at: ',num2str(cX),', ',num2str(cY)));
                   disp(strcat('going to: ',num2str(endX),', ',num2str(endY)));
                   
                   
                   
                   if abs(cX-endX)>=abs(cY-endY) %Farther horizontally (also default)
                       if endX>cX %it's to the right
                           if obj.Check(cX+1,cY)
                              cX=cX+1;
                              cDir='right';
                           elseif endY>cY %it's also above
                               if obj.Check(cX,cY+1) && strcmp(cDir,'down')==0
                                   cY=cY+1;
                                   cDir='up';
                               elseif obj.Check(cX,cY-1) && strcmp(cDir,'up')==0
                                   cY=cY-1;
                                   cDir='down';
                               end
                               
                           elseif endY<cY %it's also below
                               if obj.Check(cX,cY-1) && strcmp(cDir,'up')==0
                                   cY=cY-1;
                                   cDir='down';
                               elseif obj.Check(cX,cY+1) && strcmp(cDir,'down')==0
                                   cY=cY+1;
                                   cDir='up';
                               end
                           else %We're stuck!
                               disp('stuck!');
                               if strcmp(cDir,'up')>0 && obj.Check(cX,cY+1)
                                   cY=cY+1;
                                   cDir='up';
                               elseif strcmp(cDir,'down')>0 && obj.Check(cX,cY-1)
                                   cY=cY-1;
                                   cDir='down'
                               else %Gotta go left to fix, stay going in direction though
                                   cX=cX-1;
                                   cDir=cDir;
                               end
                           end
                       elseif endX<cX %it's to the left
                           disp('go left!');
                           if obj.Check(cX-1,cY)
                              cX=cX-1;
                              cDir='left';
                           elseif endY>cY %it's also above
                               if obj.Check(cX,cY+1) && strcmp(cDir,'down')==0
                                   cY=cY+1;
                                   cDir='up';
                               elseif obj.Check(cX,cY-1) && strcmp(cDir,'up')==0
                                   cY=cY-1;
                                   cDir='down';
                               end
                               
                           elseif endY<cY %it's also below
                               disp('its below too!');
                               disp(cDir);
                               if obj.Check(cX,cY-1) && strcmp(cDir,'up')==0
                                   cY=cY-1;
                                   cDir='down';
                               elseif obj.Check(cX,cY+1) && strcmp(cDir,'down')==0
                                   cY=cY+1;
                                   cDir='up';
                               else %We're stuck!
                                   disp('stuck!');
                                   if strcmp(cDir,'up')>0 && obj.Check(cX,cY+1)
                                       cY=cY+1;
                                       cDir='up';
                                   elseif strcmp(cDir,'down')>0 && obj.Check(cX,cY-1)
                                       cY=cY-1;
                                       cDir='down'
                                   else %Gotta go right to fix, stay going in direction though
                                       cX=cX+1;
                                       cDir=cDir;
                                   end
                               end
                           else %We're stuck!
                               disp('stuck!');
                               if strcmp(cDir,'up')>0 && obj.Check(cX,cY+1)
                                   cY=cY+1;
                                   cDir='up';
                               elseif strcmp(cDir,'down')>0 && obj.Check(cX,cY-1)
                                   cY=cY-1;
                                   cDir='down';
                               else %Gotta go right to fix, stay going in direction though
                                   cX=cX+1;
                                   cDir=cDir;
                               end
                           end
                           %NO CASE FOR STRAIGHT UP/DOWN
                       end
                       
                       
                       
                   else %Farther vertically
                       if endY>cY %it's above
                           if obj.Check(cX,cY+1)
                              cY=cY+1;
                              cDir='up';
                           elseif endX>cX %it's also to right
                               if obj.Check(cX+1,cY) && strcmp(cDir,'left')==0
                                   cX=cX+1;
                                   cDir='right';
                               elseif obj.Check(cX-1,cY) && strcmp(cDir,'right')==0
                                   cX=cX-1;
                                   cDir='left';
                               end
                               
                           elseif endY<cY %it's also to left
                               if obj.Check(cX-1,cY) && strcmp(cDir,'right')==0
                                   cX=cX-1;
                                   cDir='left';
                               elseif obj.Check(cX+1,cY) && strcmp(cDir,'left')==0
                                   cX=cX+1;
                                   cDir='right';
                               end
                           else %We're stuck!
                               disp('stuck!');
                               if strcmp(cDir,'right')>0 && obj.Check(cX+1,cY)
                                   cX=cX+1;
                                   cDir='right';
                               elseif strcmp(cDir,'left')>0 && obj.Check(cX-1,cY)
                                   cX=cX-1;
                                   cDir='left'
                               else %Gotta go down to fix, stay going in direction though
                                   cY=cY-1;
                                   cDir=cDir;
                               end
                           end
                       elseif endX<cX %it's below
                           if obj.Check(cX,cY-1)
                              cY=cY-1;
                              cDir='down';
                           elseif endX>cX %it's also to right
                               if obj.Check(cX+1,cY) && strcmp(cDir,'left')==0
                                   cX=cX+1;
                                   cDir='right';
                               elseif obj.Check(cX-1,cY) && strcmp(cDir,'right')==0
                                   cX=cX-1;
                                   cDir='left';
                               end
                               
                           elseif endY<cY %it's also to left
                               if obj.Check(cX-1,cY) && strcmp(cDir,'right')==0
                                   cX=cX-1;
                                   cDir='left';
                               elseif obj.Check(cX+1,cY) && strcmp(cDir,'left')==0
                                   cX=cX+1;
                                   cDir='right';
                               end
                           else %We're stuck!
                               disp('stuck!');
                               if strcmp(cDir,'right')>0 && obj.Check(cX+1,cY)
                                   cX=cX+1;
                                   cDir='right';
                               elseif strcmp(cDir,'left')>0 && obj.Check(cX-1,cY)
                                   cX=cX-1;
                                   cDir='left'
                               else %Gotta go up to fix, stay going in direction though
                                   cY=cY+1;
                                   cDir=cDir;
                               end
                           end
                           %NO CASE FOR STRAIGHT LEFT/RIGHT
                       end
                   end
                       
                   %GENERATE ELEMENTS/SHORTS
                       if strcmp(cDir,prevDir)==0 %Need elbow short
                           disp('draw short!');
                           obj.elems{end+1}=DrawElem('S',prevX,prevY,'elbow');
                           if strcmp(prevDir,'up');
                               obj.elems{end}.down_filled=true;
                           elseif strcmp(prevDir,'right');
                               obj.elems{end}.left_filled=true;
                           elseif strcmp(prevDir,'down');
                               obj.elems{end}.up_filled=true;
                           elseif strcmp(prevDir,'left');
                               obj.elems{end}.right_filled=true;
                           end
                           if strcmp(cDir,'up');
                               obj.elems{end}.up_filled=true;
                           elseif strcmp(cDir,'right');
                               obj.elems{end}.right_filled=true;
                           elseif strcmp(cDir,'down');
                               obj.elems{end}.down_filled=true;
                           elseif strcmp(cDir,'left');
                               obj.elems{end}.left_filled=true;
                           end
                       elseif iter<=numel(obj.compLoops{i}) && compTurn %See if we need to place an element
                           if obj.loopOrients{i}(iter)==1
                               disp('regular way');
                               disp(obj.loopOrients{i}(iter));
                               disp(obj.compLoops{i}{iter});
                               obj.elems{end+1}=DrawElem(obj.compLoops{i}{iter},prevX,prevY,cDir);
                           else
                               disp('flip way');
                               disp(obj.loopOrients{i}(iter));
                               disp(obj.compLoops{i}{iter});
                               if strcmp(prevDir, 'up')>0
                                   obj.elems{end+1}=DrawElem(obj.compLoops{i}{iter},prevX,prevY,'down');
                               elseif strcmp(prevDir, 'down')>0
                                   obj.elems{end+1}=DrawElem(obj.compLoops{i}{iter},prevX,prevY,'up');
                               elseif strcmp(prevDir, 'right')>0
                                   obj.elems{end+1}=DrawElem(obj.compLoops{i}{iter},prevX,prevY,'left');
                               elseif strcmp(prevDir, 'left')>0
                                   obj.elems{end+1}=DrawElem(obj.compLoops{i}{iter},prevX,prevY,'right');
                               end
                           end
                           iter = iter+1;
                           compTurn=false;
                       elseif iter<numel(obj.nodeLoops{i}) && ~compTurn %Time to place node
                           disp('draw node');
                           if strcmp(cDir, 'up')>0
                               obj.elems{end+1}=DrawElem(obj.nodeLoops{i}(iter),prevX,prevY,'down');
                               obj.elems{end}.up_filled=true;
                               obj.elems{end}.down_filled=true;
                           elseif strcmp(cDir, 'down')>0
                               obj.elems{end+1}=DrawElem(obj.nodeLoops{i}(iter),prevX,prevY,'up');
                               obj.elems{end}.up_filled=true;
                               obj.elems{end}.down_filled=true;
                           elseif strcmp(cDir, 'right')>0
                               obj.elems{end+1}=DrawElem(obj.nodeLoops{i}(iter),prevX,prevY,'left');
                               obj.elems{end}.right_filled=true;
                               obj.elems{end}.left_filled=true;
                           elseif strcmp(cDir, 'left')>0
                               obj.elems{end+1}=DrawElem(obj.nodeLoops{i}(iter),prevX,prevY,'right');
                               obj.elems{end}.right_filled=true;
                               obj.elems{end}.left_filled=true;
                           end
                           compTurn=true;
                           
                       else %Just need a regular short
                           disp('draw straight short');
                           obj.elems{end+1}=DrawElem('S',prevX,prevY,prevDir);
                       end    
                           
               end
               
               endDir='asd';
               if cX>endX
                   endDir='left';
               elseif cX<endX
                   endDir='right';
               elseif cY>endY
                   endDir='down';
               elseif cY<endY
                   endDir='up';
               end
               
               disp('stopped at:');
               disp(cX);
               disp(cY);
               
               if strcmp(cDir,endDir)==0
                   obj.elems{end+1}=DrawElem('S',cX,cY,'elbow');
                   %disp(prevDir);
                   %disp(cDir);
                   if strcmp(cDir,'up');
                       obj.elems{end}.down_filled=true;
                   elseif strcmp(cDir,'right');
                       obj.elems{end}.left_filled=true;
                   elseif strcmp(cDir,'down');
                       obj.elems{end}.up_filled=true;
                   elseif strcmp(cDir,'left');
                       obj.elems{end}.right_filled=true;
                   end
                   if endX>cX
                       obj.elems{end}.right_filled=true;
                   elseif endX<cX
                       obj.elems{end}.left_filled=true;
                   elseif endY>cY
                       obj.elems{end}.up_filled=true;
                   elseif endY<cY
                       obj.elems{end}.down_filled=true;
                   end
               else
                   obj.elems{end+1}=DrawElem('S',cX,cY,cDir);
               end
               if cX>endX
                   disp('fill right');
                   nodeInd=obj.GetElemXY(cX-1,cY);
                   obj.elems{nodeInd}.right_filled=true;
               elseif cX<endX
                   disp('fill left');
                   disp(cX+1);
                   disp(cY);
                   nodeInd=obj.GetElemXY(cX+1,cY);
                   obj.elems{nodeInd}.left_filled=true;
               elseif cY>endY
                   disp('fill up');
                   nodeInd=obj.GetElemXY(cX,cY-1);
                   obj.elems{nodeInd}.up_filled=true;
               elseif cY<endY
                   disp('fill down');
                   nodeInd=obj.GetElemXY(cX,cY+1);
                   obj.elems{nodeInd}.down_filled=true;
               end
               
               break;
            end
        end
        
        function MakeGrid(obj)
            shiftX=1;
            shiftY=1;
            lowestX=0;
            lowestY=0;
            for i=1:numel(obj.elems)
               if obj.elems{i}.x<lowestX
                   disp('lower X!');
                   lowestX=obj.elems{i}.x;
                   shiftX=abs(obj.elems{i}.x)+1;
               end
               if obj.elems{i}.y<lowestY
                   disp('lower Y!');
                   lowestY=obj.elems{i}.y;
                   shiftY=abs(obj.elems{i}.y)+1;
               end
            end
            
            disp('shiftX');
            disp(shiftX);
            
                obj.gridM= DrawElem.empty;
                for i=1:numel(obj.elems)
                   tempEl=obj.elems{i};
                   cX=tempEl.x+shiftX+1;
                   cY=tempEl.y+shiftY+1;
                   %disp('cX');
                   %disp(cX);
                   %disp('cY');
                   %disp(cY);
                   %disp('put in:');
                   %disp(tempEl);
                   obj.gridM{cY,cX}=tempEl;
                end
                %ends=sqrt(numel(obj.gridM));
                %for j=1:sqrt(numel(obj.gridM))
                 %   disp(j);
                 %   obj.gridM{j,ends}=[];
               % end
                %for j=1:ends
                 %   obj.gridM{ends+1,j}=[];
                %end
                obj.gridDimX=numel(obj.gridM(1,:));
                obj.gridDimY=numel(obj.gridM(:,1));
            end
       % end
        
        function CreateMasterElems(obj) %Draw for master loop
            obj.elems{end+1}=DrawElem(obj.nodeLoops{1}(1),0,0,'up');
            %obj.gridFill(1,1)=1;
            obj.elems{end}.up_filled=true;
            obj.elems{end}.right_filled=true;
            curX=0;
            curY=1;
            i=2;
            compPerBr=numel(obj.compLoops{1})/4;
            curCount=compPerBr - floor(compPerBr);
            
            largestExt=0;
            for h=1:numel(obj.numNodeCon)
               for k=1:numel(obj.numNodeCon{h})
                   if (obj.numNodeCon{h}(k)>4)
                       ext = 1+floor((obj.numNodeCon{h}(k)-4)/4);
                       if ext>largestExt
                           largestExt=ext;
                       end
                   end
               end
            end
            disp('ext:');
            disp(largestExt);
            
            while i<=numel(obj.compLoops{1})+1
                disp('i:');
                disp(i);
                j=1;
                extended=0;
                while j<=ceil(compPerBr)
                    if j==1
                        if strcmp(obj.curDir,'up')>0 || strcmp(obj.curDir,'down')>0
                            obj.elems{end+1}=DrawElem('S',curX,curY,'up');
                        else
                            obj.elems{end+1}=DrawElem('S',curX,curY,'right');
                        end
                        %obj.gridFill(curX+1,curY+1)=1;
                        [curX,curY]=obj.MoveXY(curX,curY);
                    end
                    if curCount <= 0 && j==1
                        if strcmp(obj.curDir,'up')>0 || strcmp(obj.curDir,'down')>0
                            obj.elems{end+1}=DrawElem('S',curX,curY,'up');
                        else
                            obj.elems{end+1}=DrawElem('S',curX,curY,'right');
                        end
                        %obj.gridFill(curX+1,curY+1)=1;
                        [curX,curY]=obj.MoveXY(curX,curY);
                        j=j+1;
                    end
                    if strcmp(obj.curDir,'up')>0
                       if obj.loopOrients{1}(i-1)==1
                           obj.elems{end+1}=DrawElem(obj.compLoops{1}{i-1},curX,curY,'up');
                       else
                           obj.elems{end+1}=DrawElem(obj.compLoops{1}{i-1},curX,curY,'down');
                       end
                    elseif strcmp(obj.curDir,'right')>0
                        if obj.loopOrients{1}(i-1)==1
                           obj.elems{end+1}=DrawElem(obj.compLoops{1}{i-1},curX,curY,'right');
                        else
                           obj.elems{end+1}=DrawElem(obj.compLoops{1}{i-1},curX,curY,'left');
                        end
                    elseif strcmp(obj.curDir,'down')>0
                        if obj.loopOrients{1}(i-1)==1
                           obj.elems{end+1}=DrawElem(obj.compLoops{1}{i-1},curX,curY,'down');
                        else
                           obj.elems{end+1}=DrawElem(obj.compLoops{1}{i-1},curX,curY,'up');
                        end
                    elseif strcmp(obj.curDir,'left')>0
                        if obj.loopOrients{1}(i-1)==1
                           obj.elems{end+1}=DrawElem(obj.compLoops{1}{i-1},curX,curY,'left');
                        else
                           obj.elems{end+1}=DrawElem(obj.compLoops{1}{i-1},curX,curY,'right');
                        end
                    end
                    %disp('drawing:');
                    %disp(obj.compLoops{1}{i-1});
                    %obj.gridFill(curX+1,curY+1)=1;
                    [curX,curY]=obj.MoveXY(curX,curY);
                    if (curCount<=0) & (j==ceil(compPerBr)) 
                        if strcmp(obj.curDir,'up')>0 || strcmp(obj.curDir,'down')>0
                            obj.elems{end+1}=DrawElem('S',curX,curY,'up');
                        else
                            obj.elems{end+1}=DrawElem('S',curX,curY,'right');
                        end
                        %obj.gridFill(curX+1,curY+1)=1;
                        [curX,curY]=obj.MoveXY(curX,curY);
                        j=j+1;
                    end
                    
                    if i<numel(obj.compLoops{1})+1
                        obj.elems{end+1}=DrawElem(obj.nodeLoops{1}(i),curX,curY,obj.curDir); %PUT IN NODE
                        if strcmp(obj.curDir,'up')
                            obj.elems{end}.down_filled=true;
                            obj.elems{end}.up_filled=true;
                        elseif strcmp(obj.curDir,'right')
                            obj.elems{end}.left_filled=true;
                            obj.elems{end}.right_filled=true;
                        elseif strcmp(obj.curDir,'down')
                            obj.elems{end}.up_filled=true;
                            obj.elems{end}.down_filled=true;
                        else strcmp(obj.curDir,'left')
                            obj.elems{end}.right_filled=true;
                            obj.elems{end}.left_filled=true;
                        end
                        %obj.gridFill(curX+1,curY+1)=1;
                        obj.nodePlaced{obj.nodeLoops{1}(i)}=1;
                        [curX,curY]=obj.MoveXY(curX,curY);
                        
                        disp('??');
                        disp(obj.numNodeCon{1}(i));
                        if obj.numNodeCon{1}(i)>4
                            disp('EXTEND!');
                            toExt=1+floor((obj.numNodeCon{1}(i)-4)/4);
                            disp(toExt);
                            disp(floor((obj.numNodeCon{1}(i)-4)/4));
                            for m=1:toExt
                                obj.elems{end}.nodeExt=true;
                                obj.elems{end+1}=DrawElem(obj.nodeLoops{1}(i),curX,curY,obj.curDir);
                                obj.elems{end-1}.nextNode=obj.elems{end};
                                if strcmp(obj.curDir,'up')
                                    obj.elems{end}.down_filled=true;
                                    obj.elems{end}.up_filled=true;
                                elseif strcmp(obj.curDir,'right')
                                    obj.elems{end}.left_filled=true;
                                    obj.elems{end}.right_filled=true;
                                elseif strcmp(obj.curDir,'down')
                                    obj.elems{end}.up_filled=true;
                                    obj.elems{end}.down_filled=true;
                                else strcmp(obj.curDir,'left')
                                    obj.elems{end}.right_filled=true;
                                    obj.elems{end}.left_filled=true;
                                end
                                %obj.gridFill(curX+1,curY+1)=1;
                                [curX,curY]=obj.MoveXY(curX,curY);
                                extended=extended+1;
                            end
                        end
                    end
                    
                    if j>=ceil(compPerBr)
                        for cnt=extended+1:largestExt
                            if strcmp(obj.curDir,'up')>0 || strcmp(obj.curDir,'down')>0
                                obj.elems{end+1}=DrawElem('S',curX,curY,'up');
                            else
                                obj.elems{end+1}=DrawElem('S',curX,curY,'right');
                            end
                            %obj.gridFill(curX+1,curY+1)=1;
                            [curX,curY]=obj.MoveXY(curX,curY);
                        end
                        if strcmp(obj.curDir,'up')>0
                            obj.elems{end+1}=DrawElem('S',curX,curY,'elbow');
                            obj.elems{end}.down_filled=true;
                            obj.elems{end}.right_filled=true;
                        elseif strcmp(obj.curDir,'right')>0
                            obj.elems{end+1}=DrawElem('S',curX,curY,'elbow');
                            obj.elems{end}.left_filled=true;
                            obj.elems{end}.down_filled=true;
                        elseif strcmp(obj.curDir,'down')>0
                            obj.elems{end+1}=DrawElem('S',curX,curY,'elbow');
                            obj.elems{end}.up_filled=true;
                            obj.elems{end}.left_filled=true;
                        elseif strcmp(obj.curDir,'left')>0
                            obj.elems{end+1}=DrawElem('S',curX,curY,'left');
                        end
                        %obj.gridFill(curX+1,curY+1)=1;
                        %disp('fill');
                        %disp(curX+1);
                        %disp(curY+1);
                    end
                    j=j+1;
                    i=i+1;
                end
                curCount=curCount-0.25;
                obj.ChangeDirection();
                [curX,curY]=obj.MoveXY(curX,curY);
                
            end
            %obj.gridDim=(numel(obj.elems))/4;
        end
        
        function theElem= GetElem(obj, id)
            if ~(id(1)=='R' || id(1)=='V' || id(1)=='C')
                    id=strcat('N',num2str(id));
            end
            %disp('id:');
            %disp(id);
            for i=1:numel(obj.elems)
                if strcmp(obj.elems{i}.elem_id,id)>0
                    theElem=obj.elems{i};
                    break;
                end
            end
        end
        
        function elemInd= GetElemXY(obj,x2,y2)
            for i=1:numel(obj.elems)
                if obj.elems{i}.x==x2 && obj.elems{i}.y==y2
                    elemInd=i;
                    break;
                end
            end
        end
        
        function [newX,newY] = MoveXY(obj, curX, curY)
            if strcmp(obj.curDir,'up')
               newX=curX;
               newY=curY+1;
           elseif strcmp(obj.curDir,'right')
               newX=curX+1;
               newY=curY;
           elseif strcmp(obj.curDir,'down')
               newX=curX;
               newY=curY-1;
           elseif strcmp(obj.curDir,'left')
               newX=curX-1;
               newY=curY;
           end
        end
        
        function ChangeDirection(obj)
           if strcmp(obj.curDir,'up')
               obj.curDir='right';
           elseif strcmp(obj.curDir,'right')
               obj.curDir='down';
           elseif strcmp(obj.curDir,'down')
               obj.curDir='left';
           elseif strcmp(obj.curDir,'left')
               obj.curDir='up';
           end
        end
        
        function nextDir = NextDirection(obj,cDir)
           if strcmp(cDir,'up')
               nextDir='right';
           elseif strcmp(cDir,'right')
               nextDir='down';
           elseif strcmp(cDir,'down')
               nextDir='left';
           elseif strcmp(cDir,'left')
               nextDir='up';
           end
        end
        
    end
=======
classdef Grid<handle
    properties
        gridM %Matrix of grid data
        elems %array of all DrawElems in grid
        nodeLoops
        compLoops
        loopOrients %list of orientations for each loop
        curDir='up' %which way are we currently going?
        gridDimX=0;
        gridDimY=0;
    end
    methods
        function obj=Grid(nLoops, cLoops, loopDirs)
            obj.nodeLoops=nLoops;
            obj.compLoops=cLoops;
            obj.loopOrients=loopDirs;
            
            obj.CreateMasterElems();
            obj.FillMiniElems();
            obj.MakeGrid();
            
        end
        
        function isAv = Check(obj, x, y)
           isAv=true;
           for i=1:numel(obj.elems)
              if obj.elems{i}.x==x && obj.elems{i}.y==y
                  isAv=false;
                  break;
              end
           end
        end
        
        function FillMiniElems(obj)
            for i=2:numel(obj.nodeLoops)
                for j=1:numel(obj.nodeLoops{i})-1
                   startNode=obj.GetElem(obj.nodeLoops{i}(j));
                   endNode=obj.GetElem(obj.nodeLoops{i}(j+1));
                   startX=startNode.x;
                   startY=startNode.y;
                   endX=endNode.x;
                   endY=endNode.y;
                   cX=startX;
                   cY=startY;
                   cDir='asdasd';
                   prevDir=cDir;
                   prevX=cX;
                   prevY=cY;
                   %disp('from')
                   %disp(startX);
                   %disp(startY);
                   %disp('to');
                   %disp(endX);
                   %disp(endY);
                   %Determine node terminal to use
                   if endX>cX %Target is to right
                       if ~startNode.right_filled
                           cX=cX+1;
                           cDir='right';
                       else
                           if endY>cY %Target also above
                               if ~startNode.up_filled
                                   cY=cY+1;
                                   cDir='up';
                               else %pick open terminal
                                   if ~startNode.down_filled
                                       cY=cY-1;
                                       cDir='down';
                                   elseif ~startNode.left_filled
                                       cX=cX-1;
                                       cDir='left';
                                   end
                               end
                           elseif endY<cY %Target is also below
                               if ~startNode.down_filled
                                   cY=cY-1;
                                   cDir='down';
                               else %pick open terminal
                                   if ~startNode.up_filled
                                       cY=cY+1;
                                       cDir='up';
                                   elseif ~startNode.left_filled
                                       cX=cX-1;
                                       cDir='left';
                                   end
                               end
                           end
                       end
                   elseif endX<cX %Target is to left
                       if ~startNode.left_filled
                           cX=cX-1;
                           cDir='left';
                       else
                           if endY>cY %Target also above
                               if ~startNode.up_filled
                                   cY=cY+1;
                                   cDir='up';
                               else %pick open terminal
                                   if ~startNode.down_filled
                                       cY=cY-1;
                                       cDir='down';
                                   elseif ~startNode.right_filled
                                       cX=cX+1;
                                       cDir='right';
                                   end
                               end
                           elseif endY<cY %Target is also below
                               if ~startNode.down_filled
                                   cY=cY-1;
                                   cDir='down';
                               else %pick open terminal
                                   if ~startNode.up_filled
                                       cY=cY+1;
                                       cDir='up';
                                   elseif ~startNode.right_filled
                                       cX=cX+1;
                                       cDir='right';
                                   end
                               end
                           end
                       end
                   elseif endY>cY %Target is directly above
                       if ~startNode.up_filled
                           cY=cY+1;
                           cDir='up';
                       elseif ~startNode.right_filled
                           cX=cX+1;
                           cDir='right';
                       elseif ~startNode.left_filled
                           cX=cX-1;
                           cDir='left';
                       elseif ~startNode.down_filled
                           cY=cY-1;
                           cDir='down';
                       end
                       
                   elseif endY<cY %Target is directly below
                       if ~startNode.down_filled
                           cY=cY-1;
                           cDir='down';
                       elseif ~startNode.right_filled
                           cX=cX+1;
                           cDir='right';
                       elseif ~startNode.left_filled
                           cX=cX-1;
                           cDir='left';
                       elseif ~startNode.up_filled
                           cY=cY+1;
                           cDir='up';
                       end
                   end
                   
                   
                   iter=0;
                   while cX~=endX && cY~=endY
                       prevX=cX;
                       prevY=cY;
                       prevDir=cDir;
                       
                       if endX>cX %Target is to right
                           if obj.Check(cX+1,cY)
                               cX=cX+1;
                               cDir='right';
                           else
                               if endY>cY %Target also above
                                   if obj.Check(cX,cY+1)
                                       cY=cY+1;
                                       cDir='up';
                                   else %pick open terminal
                                       if obj.Check(cX,cY-1)
                                           cY=cY-1;
                                           cDir='down';
                                       elseif obj.Check(cX-1,cY)
                                           cX=cX-1;
                                           cDir='left';
                                       end
                                   end
                               elseif endY<cY %Target is also below
                                   if obj.Check(cX,cY-1)
                                       cY=cY-1;
                                       cDir='down';
                                   else %pick open terminal
                                       if obj.Check(cX,cY+1)
                                           cY=cY+1;
                                           cDir='up';
                                       elseif obj.Check(cX-1,cY)
                                           cX=cX-1;
                                           cDir='left';
                                       end
                                   end
                               end
                           end
                       elseif endX<cX %Target is to left
                           if obj.Check(cX-1,cY)
                               cX=cX-1;
                               cDir='left';
                           else
                               if endY>cY %Target also above
                                   if obj.Check(cX,cY+1)
                                       cY=cY+1;
                                       cDir='up';
                                   else %pick open terminal
                                       if obj.Check(cX,cY-1)
                                           cY=cY-1;
                                           cDir='down';
                                       elseif obj.Check(cX+1,cY)
                                           cX=cX+1;
                                           cDir='right';
                                       end
                                   end
                               elseif endY<cY %Target is also below
                                   if obj.Check(cX,cY-1)
                                       cY=cY-1;
                                       cDir='down';
                                   else %pick open terminal
                                       if obj.Check(cX,cY+1)
                                           cY=cY+1;
                                           cDir='up';
                                       elseif obj.Check(cX+1,cY)
                                           cX=cX+1;
                                           cDir='right';
                                       end
                                   end
                               end
                           end
                       elseif endY>cY %Target is directly above
                           if obj.Check(cX,cY+1)
                               cY=cY+1;
                               cDir='up';
                           elseif obj.Check(cX+1,cY)
                               cX=cX+1;
                               cDir='right';
                           elseif obj.Check(cX-1,cY)
                               cX=cX-1;
                               cDir='left';
                           elseif obj.Check(cX,cY-1)
                               cY=cY-1;
                               cDir='down';
                           end

                       elseif endY<cY %Target is directly below
                           if obj.Check(cX,cY-1)
                               cY=cY-1;
                               cDir='down';
                           elseif obj.Check(cX+1,cY)
                               cX=cX+1;
                               cDir='right';
                           elseif obj.Check(cX-1,cY)
                               cX=cX-1;
                               cDir='left';
                           elseif obj.Check(cX,cY+1)
                               cY=cY+1;
                               cDir='up';
                           end
                       end
                       if iter==1
                           obj.elems{end+1}=DrawElem(obj.compLoops{i}{j},prevX,prevY,prevDir);
                       else
                           if strcmp(cDir,prevDir)==0
                               obj.elems{end+1}=DrawElem('S',prevX,prevY,'elbow');
                               if strcmp(prevDir,'up');
                                   obj.elems{end}.down_filled=true;
                               elseif strcmp(prevDir,'right');
                                   obj.elems{end}.left_filled=true;
                               elseif strcmp(prevDir,'down');
                                   obj.elems{end}.up_filled=true;
                               elseif strcmp(prevDir,'left');
                                   obj.elems{end}.right_fulled=true;
                               end
                               if strcmp(cDir,'up');
                                   obj.elems{end}.up_filled=true;
                               elseif strcmp(cDir,'right');
                                   obj.elems{end}.right_filled=true;
                               elseif strcmp(cDir,'down');
                                   obj.elems{end}.down_filled=true;
                               elseif strcmp(cDir,'left');
                                   obj.elems{end}.left_fulled=true;
                               end
                           else
                               obj.elems{end+1}=DrawElem('S',prevX,prevY,prevDir);
                           end
                       end
                       iter=iter+1;
                       disp(prevDir);
                       disp(cDir);
                   end
                   obj.elems{end+1}=DrawElem('S',cX,cY,'elbow');
                   disp(prevDir);
                   disp(cDir);
                   if strcmp(prevDir,'up');
                       obj.elems{end}.down_filled=true;
                   elseif strcmp(prevDir,'right');
                       obj.elems{end}.left_filled=true;
                   elseif strcmp(prevDir,'down');
                       obj.elems{end}.up_filled=true;
                   elseif strcmp(prevDir,'left');
                       obj.elems{end}.right_fulled=true;
                   end
                   if endX>cX
                       obj.elems{end}.right_filled=true;
                   elseif endX<cX
                       obj.elems{end}.left_filled=true;
                   elseif endY>cY
                       obj.elems{end}.up_filled=true;
                   elseif endY<cY
                       obj.elems{end}.down_fulled=true;
                   end
                end
            end
        end
        
        function MakeGrid(obj)
            shiftX=1;
            shiftY=1;
            %for i=1:numel(obj.elems)
              % if obj.elems{i}.x+1<shiftX
                  % shiftX=abs(obj.elems{i}.x)+1;
              % end
               %if obj.elems{i}.y+1<shiftY
                 %  shiftY=abs(obj.elems{i}.y)+1;
               %end
            %end
            
                obj.gridM= DrawElem.empty;
                for i=1:numel(obj.elems)
                   tempEl=obj.elems{i};
                   cX=tempEl.x+shiftX+1;
                   cY=tempEl.y+shiftY+1;
                   %disp('cX');
                   %disp(cX);
                   %disp('cY');
                   %disp(cY);
                   %disp('put in:');
                   %disp(tempEl);
                   obj.gridM{cY,cX}=tempEl;
                end
                %ends=sqrt(numel(obj.gridM));
                %for j=1:sqrt(numel(obj.gridM))
                 %   disp(j);
                 %   obj.gridM{j,ends}=[];
               % end
                %for j=1:ends
                 %   obj.gridM{ends+1,j}=[];
                %end
                obj.gridDimX=numel(obj.gridM(1,:));
                obj.gridDimY=numel(obj.gridM(:,1));
            end
       % end
        
        function CreateMasterElems(obj) %Draw for master loop
            obj.elems{end+1}=DrawElem(obj.nodeLoops{1}(1),0,0,'none');
            obj.elems{end}.up_filled=true;
            obj.elems{end}.right_filled=true;
            curX=0;
            curY=1;
            i=2;
            compPerBr=numel(obj.compLoops{1})/4;
            curCount=compPerBr - floor(compPerBr);
            while i<=numel(obj.compLoops{1})+1
                j=1;
                while j<=ceil(compPerBr)
                    if j==1
                        if strcmp(obj.curDir,'up')>0 || strcmp(obj.curDir,'down')>0
                            obj.elems{end+1}=DrawElem('S',curX,curY,'up');
                        else
                            obj.elems{end+1}=DrawElem('S',curX,curY,'right');
                        end
                        [curX,curY]=obj.MoveXY(curX,curY);
                    end
                    if curCount <= 0 && j==1
                        if strcmp(obj.curDir,'up')>0 || strcmp(obj.curDir,'down')>0
                            obj.elems{end+1}=DrawElem('S',curX,curY,'up');
                        else
                            obj.elems{end+1}=DrawElem('S',curX,curY,'right');
                        end
                        [curX,curY]=obj.MoveXY(curX,curY);
                        j=j+1;
                    end
                    if strcmp(obj.curDir,'up')>0
                       if obj.loopOrients{1}(i-1)==1
                           obj.elems{end+1}=DrawElem(obj.compLoops{1}{i-1},curX,curY,'up');
                       else
                           obj.elems{end+1}=DrawElem(obj.compLoops{1}{i-1},curX,curY,'down');
                       end
                    elseif strcmp(obj.curDir,'right')>0
                        if obj.loopOrients{1}(i-1)==1
                           obj.elems{end+1}=DrawElem(obj.compLoops{1}{i-1},curX,curY,'right');
                        else
                           obj.elems{end+1}=DrawElem(obj.compLoops{1}{i-1},curX,curY,'left');
                        end
                    elseif strcmp(obj.curDir,'down')>0
                        if obj.loopOrients{1}(i-1)==1
                           obj.elems{end+1}=DrawElem(obj.compLoops{1}{i-1},curX,curY,'down');
                        else
                           obj.elems{end+1}=DrawElem(obj.compLoops{1}{i-1},curX,curY,'up');
                        end
                    elseif strcmp(obj.curDir,'left')>0
                        if obj.loopOrients{1}(i-1)==1
                           obj.elems{end+1}=DrawElem(obj.compLoops{1}{i-1},curX,curY,'left');
                        else
                           obj.elems{end+1}=DrawElem(obj.compLoops{1}{i-1},curX,curY,'right');
                        end
                    end
                    [curX,curY]=obj.MoveXY(curX,curY);
                    if (curCount<=0) & (j==ceil(compPerBr)) 
                        if strcmp(obj.curDir,'up')>0 || strcmp(obj.curDir,'down')>0
                            obj.elems{end+1}=DrawElem('S',curX,curY,'up');
                        else
                            obj.elems{end+1}=DrawElem('S',curX,curY,'right');
                        end
                        [curX,curY]=obj.MoveXY(curX,curY);
                        j=j+1;
                    end
                    
                    if i<numel(obj.compLoops{1})+1
                        obj.elems{end+1}=DrawElem(obj.nodeLoops{1}(i),curX,curY,'none'); %PUT IN NODE
                        if strcmp(obj.curDir,'up')
                            obj.elems{end}.down_filled=true;
                            obj.elems{end}.up_filled=true;
                        elseif strcmp(obj.curDir,'right')
                            obj.elems{end}.left_filled=true;
                            obj.elems{end}.right_filled=true;
                        elseif strcmp(obj.curDir,'down')
                            obj.elems{end}.up_filled=true;
                            obj.elems{end}.down_filled=true;
                        else strcmp(obj.curDir,'left')
                            obj.elems{end}.right_filled=true;
                            obj.elems{end}.left_filled=true;
                        end
                        [curX,curY]=obj.MoveXY(curX,curY);
                    end
                    
                    if j>=ceil(compPerBr)
                        if strcmp(obj.curDir,'up')>0
                            obj.elems{end+1}=DrawElem('S',curX,curY,'elbow');
                            obj.elems{end}.down_filled=true;
                            obj.elems{end}.right_filled=true;
                        elseif strcmp(obj.curDir,'right')>0
                            obj.elems{end+1}=DrawElem('S',curX,curY,'elbow');
                            obj.elems{end}.left_filled=true;
                            obj.elems{end}.down_filled=true;
                        elseif strcmp(obj.curDir,'down')>0
                            obj.elems{end+1}=DrawElem('S',curX,curY,'elbow');
                            obj.elems{end}.up_filled=true;
                            obj.elems{end}.left_filled=true;
                        elseif strcmp(obj.curDir,'left')>0
                            obj.elems{end+1}=DrawElem('S',curX,curY,'left');
                        end
                    end
                    j=j+1;
                    i=i+1;
                end
                curCount=curCount-0.25;
                obj.ChangeDirection();
                [curX,curY]=obj.MoveXY(curX,curY);
            end
            %obj.gridDim=(numel(obj.elems))/4;
        end
        
        function theElem= GetElem(obj, id)
            if ~(id(1)=='R' || id(1)=='V' || id(1)=='C')
                    id=strcat('N',num2str(id));
            end
            for i=1:numel(obj.elems)
                if strcmp(obj.elems{i}.elem_id,id)
                    theElem=obj.elems{i};
                end
            end
        end
        
        function [newX,newY] = MoveXY(obj, curX, curY)
            if strcmp(obj.curDir,'up')
               newX=curX;
               newY=curY+1;
           elseif strcmp(obj.curDir,'right')
               newX=curX+1;
               newY=curY;
           elseif strcmp(obj.curDir,'down')
               newX=curX;
               newY=curY-1;
           elseif strcmp(obj.curDir,'left')
               newX=curX-1;
               newY=curY;
           end
        end
        
        function ChangeDirection(obj)
           if strcmp(obj.curDir,'up')
               obj.curDir='right';
           elseif strcmp(obj.curDir,'right')
               obj.curDir='down';
           elseif strcmp(obj.curDir,'down')
               obj.curDir='left';
           elseif strcmp(obj.curDir,'left')
               obj.curDir='up';
           end
        end
        
        function nextDir = NextDirection(obj,cDir)
           if strcmp(cDir,'up')
               nextDir='right';
           elseif strcmp(cDir,'right')
               nextDir='down';
           elseif strcmp(cDir,'down')
               nextDir='left';
           elseif strcmp(cDir,'left')
               nextDir='up';
           end
        end
        
    end
>>>>>>> 3da1db6a338cf615ebb0ffbac6d91b23be6d27e7
end