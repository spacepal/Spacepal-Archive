package ai

import "aiservice/model"

// AITypes is a map of registered AI types
var AITypes = map[string]IAI{}

func registerAI(name string, ai IAI) {
	AITypes[name] = ai
}

// IAI is an interface of artificial intelligence
type IAI interface {
	doTurn(model.In)
}
