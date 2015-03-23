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

SAT_CURR_CustomerProduct_SF: new uml.State({position: {x:100, y:100},size: {width:200, height:100},name: "SAT_CURR_CustomerProduct_SF",events: ["Seniority","InitialStartDate","FlagActive"]}),
SAT_CURR_CustomerProduct_SF2: new uml.State({position: {x:100, y:100},size: {width:200, height:100},name: "SAT_CURR_CustomerProduct_SF",events: ["Seniority","InitialStartDate","FlagActive"]}),
SAT_CURR_CustomerProduct_SF3: new uml.State({position: {x:100, y:100},size: {width:200, height:100},name: "SAT_CURR_CustomerProduct_SF",events: ["Seniority","InitialStartDate","FlagActive"]})

};

graph.addCells(states);

//states.s2.embed(states.s4);

var transitons = [
new uml.Transition({ source: { id: states.HUB_CustomerProduct.id }, target: { id: states.SAT_CURR_CustomerProduct_SF.id }}),
new uml.Transition({ source: { id: states.HUB_CustomerProduct.id }, target: { id: states.SAT_CURR_CustomerProduct_SF2.id }}),
new uml.Transition({ source: { id: states.HUB_CustomerProduct.id }, target: { id: states.SAT_CURR_CustomerProduct_SF3.id }})
];

graph.addCells(transitons);

var graphLayout = new joint.layout.ForceDirected({
	graph: graph,
	width: 380, height: 280,
	gravityCenter: { x: 190, y: 145 },
	charge: 2000,
	linkDistance: 250
});
graphLayout.start();

function animate() {
	joint.util.nextFrame(animate);
	graphLayout.step();
}

$('#btn-layout').on('click', animate);