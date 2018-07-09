package model

import "errors"

// MapSize stores size of game-grid
type MapSize struct {
	Width  int `json:"width"`
	Height int `json:"height"`
}

// LastCellID returns ID of last hex-cell
func (m MapSize) LastCellID() int {
	if !m.isValid() {
		return -1
	}
	return m.Width * m.Height
}

func (m MapSize) isValid() bool {
	return m.Width > 0 && m.Height > 0
}

// In is a model of game
type In struct {
	AIPlayers []AIPlayer `json:"aiPlayers"`
	MapSize   MapSize    `json:"map"`
	Planets   []Planet   `json:"planets"`
}

// Check validates In model
func (in In) Check() error {
	if len(in.AIPlayers) == 0 {
		return errors.New("No AI players")
	}
	if !in.MapSize.isValid() {
		return errors.New("Map size must be positive")
	}
	for _, ai := range in.AIPlayers {
		if err := ai.check(); err != nil {
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
