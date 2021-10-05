package arm.node;

@:access(armory.logicnode.LogicNode)@:keep class BlueCubeMouseClickedNodeTree extends armory.logicnode.LogicTree {

	var functionNodes:Map<String, armory.logicnode.FunctionNode>;

	var functionOutputNodes:Map<String, armory.logicnode.FunctionOutputNode>;

	public function new() {
		super();
		name = "BlueCubeMouseClickedNodeTree";
		this.functionNodes = new Map();
		this.functionOutputNodes = new Map();
		notifyOnAdd(add);
	}

	override public function add() {
		var _SetObjectVisible = new armory.logicnode.SetVisibleNode(this);
		_SetObjectVisible.property0 = "object";
		_SetObjectVisible.preallocInputs(4);
		_SetObjectVisible.preallocOutputs(1);
		var _Gate = new armory.logicnode.GateNode(this);
		_Gate.property0 = "Equal";
		_Gate.property1 = 9.999999747378752e-05;
		_Gate.preallocInputs(3);
		_Gate.preallocOutputs(2);
		var _Mouse = new armory.logicnode.MergedMouseNode(this);
		_Mouse.property0 = "down";
		_Mouse.property1 = "left";
		_Mouse.preallocInputs(0);
		_Mouse.preallocOutputs(2);
		armory.logicnode.LogicNode.addLink(_Mouse, new armory.logicnode.BooleanNode(this, false), 1, 0);
		armory.logicnode.LogicNode.addLink(_Mouse, _Gate, 0, 0);
		var _Object = new armory.logicnode.ObjectNode(this);
		_Object.preallocInputs(1);
		_Object.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, "BlueCube"), _Object, 0, 0);
		armory.logicnode.LogicNode.addLink(_Object, _Gate, 0, 1);
		var _PickRB = new armory.logicnode.PickObjectNode(this);
		_PickRB.preallocInputs(2);
		_PickRB.preallocOutputs(2);
		var _Vector = new armory.logicnode.VectorNode(this);
		_Vector.preallocInputs(3);
		_Vector.preallocOutputs(1);
		var _GetCursorLocation = new armory.logicnode.GetCursorLocationNode(this);
		_GetCursorLocation.preallocInputs(0);
		_GetCursorLocation.preallocOutputs(4);
		armory.logicnode.LogicNode.addLink(_GetCursorLocation, new armory.logicnode.IntegerNode(this, 0), 2, 0);
		armory.logicnode.LogicNode.addLink(_GetCursorLocation, new armory.logicnode.IntegerNode(this, 0), 3, 0);
		armory.logicnode.LogicNode.addLink(_GetCursorLocation, _Vector, 0, 0);
		armory.logicnode.LogicNode.addLink(_GetCursorLocation, _Vector, 1, 1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.FloatNode(this, 0.0), _Vector, 0, 2);
		armory.logicnode.LogicNode.addLink(_Vector, _PickRB, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.IntegerNode(this, 1), _PickRB, 0, 1);
		armory.logicnode.LogicNode.addLink(_PickRB, new armory.logicnode.VectorNode(this, 0.0,0.0,0.0), 1, 0);
		armory.logicnode.LogicNode.addLink(_PickRB, _Gate, 0, 2);
		armory.logicnode.LogicNode.addLink(_Gate, new armory.logicnode.NullNode(this), 1, 0);
		armory.logicnode.LogicNode.addLink(_Gate, _SetObjectVisible, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, "BlueCube"), _SetObjectVisible, 0, 1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.BooleanNode(this, true), _SetObjectVisible, 0, 2);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.BooleanNode(this, true), _SetObjectVisible, 0, 3);
		armory.logicnode.LogicNode.addLink(_SetObjectVisible, new armory.logicnode.NullNode(this), 0, 0);
	}
}