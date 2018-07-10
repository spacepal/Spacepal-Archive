package model

import "errors"

// GameParams contains arguments for game-creation
type GameParams struct {
	MapWidth, MapHeight    int
	ProductionAfterCapture bool
	PlayersCount           int
	PlanetsCount           int
}

// Check validates GameParams
func (p *GameParams) Check() error {
	if p.PlayersCount < 2 {
		return errors.New("Invalid count of players")
	}
	if p.MapWidth <= 0 || p.MapHeight <= 0 {
		return errors.New("Map size is negative")
	}
	if p.PlayersCount > p.PlanetsCount {
		return errors.New("There is no place for players")
	}
	if p.PlanetsCount > p.MapWidth*p.MapHeight {
		return errors.New("There is no place for planets")
	}
	return nil
}
