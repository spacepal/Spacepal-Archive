package game

// Player is a member of the game
type player struct {
	ShipsCount int     `json:"-"`
	Power      float64 `json:"-"`
	MemberID   int     `json:"playerID"`
	AIName     string  `json:"aiName"`
}

// Score returs a sum of panet-powers
func (p player) Score() float64 {
	return p.Power
}

// Ships returns a full count of ships (Tasks+Planets)
func (p player) Ships() int {
	return p.ShipsCount
}

// ID returns an ID of member in the game
func (p player) ID() int {
	return p.MemberID
}

// Name returns the name of bot
func (p player) Name() string {
	return p.AIName
}

// genPlayers generates a list of random players
func (g *Game) genPlayers() error {
	aiNames, err := newAiNames()
	if err != nil {
		return err
	}
	g.players = make([]player, g.params.PlayersCount)
	for i := 0; i < g.params.PlayersCount; i++ {
		g.players[i] = player{
			MemberID:   i,
			AIName:     aiNames.PickRandom(),
			ShipsCount: -1,
			Power:      -1,
		}
	}
	return nil
}

func (g *Game) recalculatePlayerStat() {
	for id, player := range g.players {
		var power float64
		var shipsCount int
		for _, planet := range g.planets {
			if planet.OwnerID == player.MemberID {
				power += planet.KillPercentage * float64(planet.Production)
				shipsCount += planet.ShipsCount
			}
		}
		for _, task := range g.tasks {
			if task.Player == player.MemberID {
				shipsCount += task.Count
			}
		}
		g.players[id].Power = power
		g.players[id].ShipsCount = shipsCount
	}
}
