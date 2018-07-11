package igame

import "fakeserver/game/model"

// Game is an interface of emulated game
type Game interface {
	EndTurn(tasks []model.Task)
	Players() []Player
	Planets() []Planet
	IsOver() bool
}
