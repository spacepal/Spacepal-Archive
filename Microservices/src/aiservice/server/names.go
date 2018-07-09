package server

import (
	"aiservice/ai/iai"
	"aiservice/model"
	"encoding/json"
	"net/http"
)

// AINamesHandler handles request for AI names list
type AINamesHandler struct {
	manager iai.ManagerGetter
}

// NewAINamesHandler creates new AINamesHandler
func NewAINamesHandler(manager iai.ManagerGetter) http.Handler {
	return &AINamesHandler{manager}
}

func (h *AINamesHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()
	if r.Method != "GET" {
		http.Error(w,
			"403 - Method not allowed. Use GET instead.",
			http.StatusMethodNotAllowed)
		return
	}
	var out = model.AINamesOut{
		All:   h.manager.All(),
		Count: h.manager.Count(),
	}
	raw, err := json.Marshal(out)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	w.Write(raw)
}
