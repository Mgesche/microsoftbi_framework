var graph = new joint.dia.Graph;

var paper = new joint.dia.Paper({
    el: $('#paper'),
    width: 1600,
    height: 600,
    gridSize: 1,
    model: graph
});

var uml = joint.shapes.uml;

var states = {

HUB_CustomerProduct: new uml.State({position: {x:100, y:100},size: {width:200, height:100},name: "HUB_CustomerProduct"}),

SAT_CURR_CustomerProduct_SF: new uml.State({position: {x:400, y:100},size: {width:200, height:100},name: "SAT_CURR_CustomerProduct_SF",events: ["Seniority","InitialStartDate","FlagActive"]})

};

graph.addCells(states);

//states.s2.embed(states.s4);

var transitons = [
new uml.Transition({ source: { id: states.HUB_CustomerProduct.id }, target: { id: states.SAT_CURR_CustomerProduct_SF.id }})
];

graph.addCells(transitons);