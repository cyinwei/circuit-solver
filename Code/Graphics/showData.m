%Needs a completed circuit input, completed grid input

function showData(grid, circuit, row, column)


    dataWindow = figure('Position', [100 100 300 300], ...
                                                    'Name', 'Status', 'NumberTitle', 'Off');
                  %display the data here...
                  %TODO
                  
    currentDrawElems = grid.gridM(row, column);
    currentComponent = circuit.GetComp(currentDrawElems.elem_id);
    
    %display data
    typeName;
    voltage;
    current;
    power;
    resistance;
    
    
    type = currentDrawElems.type;
    
    %gets the display data
    switch type
        case 'v'
            typeName = strcat('Voltage Source ', currentDrawElems.elem_id);
            voltage = currentComponent.voltage;
            current = currentComponent.current;
            power = currentComponent.power;
            
        case 'c'
            typeName = strcat('Current Source ', currentDrawElems.elem_id);
            voltage = currentComponent.voltage;
            current = currentComponent.current;
            
        case 'r' 
            typeName = strcat('Resistor ', currentDrawElems.elem_id);
            voltage = currentComponent.voltage;
            current = currentComponent.current;
            resistance = currentComponent.resistance;
            power = currentComponent.power;
        
    %time to print the data
    text(10,10, typeName);
    text(10,40, voltage);
    text(10,70, current);
    if type == 'r'
        text(10, 100, resistance);
        text(10, 130, power);
    else
        text(10, 100, power);
    end
   
    
end

