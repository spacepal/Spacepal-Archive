package model

import (
	"testing"
)

type FakeManagerChecker struct {
	res bool
}

func (f FakeManagerChecker) Check(name string) bool {
	return f.res
}

func TestAIPlayerCheck(t *testing.T) {
	known := FakeManagerChecker{true}
	unknown := FakeManagerChecker{false}
	player := AIPlayer{
		AIName:   "known",
		PlayerID: 1,
	}
	if err := player.check(known); err != nil {
		t.Log(err)
		t.Error("player.check(known) != nil")
	}

	player = AIPlayer{
		AIName:   "unknown",
		PlayerID: 2,
	}
	if err := player.check(unknown); err == nil {
		t.Log(err)
		t.Error("player.check(unknown) == nil")
	}
}
