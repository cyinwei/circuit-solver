function cir= StartCircuit(filename)
    c=Circuit();
    fid = fopen(filename);
    tline=fgetl(fid);

    scount=1;
    while ischar(tline)
       args=strsplit(tline,' ');
    
       disp(args{2});
        if args{1}(1)=='V'
            c.AddVSource(str2num(args{2}), str2num(args{3}), str2num(args{4}), args{1});
        elseif args{1}(1)=='R'
            c.AddResistor(str2num(args{2}), str2num(args{3}), str2num(args{4}), args{1});
        elseif args{1}(1)=='C'
            c.AddCSource(str2num(args{2}), str2num(args{3}), str2num(args{4}), args{1});
        %elseif args{1}(1)=='S'
         %   c.AddResistor(0, str2num(args{2}), str2num(args{3}), strcat('S',num2str(scount)));
         %   scount=scount+1;
        elseif args{1}(1)=='G'
            c.SetGround(str2num(args{2}));
        end
        
        tline=fgetl(fid);
    end
    %c.MakeEquations();
    %c.StartDrawTraverse();
    cir=c;
end