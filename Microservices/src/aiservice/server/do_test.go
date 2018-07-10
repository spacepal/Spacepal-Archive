package server

import (
	"aiservice/model"
	"aiservice/model/imodel"
	"bytes"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
)

var validIn = model.In{
	AllPlanets: []model.Planet{
		model.Planet{
			CellID:         1,
			KillPercentage: 1,
			OwnerID:        1,
			PlanetID:       1,
			Production:     10,
			ShipsCount:     10,
		},
		model.Planet{
			CellID:         2,
			KillPercentage: 1,
			OwnerID:        2,
			PlanetID:       2,
			Production:     10,
			ShipsCount:     10,
		},
	},
	Callback:    "http://localhost:3131/nocallback",
	MapGridSize: model.MapSize{MapHeight: 10, MapWidth: 10},
	ArtIntPlayers: []model.AIPlayer{
		{AIName: "bot1", PlayerID: 1},
		{AIName: "bot2", PlayerID: 2},
	},
}

var isFakeHandled = false

type FakeAIHandler struct {
}

func (f FakeAIHandler) Handle(in imodel.InGetter) { isFakeHandled = true }
func (f FakeAIHandler) Start()                    {}

type fakeManagerChecker struct {
	isValid bool
}

func (f fakeManagerChecker) Check(name string) bool { return f.isValid }

func TestDoValidRequest(t *testing.T) {
	handler := FakeAIHandler{}
	testServ := httptest.NewServer(NewDoHandler(
		handler, fakeManagerChecker{true}))
	defer testServ.Close()
	rawIn, _ := json.Marshal(validIn)
	r, err := http.Post(testServ.URL, "application/json", bytes.NewBuffer(rawIn))
	if err != nil {
		t.Fatal(err)
	}
	if r.StatusCode != http.StatusOK {
		t.Fatalf("Invalid status code, get: %d, want: %d",
			r.StatusCode, http.StatusOK)
	}
	if !isFakeHandled {
		t.Fatalf("AI handler doesn't handle anything")
	}
}

func TestDoNotAcceptable(t *testing.T) {
	testServ := httptest.NewServer(NewDoHandler(
		FakeAIHandler{}, fakeManagerChecker{false})) // false is a key of the test
	defer testServ.Close()
	rawIn, _ := json.Marshal(validIn)
	r, err := http.Post(testServ.URL, "application/json", bytes.NewBuffer(rawIn))
	if err != nil {
		t.Fatal(err)
	}
	if r.StatusCode != http.StatusNotAcceptable {
		t.Fatalf("Invalid status code, get: %d, want: %d",
			r.StatusCode, http.StatusNotAcceptable)
	}
}

func TestDoBadRequest(t *testing.T) {
	testServ := httptest.NewServer(NewDoHandler(
		FakeAIHandler{}, fakeManagerChecker{true}))
	defer testServ.Close()
	r, err := http.Post(testServ.URL, "application/json", nil)
	if err != nil {
		t.Fatal(err)
	}
	if r.StatusCode != http.StatusBadRequest {
		t.Fatalf("Invalid status code, get: %d, want: %d",
			r.StatusCode, http.StatusBadRequest)
	}
}

func TestDoNotMehtodAllowed(t *testing.T) {
	testServ := httptest.NewServer(NewDoHandler(FakeAIHandler{},
		fakeManagerChecker{true}))
	defer testServ.Close()
	r, err := http.Get(testServ.URL)
	if err != nil {
		t.Fatal(err)
	}
	if r.StatusCode != http.StatusMethodNotAllowed {
		t.Fatalf("Invalid status code, get: %d, want: %d",
			r.StatusCode, http.StatusMethodNotAllowed)
	}
}
