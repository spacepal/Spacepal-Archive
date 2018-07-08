package model

import "errors"

// In is a model of game
type In struct {
	AIPlayers []AIPlayer `json:"aiPlayers"`
	Map       struct {
		Width  int `json:"width"`
		Height int `json:"height"`
	} `json:"map"`
	Planets []Planet `json:"planets"`
}

// Check validates In model
func (in In) Check() error {
	if len(in.AIPlayers) == 0 {
		return errors.New("No AI players")
	}
	if in.Map.Width < 0 || in.Map.Height < 0 {
		return errors.New("Map size must be positive")
	}
	for _, ai := range in.AIPlayers {
		if err := ai.Check(); err != nil {
			return err
		}
	}
	for _, planet := range in.Planets {
		if err := planet.Check(in.Map.Width, in.Map.Height); err != nil {
			return err
		}
	}
	return nil
}
