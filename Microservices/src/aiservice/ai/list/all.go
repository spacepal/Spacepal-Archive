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

	r.Register("Zane", ai.NewBase(
		&factor{ // redistribution
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
}
