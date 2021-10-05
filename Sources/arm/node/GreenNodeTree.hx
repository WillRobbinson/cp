package arm.node;

@:access(armory.logicnode.LogicNode)@:keep class GreenNodeTree extends armory.logicnode.LogicTree {

	var functionNodes:Map<String, armory.logicnode.FunctionNode>;

	var functionOutputNodes:Map<String, armory.logicnode.FunctionOutputNode>;

	public function new() {
		super();
		name = "GreenNodeTree";
		this.functionNodes = new Map();
		this.functionOutputNodes = new Map();
		notifyOnAdd(add);
	}

	override public function add() {
		var _SetObjectVisible = new armory.logicnode.SetVisibleNode(this);
		_SetObjectVisible.property0 = "object";
		_SetObjectVisible.preallocInputs(4);
		_SetObjectVisible.preallocOutputs(1);
		var _Keyboard = new armory.logicnode.MergedKeyboardNode(this);
		_Keyboard.property0 = "released";
		_Keyboard.property1 = "d";
		_Keyboard.preallocInputs(0);
		_Keyboard.preallocOutputs(2);
		armory.logicnode.LogicNode.addLink(_Keyboard, new armory.logicnode.BooleanNode(this, false), 1, 0);
		armory.logicnode.LogicNode.addLink(_Keyboard, _SetObjectVisible, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, "PinkCube"), _SetObjectVisible, 0, 1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.BooleanNode(this, false), _SetObjectVisible, 0, 2);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.BooleanNode(this, true), _SetObjectVisible, 0, 3);
		armory.logicnode.LogicNode.addLink(_SetObjectVisible, new armory.logicnode.NullNode(this), 0, 0);
		var _SetObjectVisible_001 = new armory.logicnode.SetVisibleNode(this);
		_SetObjectVisible_001.property0 = "object";
		_SetObjectVisible_001.preallocInputs(4);
		_SetObjectVisible_001.preallocOutputs(1);
		var _Keyboard_001 = new armory.logicnode.MergedKeyboardNode(this);
		_Keyboard_001.property0 = "released";
		_Keyboard_001.property1 = "f";
		_Keyboard_001.preallocInputs(0);
		_Keyboard_001.preallocOutputs(2);
		armory.logicnode.LogicNode.addLink(_Keyboard_001, new armory.logicnode.BooleanNode(this, false), 1, 0);
		armory.logicnode.LogicNode.addLink(_Keyboard_001, _SetObjectVisible_001, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, "PinkCube"), _SetObjectVisible_001, 0, 1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.BooleanNode(this, true), _SetObjectVisible_001, 0, 2);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.BooleanNode(this, true), _SetObjectVisible_001, 0, 3);
		armory.logicnode.LogicNode.addLink(_SetObjectVisible_001, new armory.logicnode.NullNode(this), 0, 0);
	}
}