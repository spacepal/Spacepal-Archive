package handler

import (
	"aiservice/constants"
	"aiservice/model"
	"encoding/json"
	"net/http"
)

// AITypesHandler handles request for AI types list
type AITypesHandler struct {
}

func (h *AITypesHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()
	if r.Method != "GET" {
		http.Error(w,
			"403 - Method not allowed. Use GET instead.",
			http.StatusMethodNotAllowed)
		return
	}
	var out model.AITypesOut
	for aiType := range constants.AITypes {
		out.Types = append(out.Types, aiType)
	}
	raw, err := json.Marshal(out)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	w.Write(raw)
}
