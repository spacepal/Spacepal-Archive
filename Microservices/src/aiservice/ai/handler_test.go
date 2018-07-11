package ai

import (
	"aiservice/model"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"
)

const aiName = "testBot"
const timeoutDuration = 5 * time.Second
const aiPlayersCount = 2 // It's hardcoded in AllPlanets

var aiHandlerIn = model.In{
	Callback: "This'll be set in the code",
	ArtIntPlayers: []model.AIPlayer{
		model.AIPlayer{
			AIName:   aiName,
			PlayerID: 1,
		},
		model.AIPlayer{
			AIName:   aiName,
			PlayerID: 2,
		},
	},
	MapGridSize: model.MapSize{
		MapWidth:  100,
		MapHeight: 100,
	},
	AllPlanets: []model.Planet{
		model.Planet{
			PlanetID:       1,
			Production:     100,
			KillPercentage: 1.0,
			OwnerID:        2,
			ShipsCount:     10,
			CellID:         1,
		}, model.Planet{
			PlanetID:       2,
			Production:     100,
			KillPercentage: 1.0,
			OwnerID:        2,
			ShipsCount:     10,
			CellID:         2,
		}, model.Planet{
			PlanetID:       3,
			Production:     100,
			KillPercentage: 1.0,
			OwnerID:        1,
			ShipsCount:     10,
			CellID:         3,
		}, model.Planet{
			PlanetID:       4,
			Production:     100,
			KillPercentage: 1.0,
			OwnerID:        1,
			ShipsCount:     10,
			CellID:         4,
		}, model.Planet{
			PlanetID:       5,
			Production:     100,
			KillPercentage: 1.0,
			OwnerID:        2,
			ShipsCount:     10,
			CellID:         5,
		},
	},
}

func TestAIHandler(t *testing.T) {
	var baseAI = NewBase(FakeFactor{}, FakeFactor{})
	var manager = NewManager()
	manager.Register(aiName, baseAI)
	var turnHandler = NewTurnHandler(manager)
	if turnHandler == nil {
		t.Fatal("turHandler == nil")
	}

	var rCh = make(chan bool)
	ts := httptest.NewServer(
		http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			defer func() { rCh <- true }() // unlock test
			var outModel = struct {
				Tasks []struct {
					Player int `json:"player"`
					From   int `json:"from"`
					To     int `json:"to"`
					Count  int `json:"count"`
				} `json:"tasks"`
			}{}
			if err := json.NewDecoder(r.Body).Decode(&outModel); err != nil {
				t.Fatal(err)
			}
			players := make(map[int]bool)
			for _, t := range outModel.Tasks {
				players[t.Player] = true
			}
			if len(players) != aiPlayersCount {
				t.Fatalf("Not all players have made a move; players count, want: %d, get: %d",
					aiPlayersCount, len(players))
			}
		}))
	defer ts.Close()

	aiHandlerIn.Callback = ts.URL
	turnHandler.Handle(aiHandlerIn)

	go turnHandler.Start()

	select {
	case <-rCh:
	case <-time.After(timeoutDuration):
		t.Fatal("Timeout")
	}
}
