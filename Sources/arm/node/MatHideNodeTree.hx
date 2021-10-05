package arm.node;

@:access(armory.logicnode.LogicNode)@:keep class MatHideNodeTree extends armory.logicnode.LogicTree {

	var functionNodes:Map<String, armory.logicnode.FunctionNode>;

	var functionOutputNodes:Map<String, armory.logicnode.FunctionOutputNode>;

	public function new() {
		super();
		name = "MatHideNodeTree";
		this.functionNodes = new Map();
		this.functionOutputNodes = new Map();
		notifyOnAdd(add);
	}

	override public function add() {
		var _SetObjectVisible = new armory.logicnode.SetVisibleNode(this);
		_SetObjectVisible.property0 = "object";
		_SetObjectVisible.preallocInputs(4);
		_SetObjectVisible.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.NullNode(this), _SetObjectVisible, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, "GreenCube"), _SetObjectVisible, 0, 1);
		var _Mouse = new armory.logicnode.MergedMouseNode(this);
		_Mouse.property0 = "down";
		_Mouse.property1 = "left";
		_Mouse.preallocInputs(0);
		_Mouse.preallocOutputs(2);
		armory.logicnode.LogicNode.addLink(_Mouse, new armory.logicnode.BooleanNode(this, false), 1, 0);
		armory.logicnode.LogicNode.addLink(_Mouse, _SetObjectVisible, 0, 2);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.BooleanNode(this, true), _SetObjectVisible, 0, 3);
		armory.logicnode.LogicNode.addLink(_SetObjectVisible, new armory.logicnode.NullNode(this), 0, 0);
	}
}