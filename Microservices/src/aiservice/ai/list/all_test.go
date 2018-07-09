package list

import (
	"aiservice/ai"
	"testing"
)

func TestRegisterAll(t *testing.T) {
	manager := ai.NewManager()
	RegisterAll(manager)
	if manager.Count() == 0 {
		t.Fatal("RegisterAll doesn't register anything")
	}
}
