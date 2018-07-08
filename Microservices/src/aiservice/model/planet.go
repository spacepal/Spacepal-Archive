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
	Kill  float32 `json:"killPerc"`
	Ships float32 `json:"ships"`
}

// Check validates Planet model
func (planet Planet) Check(mapWidth, mapHeight int) error {
	minCell, maxCell := 1, mapWidth*mapHeight
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