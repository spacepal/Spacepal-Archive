package main

import (
	"fakeserver/game"
	"fakeserver/game/model"
	"math/rand"
	"time"

	log "github.com/sirupsen/logrus"
)

func main() {
	_, err := game.NewGame(model.GameParams{
		MapHeight:    6,
		MapWidth:     10,
		PlayersCount: 4,
		PlanetsCount: 20,
	})
	if err != nil {
		log.Fatal(err)
	}
	log.Print("hello world")
}

func init() {
	rand.Seed(time.Now().UnixNano())
}
