package handler

import (
	"aiservice/model"
	"encoding/json"
	"fmt"
	"net/http"

	log "github.com/sirupsen/logrus"
)

// DoHandler handles request for move-action
type DoHandler struct {
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
		log.Error("handler.main.go: ", err)
		return
	}
	log.Print(in)
	w.Write([]byte("hello world"))
}
