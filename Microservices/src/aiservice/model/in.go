package model

import (
	"aiservice/ai/iai"
	"aiservice/model/imodel"
	"errors"
	"fmt"
	"net/url"
)

// In is a model of game
type In struct {
	Callback      string     `json:"callback"`
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

// CallbackURL returns a url to send an asynchronous response
func (in In) CallbackURL() string {
	return in.Callback
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
	if _, err := url.Parse(in.Callback); err != nil {
		return errors.New("Callback URL is invalid")
	}
	if len(in.ArtIntPlayers) < 1 {
		return errors.New("Invalid count of players")
	}
	if len(in.AllPlanets) < len(in.ArtIntPlayers) {
		return errors.New("Invalid count of planets")
	}
	if !in.MapGridSize.isValid() {
		return errors.New("Map size must be positive")
	}
	players := make(map[int]bool)
	for _, ai := range in.ArtIntPlayers {
		if err := ai.check(manager); err != nil {
			return err
		}
		if _, ok := players[ai.PlayerID]; ok {
			return errors.New(fmt.Sprint("Player ID: ", ai.PlayerID, " is not unique"))
		}
		players[ai.PlayerID] = true
	}
	planetIDs := make(map[int]bool)
	for _, planet := range in.AllPlanets {
		if _, ok := planetIDs[planet.PlanetID]; ok {
			return errors.New(fmt.Sprint("Planet ID: ",
				planet.PlanetID, " is not unique"))
		}
		planetIDs[planet.PlanetID] = true
		if err := planet.check(in.MapGridSize); err != nil {
			return err
		}
	}
	return nil
}
