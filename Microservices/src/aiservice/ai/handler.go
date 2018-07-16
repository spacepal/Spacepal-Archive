package ai

import (
	"aiservice/ai/iai"
	"aiservice/constants"
	"aiservice/helpers"
	"aiservice/model"
	"aiservice/model/imodel"
	"bytes"
	"encoding/json"
	"errors"
	"net/http"

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
		pool:    make(chan imodel.InGetter, constants.TurnHandlerPoolSize),
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
	out.Tasks = make([]imodel.TaskGetter, 0)
	for _, p := range in.AIPlayers() {
		planets := helpers.NewPlanets(in.Planets(), in.MapSize(), p.Player())
		bot := h.manager.Get(p.Name())
		tasks := bot.MakeMove(planets, globStat, in.MapSize())
		out.Tasks = append(out.Tasks, tasks...)
	}
	go func() { // send back
		err := h.asyncResponse(in.CallbackURL(), out)
		if err != nil {
			log.Error("ai/handler.go (async response error): ", err)
		} else {
			log.Info("ai/handler.go tasks are successfully sent")
			log.Info(out)
		}
	}()
}

func (h TurnHandler) asyncResponse(url string, out model.TasksOut) error {
	raw, err := json.Marshal(out)
	if err != nil {
		return err
	}
	req, err := http.NewRequest("POST", url, bytes.NewBuffer(raw))
	if err != nil {
		return err
	}
	req.Header.Set("Content-Type", "application/json")
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()
	if resp.StatusCode != 200 {
		return errors.New("Invalid response status: " + resp.Status)
	}
	return nil
}

// Start goroutine for turn processing
func (h TurnHandler) Start() {
	for in := range h.pool {
		h.process(in)
	}
}
