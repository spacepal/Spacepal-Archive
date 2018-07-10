package game

import "errors"

type Game struct {
	params  GameParams
	planets []planet
	players []player
	turn    int
}

type GameParams struct {
	MapWidth, MapHeight    int
	ProductionAfterCapture bool
	PlayersCount           int
	PlanetsCount           int
}

func (p *GameParams) check() error {
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

func NewGame(params GameParams) (*Game, error) {
	if err := params.check(); err != nil {
		return nil, err
	}
	g := Game{params: params, turn: 1}
	g.genPlanets()
	if err := g.genPlayers(); err != nil {
		return nil, err
	}
	return &g, nil
}

func (g *Game) endTurn(tasks Task) {
	g.turn++
}
