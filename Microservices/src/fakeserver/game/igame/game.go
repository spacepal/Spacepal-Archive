package igame

import "fakeserver/game/model"

// Game is an interface of emulated game
type Game interface {
	EndTurn(tasks []model.Task)
}
