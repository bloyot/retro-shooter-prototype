class_name EventManger extends Node

# map of event type -> array of callback functions
var callbacks: Dictionary
	
func subscribe(event_type: GlobalUtils.EventType, callback: Callable) -> void:
	# TODO (if possible) verify that the callback args match the registered arg type
	if callbacks.has(event_type):
		callbacks[event_type].append(callback)	
	else:
		callbacks[event_type] = [callback]
	
func publish(event_type: GlobalUtils.EventType, args: Array[Variant]) -> void:
	# TODO verify that args match the registered arg types
	if callbacks.has(event_type):
		for callable: Callable in callbacks[event_type]:
			callable.call(args)	
