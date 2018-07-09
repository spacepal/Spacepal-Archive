package model

import (
	"aiservice/constants"
	"errors"
	"fmt"
)

// Planet is a model of map main cell
type Planet struct {
	PlanetID       int     `json:"id"`
	OwnerID        int     `json:"ownerID"`
	CellID         int     `json:"cellID"`
	Production     int     `json:"production"`
	KillPercentage float64 `json:"killPerc"`
	ShipsCount     int     `json:"ships"`
}

// ID returns a planet ID
func (planet Planet) ID() int {
	return planet.PlanetID
}

// Owner returns ID of a planet owner
func (planet Planet) Owner() int {
	return planet.OwnerID
}

// Cell returns ID of cell on which a planet is placed
func (planet Planet) Cell() int {
	return planet.CellID
}

// Prod returns production of planet
func (planet Planet) Prod() int {
	return planet.Production
}

// Kill returns kill percentage of planet
// 0 <= Kill <= 1
func (planet Planet) Kill() float64 {
	return planet.KillPercentage
}

// Ships returns count of ships on the planet
func (planet Planet) Ships() int {
	return planet.ShipsCount
}

func (planet Planet) normalizedProd() float64 {
	return float64(planet.Production) / constants.MidProd
}

func (planet Planet) normalizedKill() float64 {
	return planet.KillPercentage / constants.MidKill
}

// NormalizedPower returns normalized value of power (Kill * Prod)
func (planet Planet) NormalizedPower() float64 {
	return planet.normalizedProd() * planet.normalizedKill()
}

// IsNeutral checks that planet doesn't have owner
func (planet Planet) IsNeutral() bool {
	return planet.OwnerID == constants.NeutralOwnerID
}

// check validates Planet model
func (planet Planet) check(mapSize MapSize) error {
	minCell, maxCell := 1, mapSize.LastCellID()
	if planet.CellID < minCell || planet.CellID > maxCell {
		return errors.New(
			fmt.Sprint("CellID out of range. PlanetID: ", planet.PlanetID))
	}
	if planet.Production < 0 {
		return errors.New(
			fmt.Sprint("Production must be positive. PlanetID: ", planet.PlanetID))
	}
	if planet.ShipsCount < 0 {
		return errors.New(
			fmt.Sprint("Ships must be positive. PlanetID: ", planet.PlanetID))
	}
	if planet.KillPercentage < constants.MinKillPerc ||
		planet.KillPercentage > constants.MaxKillPerc {
		return errors.New(
			fmt.Sprint("KillPercentage out of range. PlanetID: ", planet.PlanetID))
	}
	return nil
}
