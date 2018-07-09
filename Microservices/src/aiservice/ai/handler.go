package ai

import (
	"aiservice/ai/iai"
	"aiservice/helpers"
	"aiservice/model"
	"aiservice/model/imodel"
	"encoding/json"

	log "github.com/sirupsen/logrus"
)

// TurnHandler processes turn requests
type TurnHandler struct {
	pool    chan imodel.InGetter
	manager iai.ManagerGetter
}

// NewTurnHandler is a factory method of TurnHandler
func NewTurnHandler(manager iai.ManagerGetter) iai.Handler {
	return &TurnHandler{
		pool:    make(chan imodel.InGetter, 1024),
		manager: manager,
	}
}

// Handle request
func (h TurnHandler) Handle(in imodel.InGetter) {
	h.pool <- in
}

func (h TurnHandler) process(in imodel.InGetter) {
	var globStat = helpers.NewGlobStat(in.Planets())
	var out model.TasksOut
	out.Players = make([]model.TasksOfPlayer, 0)
	for _, p := range in.AIPlayers() {
		planets := helpers.NewPlanets(in.Planets(), p.Player())
		bot := h.manager.Get(p.Name())
		tasks := bot.MakeMove(planets, globStat, in.MapSize())
		player := model.TasksOfPlayer{
			Player: p.Player(),
			Tasks:  tasks,
		}
		out.Players = append(out.Players, player)
	}
	// @todo: send back
	raw, err := json.Marshal(out)
	if err != nil {
		log.Print(raw)
	} else {
		log.Error(err)
	}
}

// Start goroutine for turn processing
func (h TurnHandler) Start() {
	for in := range h.pool {
		h.process(in)
	}
}
