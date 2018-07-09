package game

import (
	"math"
	"math/rand"

	log "github.com/sirupsen/logrus"
)

const neutralPlanetID = -1
const killDev = 0.1     // standard deviation,
const killMean = 0.5    // expectation of the distribution
const prodDev = 4       // standard deviation,
const prodMean = 10     // expectation of the distribution
const prodMin = 1       // minimum value of production
const capitalProd = 10  // default production of capital
const capitalKill = 0.4 // default kill percentage of capital

// Planet is a model of game planet on map-grid
type Planet struct {
	PlanetID          int     `json:"id"`
	OwnerID           int     `json:"ownerID"`
	CellID            int     `json:"cellID"`
	Production        int     `json:"production"`
	InitialProduction int     `json:"-"`
	KillPercentage    float64 `json:"killPerc"`
	ShipsCount        int     `json:"ships"`
}

func newNeutralPlanet(planetID, cellID int) Planet {
	var p Planet
	p.setRndKillPerc()
	p.setRndProduction()
	p.InitialProduction = p.Production
	p.OwnerID = neutralPlanetID
	p.CellID = cellID
	p.PlanetID = planetID
	p.ShipsCount = p.Production
	return Planet{}
}

// setCapital sets capital status for planet
func (p *Planet) setCapital(owner int) {
	p.InitialProduction = capitalProd
	p.Production = p.InitialProduction
	p.KillPercentage = capitalKill
	p.OwnerID = owner
	p.ShipsCount = p.Production
}

// DecreaseShipsCount reduces a count of ships by value
func (p *Planet) DecreaseShipsCount(byValue int) {
	p.ShipsCount -= byValue
	if p.ShipsCount < 0 {
		log.Error("Ships count is negative!")
		p.ShipsCount = 0
	}
}

// IncProduction increases production
// it used for cumulative production game mode
func (p *Planet) IncProduction() {
	p.Production++
}

// ChangeOwner changes owner of planet
func (p *Planet) ChangeOwner(ownerID int) {
	if p.OwnerID == neutralPlanetID {
		p.setCapital(ownerID)
	} else {
		p.Production = p.InitialProduction
		p.OwnerID = ownerID
	}
}

func (p *Planet) setRndKillPerc() {
	var kill = rand.NormFloat64()*killDev + killMean
	kill = math.Min(math.Max(kill, 0), 1)
	p.KillPercentage = kill
}

func (p *Planet) setRndProduction() {
	var prod = rand.NormFloat64()*prodDev + prodMean
	prod = math.Max(prod, prodMin)
	p.Production = int(prod)
}

// GenPlanets returns a slice of random neutral planets
func GenPlanets(count, mapWidth, mapHeight int) []Planet {
	if count < 0 || mapWidth < 0 || mapHeight < 0 ||
		count > mapWidth*mapHeight {
		return nil
	}
	cellIDs := rand.Perm(mapWidth * mapHeight)
	planets := make([]Planet, count)
	for i := range planets {
		planets[i] = newNeutralPlanet(i, cellIDs[i])
	}
	return planets
}
