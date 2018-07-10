package game

import (
	"encoding/json"
	"net/http"
)

const aiNamesURL = "http://localhost:3131/ai/names"

type aiNames struct {
	All   []string `json:"all"`
	Count int      `json:"count"`
}

// getAINames make a request to a aiservice for getting bot names
func getAINames() ([]string, error) {
	r, err := http.Get(aiNamesURL)
	if err != nil {
		return nil, err
	}
	defer r.Body.Close()
	names := aiNames{}
	err = json.NewDecoder(r.Body).Decode(&names)
	if err != nil {
		return nil, err
	}
	return names.All, nil
}
