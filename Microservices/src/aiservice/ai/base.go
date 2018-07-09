package ai

import "aiservice/model"

// BaseAI is a simple artificial intelligence
type BaseAI struct {
	factors model.Factors
}

// DoTurn makes a move
func (b BaseAI) DoTurn(in model.In, aiPlayer int) []model.Task {
	// @todo
	return make([]model.Task, 0)
}
