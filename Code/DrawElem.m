classdef DrawElem
    properties
        type
        x
        y
        elem_id
        direction
        %For node elems:
        up_filled=false;
        right_filled=false;
        down_filled=false;
        left_filled=false;
    end
    methods
        function obj = DrawElem(id,x1,y1,d)
            if (id(1) == 'R')
                obj.type='r';
                obj.elem_id=id;
            elseif id(1) == 'C'
                obj.type='c';
                obj.elem_id=id;
            elseif id(1) == 'V'
                obj.type='v';
                obj.elem_id=id;
            elseif id(1) == 'S'
                obj.type='s';
                obj.elem_id=id;
            else
                obj.type='n';
                obj.elem_id=strcat('N',num2str(id));
            end
            
            
            obj.x=x1;
            obj.y=y1;
            obj.direction=d;
        end
    end
end