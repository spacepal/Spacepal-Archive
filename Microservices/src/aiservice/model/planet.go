package model

import (
	"aiservice/constants"
	"errors"
	"fmt"
)

// Planet is a model of map main cell
type Planet struct {
	ID    int     `json:"id"`
	Owner int     `json:"ownerID"`
	Cell  int     `json:"cellID"`
	Prod  int     `json:"production"`
	Kill  float64 `json:"killPerc"`
	Ships int     `json:"ships"`
}

func (planet *Planet) normalizedProd() float64 {
	return float64(planet.Prod) / constants.MidProd
}

func (planet *Planet) normalizedKill() float64 {
	return planet.Kill / constants.MidKill
}

// NormalizedPower returns normalized value of power (Kill * Prod)
func (planet *Planet) NormalizedPower() float64 {
	return planet.normalizedProd() * planet.normalizedKill()
}

// check validates Planet model
func (planet Planet) check(mapSize MapSize) error {
	minCell, maxCell := 1, mapSize.LastCellID()
	if planet.Cell < minCell || planet.Cell > maxCell {
		return errors.New(
			fmt.Sprint("CellID out of range. PlanetID: ", planet.ID))
	}
	if planet.Prod < 0 {
		return errors.New(
			fmt.Sprint("Production must be positive. PlanetID: ", planet.ID))
	}
	if planet.Ships < 0 {
		return errors.New(
			fmt.Sprint("Ships must be positive. PlanetID: ", planet.ID))
	}
	if planet.Kill < constants.MinKillPerc || planet.Kill > constants.MaxKillPerc {
		return errors.New(
			fmt.Sprint("KillPercentage out of range. PlanetID: ", planet.ID))
	}
	return nil
}
