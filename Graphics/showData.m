%Needs a completed circuit input, completed grid input

function showData(grid, circuit, row, column)
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
    disp (typeName);
    disp(voltage);
    disp(current);
    if(type == 'r')
        disp(resistance);
    end
    disp(power);
  
end

