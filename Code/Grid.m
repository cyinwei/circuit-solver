classdef Grid<handle
    properties
        gridM %Matrix of grid data
        elems %array of all DrawElems in grid
        nodeLoops
        compLoops
        loopOrients %list of orientations for each loop
        curDir='up' %which way are we currently going?
        gridDim=0;
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
                   disp('from')
                   disp(startX);
                   disp(startY);
                   disp('to');
                   disp(endX);
                   disp(endY);
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
            for i=1:numel(obj.elems)
               if obj.elems{i}.x+1<shiftX
                   shiftX=abs(obj.elems{i}.x)+1;
               end
               if obj.elems{i}.y+1<shiftY
                   shiftY=abs(obj.elems{i}.y)+1;
               end
            end
            
            obj.gridM= DrawElem.empty;
            for i=1:numel(obj.elems)
               tempEl=obj.elems{i};
               cX=tempEl.x+shiftX+1;
               cY=tempEl.y+shiftY+1;
               disp('put in:');
               disp(tempEl);
               obj.gridM{cX,cY}=tempEl;
            end
            ends=sqrt(numel(obj.gridM));
            for i=1:sqrt(numel(obj.gridM))
                disp(i);
                obj.gridM{i,ends}=[];
            end
            for i=1:ends
                obj.gridM{ends+1,i}=[];
            end
        end
        
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
            obj.gridDim=(numel(obj.elems))/4;
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
        
        function ShowGrid(obj)
           for i=1:obj.gridDim+1
               for j=1:obj.gridDim+1
                   
               end
           end
        end
    end
end