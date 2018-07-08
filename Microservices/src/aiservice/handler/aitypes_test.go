package handler

import (
	"aiservice/constants"
	"aiservice/model"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestAITypesHandler(t *testing.T) {
	testServ := httptest.NewServer(new(AITypesHandler))
	defer testServ.Close()
	r, err := http.Get(testServ.URL)
	if err != nil {
		t.Fatal(err)
	}
	defer r.Body.Close()
	var out model.AITypesOut
	if err := json.NewDecoder(r.Body).Decode(&out); err != nil {
		t.Fatal(err)
	}
	if len(out.Types) != len(constants.AITypes) {
		t.Fatalf("Invalid count of types: get: %d, want: %d",
			len(out.Types), len(constants.AITypes))
	}
	for _, aiType := range out.Types {
		if _, ok := constants.AITypes[aiType]; !ok {
			t.Fatalf("Type %s is not found", aiType)
		}
	}
}

func TestAITypesNotMehtodAllowed(t *testing.T) {
	testServ := httptest.NewServer(new(AITypesHandler))
	defer testServ.Close()
	r, err := http.Post(testServ.URL, "", nil)
	if err != nil {
		t.Fatal(err)
	}
	if r.StatusCode != http.StatusMethodNotAllowed {
		t.Fatalf("Only status, get: %d, want: %d",
			r.StatusCode, http.StatusMethodNotAllowed)
	}
}
