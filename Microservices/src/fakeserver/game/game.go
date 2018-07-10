package game

import (
	"fakeserver/game/igame"
	"fakeserver/game/model"
)

// Game emulates fake game
type Game struct {
	params     model.GameParams
	planets    []planet
	players    []player
	turn       int
	tasks      map[int]model.Task // ships in space
	lastTaskID int
}

// NewGame creates a new implementation of game
func NewGame(params model.GameParams) (igame.Game, error) {
	if err := params.Check(); err != nil {
		return nil, err
	}
	g := Game{params: params, turn: 1, lastTaskID: 0}
	g.genPlanets()
	if err := g.genPlayers(); err != nil {
		return nil, err
	}
	return &g, nil
}

// EndTurn processes turn of game
func (g *Game) EndTurn(tasks []model.Task) {
	for _, task := range tasks {
		g.pushTask(task)
	}
	g.turn++
}

func (g *Game) pushTask(task model.Task) {
	g.tasks[g.lastTaskID] = task
	g.lastTaskID++
}
