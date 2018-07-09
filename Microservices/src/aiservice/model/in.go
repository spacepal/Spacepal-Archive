package model

import (
	"aiservice/ai/iai"
	"aiservice/model/imodel"
	"errors"
)

// In is a model of game
type In struct {
	ArtIntPlayers []AIPlayer `json:"aiPlayers"`
	MapGridSize   MapSize    `json:"map"`
	AllPlanets    []Planet   `json:"planets"`
}

// AIPlayers returns list of AI players in the game
func (in In) AIPlayers() []imodel.AIPlayerGetter {
	players := make([]imodel.AIPlayerGetter, len(in.ArtIntPlayers))
	for i, p := range in.ArtIntPlayers {
		players[i] = p
	}
	return players
}

// MapSize returns size of map grid
func (in In) MapSize() imodel.MapSizeGetter {
	return in.MapGridSize
}

// Planets returns all planets that are placed on the map surface
func (in In) Planets() []imodel.PlanetGetter {
	planets := make([]imodel.PlanetGetter, len(in.AllPlanets))
	for i, p := range in.AllPlanets {
		planets[i] = p
	}
	return planets
}

// Check validates In model
func (in In) Check(manager iai.ManagerChecker) error {
	if len(in.ArtIntPlayers) == 0 {
		return errors.New("No AI players")
	}
	if !in.MapGridSize.isValid() {
		return errors.New("Map size must be positive")
	}
	for _, ai := range in.ArtIntPlayers {
		if err := ai.check(manager); err != nil {
			return err
		}
	}
	for _, planet := range in.AllPlanets {
		if err := planet.check(in.MapGridSize); err != nil {
			return err
		}
	}
	return nil
}
