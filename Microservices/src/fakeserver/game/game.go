package game

import (
	"fakeserver/game/igame"
	"fakeserver/game/model"

	log "github.com/sirupsen/logrus"
)

// Game emulates fake game
type Game struct {
	params     model.GameParams
	planets    []planet // planet index == planet id
	players    []player // player index == player id
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
	g.processShips()
	for _, task := range tasks {
		if g.pushTask(task) {
			g.planets[task.From].ShipsCount -= task.Count
		}
	}
	g.processPlanets()
	g.turn++
}

// IsOver checks game end
func (g *Game) IsOver() bool {
	var activePlayers = make(map[int]bool)
	for _, p := range g.planets {
		if !p.IsNeutral() {
			activePlayers[p.OwnerID] = true
		}
	}
	for _, t := range g.tasks {
		activePlayers[t.Player] = true
	}
	return len(activePlayers) <= 1
}

// Players returns all members
func (g *Game) Players() []igame.Player {
	g.recalculatePlayerStat()
	players := make([]igame.Player, len(g.players))
	for i, p := range g.players {
		players[i] = p
	}
	return players
}

// Planets returns all generated planets
func (g Game) Planets() []igame.Planet {
	planets := make([]igame.Planet, len(g.planets))
	for i, p := range g.planets {
		planets[i] = p
	}
	return planets
}

// pushTask append a new task if is valid
func (g *Game) pushTask(task model.Task) bool {
	if err := task.Check(); err != nil {
		log.Error("game.go pushTask(): ", err, " [", task, "]")
		return false
	}
	if task.From > len(g.planets) {
		log.Error("game.go pushTask(): invalid From planetID [", task, "]")
		return false
	}
	if task.To > len(g.planets) {
		log.Error("game.go pushTask(): invalid To in task [", task, "]")
		return false
	}
	if owner := task.Player; owner != g.planets[task.From].OwnerID {
		log.Errorf("game.go pushTask(): The player$%d does not own planet$%d [%v]",
			owner, task.From, task)
		return false
	}
	g.tasks[g.lastTaskID] = task
	g.lastTaskID++
	return true
}
