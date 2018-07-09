package ai

import (
	"aiservice/ai/iai"
	"aiservice/model/imodel"
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

}

// Start goroutine for turn processing
func (h TurnHandler) Start() {

}
