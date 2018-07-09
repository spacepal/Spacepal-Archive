package ai

import (
	"aiservice/model"
	"aiservice/model/imodel"
)

// Base is a simple AI
type Base struct {
	factors model.Factors
}

// MakeMove : end turn by AI
func (b Base) MakeMove(in imodel.InGetter, aiPlayer int) []imodel.TaskGetter {
	// @todo
	return make([]imodel.TaskGetter, 0)
}
