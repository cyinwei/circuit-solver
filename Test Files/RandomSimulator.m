%Randomly generates netlists for our program

rng('shuffle');

count = 1; 
numberOfNodes = 10;
numberOfComponents = 15;

%generate random values
Nodes;
Components;
ComponentTypes;


Nodes = randi([0 numberOfNodes], 1, numberOfNodes);
groundNode = Nodes(1);

ComponentNames = randi([1 numberOfComponents], 1, numberOfComponents);
ComponentTypes = randi([1 3], 1, numberOfComponents);
ComponentValues = randi([1 1000], 1, numberOfComponents);

%create the string outputs
for i=1:numberOfComponents
    if
    Component(i) = strcat(num2str(

