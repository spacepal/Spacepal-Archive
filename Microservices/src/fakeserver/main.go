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
	"sync"
	"time"

	log "github.com/sirupsen/logrus"
)

const aiDoURL = "http://localhost:3131/ai/do"
const servAddr = "localhost:3531"
const callbackURL = "fake/callback?gameID=1"

type prox struct {
	wg   sync.WaitGroup
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
	defer p.wg.Done()
	if err := json.NewDecoder(r.Body).Decode(&p.in); err != nil {
		p.in.Tasks = nil
		log.Error(err)
		return
	}
	log.Info(p.in.Tasks)
}

func (p *prox) EndTurn() error {
	p.out.Players = p.game.Players()
	p.out.Planets = p.game.Planets()
	raw, err := json.Marshal(p.out)
	if err != nil {
		return err
	}
	var r *http.Response
	p.wg.Add(1)
	log.Info(string(raw))
	r, err = http.Post(aiDoURL, "application/json", bytes.NewBuffer(raw))
	if err == nil {
		defer r.Body.Close()
		if r.StatusCode != http.StatusOK {
			var errMsg = make([]byte, 256)
			r.Body.Read(errMsg)
			err = errors.New("Invalid http-status: " + string(errMsg))
		}
	}
	p.wg.Wait()
	if err != nil {
		return err
	}
	p.game.EndTurn(p.in.Tasks)
	return nil
}

func main() {
	var gameParams = model.GameParams{
		MapHeight:    4,
		MapWidth:     4,
		PlayersCount: 4,
		PlanetsCount: 10,
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
			log.Fatal(err)
		}
	}
	log.Print("The game is end")
}

func init() {
	rand.Seed(time.Now().UnixNano())
}
