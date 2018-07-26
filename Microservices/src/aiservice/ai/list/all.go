// Package list containts all AI params
package list

import (
	"aiservice/ai"
	"aiservice/ai/iai"
)

// RegisterAll adds all AI's to the manager
func RegisterAll(r iai.ManagerRegister) {
	r.Register("Nontle", ai.NewBase(
		&factor{ // redistribution
			quantity:    +0.1,
			random:      +4.0,
			prod:        +1.0,
			kill:        +0.0,
			power:       +0.0,
			ships:       0.0,
			playerPower: +0.0,
			distance:    -0.1,
		},
		&factor{ // attack
			quantity:    +0.9,
			random:      +1.0,
			prod:        +0.6,
			kill:        +0.4,
			power:       +0.0,
			ships:       -0.2,
			playerPower: +0.0,
			distance:    -2.0,
		}))

	r.Register("Zane", ai.NewAcceptor(
		&factor{ // for getting main planet
			quantity:    +0.7,
			random:      +0.0,
			prod:        +1.0,
			kill:        +0.0,
			power:       +0.0,
			ships:       +0.0,
			playerPower: +0.0,
			distance:    +0.0,
		},
		&factor{ // attack
			quantity:    +1.0,
			random:      +2.0,
			prod:        +1.0,
			kill:        +0.0,
			power:       +0.0,
			ships:       +0.0,
			playerPower: +0.0,
			distance:    -2.0,
		}))

	r.Register("Dick", ai.NewHorde(
		&factor{ // for getting main planet
			quantity:    +0.0,
			random:      +0.0,
			prod:        +10.0,
			kill:        +0.0,
			power:       +0.0,
			ships:       +0.0,
			playerPower: +0.0,
			distance:    +0.0,
		},
		&factor{ // for getting target planet to attack
			quantity:    +1.0,
			random:      +2.0,
			prod:        +1.0,
			kill:        +0.0,
			power:       +0.0,
			ships:       +0.0,
			playerPower: +0.0,
			distance:    -2.0,
		}))

	r.Register("Drina", ai.NewZonesAcceptor(
		&factor{ // for getting main planet in zone
			quantity:    +0.8,
			random:      +0.0,
			prod:        +0.0,
			kill:        +1.0,
			power:       +0.0,
			ships:       +0.0,
			playerPower: +0.0,
			distance:    +2.0,
		},
		&factor{ // for getting target planet to attack
			quantity:    +0.9,
			random:      +2.0,
			prod:        +1.0,
			kill:        +0.0,
			power:       +0.0,
			ships:       +0.0,
			playerPower: +0.0,
			distance:    -2.0,
		},
		&factor{ // attack on first steps
			quantity:    +0.9,
			random:      +1.0,
			prod:        +0.0,
			kill:        -3.0,
			power:       +0.0,
			ships:       +0.0,
			playerPower: +0.0,
			distance:    -2.0,
		}))
}
