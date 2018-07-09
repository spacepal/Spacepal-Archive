package ai

import "aiservice/model"

// BaseAI is a simple artificial intelligence
type BaseAI struct {
	factors model.Factors
}

func (b BaseAI) doTurn(planets []model.Planet, aiPlayer int) {
	// @todo
}
