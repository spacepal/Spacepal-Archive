package server

import (
	"aiservice/ai/iai"
	"aiservice/model"
	"encoding/json"
	"fmt"
	"net/http"

	log "github.com/sirupsen/logrus"
)

// DoHandler handles request for move-action
type DoHandler struct {
	handler iai.Handler
	manager iai.ManagerChecker
}

// NewDoHandler is a factory method for DoHandler
func NewDoHandler(
	handler iai.Handler,
	manager iai.ManagerChecker,
) http.Handler {
	return &DoHandler{handler, manager}
}

func (h *DoHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()
	if r.Method != "POST" {
		http.Error(w,
			"403 - Method not allowed. Use POST instead.",
			http.StatusMethodNotAllowed)
		return
	}
	var in model.In
	if err := json.NewDecoder(r.Body).Decode(&in); err != nil {
		http.Error(w,
			fmt.Sprintf("400 - Bad request. Error: %v.", err),
			http.StatusBadRequest)
		log.Error("handler.do.go: ", err)
		return
	}
	if err := in.Check(h.manager); err != nil {
		http.Error(w,
			fmt.Sprintf("406 - Not Acceptable. Error: %v.", err),
			http.StatusNotAcceptable)
		log.Error("handler.do.go: ", err)
		return
	}
	h.handler.Handle(in)
	// log.Print(in)
	w.Write([]byte("hello world"))
}
