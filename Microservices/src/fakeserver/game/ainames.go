package game

import (
	"encoding/json"
	"errors"
	"math/rand"
	"net/http"
)

const aiNamesURL = "http://localhost:3131/ai/names"

type aiNames struct {
	All   []string `json:"all"`
	Count int      `json:"count"`
}

// PickRandom returns a random AI name from the list
func (aiNames *aiNames) PickRandom() string {
	return aiNames.All[rand.Intn(len(aiNames.All))]
}

// newAiName make a request to a aiservice for getting bot names
func newAiNames() (*aiNames, error) {
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
	if names.Count != len(names.All) {
		return nil, errors.New("aiservice returns invalid count of AI names")
	}
	if names.Count == 0 {
		return nil, errors.New("aiservice doesn't have any AI")
	}
	return &names, nil
}
