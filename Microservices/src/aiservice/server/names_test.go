package server

import (
	"aiservice/ai"
	"aiservice/model"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestAINamesHandler(t *testing.T) {
	var manager = ai.NewManager()
	manager.Register("test_0", nil)
	manager.Register("test_2", nil)
	manager.Register("test_3", nil)
	testServ := httptest.NewServer(NewAINamesHandler(manager))
	defer testServ.Close()
	r, err := http.Get(testServ.URL)
	if err != nil {
		t.Fatal(err)
	}
	defer r.Body.Close()
	var out model.AINamesOut
	if err := json.NewDecoder(r.Body).Decode(&out); err != nil {
		t.Fatal(err)
	}
	if len(out.All) != manager.Count() {
		t.Fatalf("Invalid count of names: get: %d, want: %d",
			len(out.All), manager.Count())
	}
	if out.Count != manager.Count() {
		t.Fatalf("Invalid Count field: get: %d, want: %d",
			out.Count, manager.Count())
	}
	for _, aiName := range out.All {
		if !manager.Check(aiName) {
			t.Fatalf("Name %s is not found", aiName)
		}
	}
}

func TestAINamesNotMehtodAllowed(t *testing.T) {
	testServ := httptest.NewServer(new(AINamesHandler))
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
