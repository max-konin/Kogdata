class primary
	Function::property = (prop, desc) ->
	    Object.defineProperty @prototype, prop, desc

window.primary = primary
