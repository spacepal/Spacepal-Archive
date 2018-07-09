package model

import (
	"aiservice/ai/iai"
	"errors"
)

// In is a model of game
type In struct {
	AIPlayers []AIPlayer `json:"aiPlayers"`
	MapSize   MapSize    `json:"map"`
	Planets   []Planet   `json:"planets"`
}

// Check validates In model
func (in In) Check(manager iai.ManagerChecker) error {
	if len(in.AIPlayers) == 0 {
		return errors.New("No AI players")
	}
	if !in.MapSize.isValid() {
		return errors.New("Map size must be positive")
	}
	for _, ai := range in.AIPlayers {
		if err := ai.check(manager); err != nil {
			return err
		}
	}
	for _, planet := range in.Planets {
		if err := planet.check(in.MapSize); err != nil {
			return err
		}
	}
	return nil
}
