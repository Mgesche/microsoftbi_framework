(function() {

    var LightLinkView = joint.dia.LinkView.extend({

        node: V('<line stroke="gray" fill="none" />'),

        initialize: function() {
            
            joint.dia.CellView.prototype.initialize.apply(this, arguments);
            
            V(this.el).attr({ 'class': 'link', 'model-id': this.model.id });
            
            // this.throttledUpdate = _.bind(_.throttle(this.update, 10), this);
        },
        
        render: function() {

            var node = this.node.clone();

            this._sourceModel = this.paper.getModelById(this.model.get('source').id);
            this._targetModel = this.paper.getModelById(this.model.get('target').id);
                
            this._lineNode = V(node.node);

            var attrs = this.model.get('attrs');
            if (attrs && attrs.line)
                this._lineNode.attr(attrs.line);
            
            this._sourceModel.on('change:position', this.update);
            this._targetModel.on('change:position', this.update);
            
                this.update();

            V(this.el).append(node);
            },

        update: function() {

            var sourceSize = this._sourceModel.get('size') || { width: 0, height: 0 };
            var targetSize = this._targetModel.get('size') || { width: 0, height: 0 };
            
            var sourcePosition = this._sourceModel.get('position');
            var targetPosition = this._targetModel.get('position');

            if (sourcePosition && targetPosition) {

                sourcePosition = g.point(sourcePosition).offset(sourceSize.width/2, sourceSize.height/2);
                targetPosition = g.point(targetPosition).offset(targetSize.width/2, targetSize.height/2);

                this._lineNode.node.setAttribute('x1', sourcePosition.x);
                this._lineNode.node.setAttribute('y1', sourcePosition.y);
                this._lineNode.node.setAttribute('x2', targetPosition.x);
                this._lineNode.node.setAttribute('y2', targetPosition.y);
            }
        }
    });

    var graph = new joint.dia.Graph;
    var paper = new joint.dia.Paper({
        el: $('#paper-holder'),
        width: 400,
        height: 300,
        gridSize: 1,
        model: graph,
        linkView: LightLinkView
    });

    var cells = [
        { type: 'link', source: { id: 'A' }, target: { id: 'B' }, z: -1 },
        { type: 'link', source: { id: 'A' }, target: { id: 'C' }, z: -1 },
        { type: 'link', source: { id: 'A' }, target: { id: 'D' }, z: -1 },
        { type: 'link', source: { id: 'A' }, target: { id: 'E' }, z: -1 },
        { type: 'link', source: { id: 'A' }, target: { id: 'F' }, z: -1 },
        { type: 'link', source: { id: 'A' }, target: { id: 'G' }, z: -1 },
        { type: 'link', source: { id: 'B' }, target: { id: 'H' }, z: -1 },
        { type: 'link', source: { id: 'B' }, target: { id: 'I' }, z: -1 },
        { type: 'link', source: { id: 'B' }, target: { id: 'J' }, z: -1 },
        { id: 'A', type: 'basic.Circle', size: { width: 20, height: 20 }, attrs: { text: { text: 'A', fill: 'white' }, circle: { fill: '#E67E22', stroke: '#D35400' } } },
        { id: 'B', type: 'basic.Circle', size: { width: 20, height: 20 }, attrs: { text: { text: 'B', fill: 'white' }, circle: { fill: '#E67E22', stroke: '#D35400' } } },
        { id: 'C', type: 'basic.Circle', size: { width: 20, height: 20 }, attrs: { text: { text: 'C', fill: 'white' }, circle: { fill: '#E67E22', stroke: '#D35400' } } },
        { id: 'D', type: 'basic.Circle', size: { width: 20, height: 20 }, attrs: { text: { text: 'D', fill: 'white' }, circle: { fill: '#E67E22', stroke: '#D35400' } } },
        { id: 'E', type: 'basic.Circle', size: { width: 20, height: 20 }, attrs: { text: { text: 'E', fill: 'white' }, circle: { fill: '#E67E22', stroke: '#D35400' } } },
        { id: 'F', type: 'basic.Circle', size: { width: 20, height: 20 }, attrs: { text: { text: 'F', fill: 'white' }, circle: { fill: '#E67E22', stroke: '#D35400' } } },
        { id: 'G', type: 'basic.Circle', size: { width: 20, height: 20 }, attrs: { text: { text: 'G', fill: 'white' }, circle: { fill: '#E67E22', stroke: '#D35400' } } },
        { id: 'H', type: 'basic.Circle', size: { width: 20, height: 20 }, attrs: { text: { text: 'H', fill: 'white' }, circle: { fill: '#E67E22', stroke: '#D35400' } } },
        { id: 'I', type: 'basic.Circle', size: { width: 20, height: 20 }, attrs: { text: { text: 'I', fill: 'white' }, circle: { fill: '#E67E22', stroke: '#D35400' } } },
        { id: 'J', type: 'basic.Circle', size: { width: 20, height: 20 }, attrs: { text: { text: 'J', fill: 'white' }, circle: { fill: '#E67E22', stroke: '#D35400' } } }
    ];

    graph.fromJSON({ cells: cells });

    var graphLayout = new joint.layout.ForceDirected({
        graph: graph,
        width: 380, height: 280,
        gravityCenter: { x: 190, y: 145 },
        charge: 180,
        linkDistance: 30
    });
    graphLayout.start();

    function animate() {
        joint.util.nextFrame(animate);
        graphLayout.step();
    }

    $('#btn-layout').on('click', animate);
    
}())