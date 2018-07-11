package main

import (
	"bytes"
	"encoding/json"
	"errors"
	"fakeserver/game"
	"fakeserver/game/igame"
	"fakeserver/game/model"
	"fmt"
	"math/rand"
	"net/http"
	"time"

	log "github.com/sirupsen/logrus"
)

const aiDoURL = "http://localhost:3131/ai/do"
const servAddr = "localhost:3531"
const callbackURL = "fake/callback?gameID=1"
const timeoutDuration = 15 * time.Second

type prox struct {
	lock chan bool
	game igame.Game
	out  struct { // it's a buffer struct
		Callback string         `json:"callback"`
		Players  []igame.Player `json:"aiPlayers"`
		MapSize  struct {
			Width  int `json:"width"`
			Height int `json:"height"`
		} `json:"map"`
		Planets []igame.Planet `json:"planets"`
	}
	in struct {
		Tasks []model.Task `json:"tasks"`
	}
}

func newProx(game igame.Game, params model.GameParams) *prox {
	var p = prox{}
	p.lock = make(chan bool)
	p.game = game
	p.out.Callback = fmt.Sprintf("http://%s/%s", servAddr, callbackURL)
	p.out.MapSize.Width = params.MapWidth
	p.out.MapSize.Height = params.MapHeight

	return &p
}

func (p *prox) StartServ() error {
	http.HandleFunc("/", p.tasksHandle)
	return http.ListenAndServe(servAddr, nil)
}

func (p *prox) tasksHandle(w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()
	defer func() {
		select {
		case p.lock <- true:
		default:
		}
	}()
	if err := json.NewDecoder(r.Body).Decode(&p.in); err != nil {
		p.in.Tasks = nil
		log.Error(err)
		return
	}
}

func (p *prox) EndTurn() error {
	p.out.Players = p.game.Players()
	p.out.Planets = p.game.Planets()
	raw, err := json.Marshal(p.out)
	if err != nil {
		return err
	}
	r, err := http.Post(aiDoURL, "application/json", bytes.NewBuffer(raw))
	if err != nil {
		return err
	}
	defer r.Body.Close()
	if r.StatusCode != http.StatusOK {
		var errMsg = make([]byte, 256)
		r.Body.Read(errMsg)
		return errors.New("Invalid http-status: " + string(errMsg))
	}
	select {
	case <-p.lock:
	case <-time.After(timeoutDuration):
		return errors.New("Timeout")
	}
	p.game.EndTurn(p.in.Tasks)
	return nil
}

func main() {
	var gameParams = model.GameParams{
		MapHeight:    6,
		MapWidth:     10,
		PlayersCount: 4,
		PlanetsCount: 20,
	}
	game, err := game.NewGame(gameParams)
	if err != nil {
		log.Fatal(err)
	}
	gameProxy := newProx(game, gameParams)
	if gameProxy == nil {
		log.Fatal("game proxy is nil")
	}
	go func() {
		log.Fatal(gameProxy.StartServ())
	}()

	for !game.IsOver() {
		log.Info("Turn: ", game.TurnNumber())
		printPlayers(game)
		printPlanets(game)
		// fmt.Println("Press [enter] for end turn")
		// fmt.Scanln()
		err := gameProxy.EndTurn()
		if err != nil {
			log.Error(err)
		}
	}
	log.Print("The game is end")
}

func init() {
	rand.Seed(time.Now().UnixNano())
}
