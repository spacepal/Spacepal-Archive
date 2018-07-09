package ai

import (
	"aiservice/helpers/ihelpers"
	"aiservice/model/imodel"
	"fmt"
	"testing"
)

type FakeMoveMaker struct {
}

func (f FakeMoveMaker) MakeMove(
	planets ihelpers.PlanetsGetter,
	globStat ihelpers.GlobStatGetter,
	mapSize imodel.MapSizeGetter,
) []imodel.TaskGetter {
	return nil
}

func TestManager(t *testing.T) {
	count := 32
	manager := NewManager()
	if manager == nil {
		t.Fatal("manager == nil")
	}
	for i := 0; i < count; i++ {
		manager.Register(fmt.Sprint("ai_", i), nil)
	}
	if manager.Count() != count {
		t.Log("Some bots doen't registered")
		t.Errorf("Invalid manager.Count(), want: %d, get: %d",
			count, manager.Count())
	}
	if len(manager.All()) != count {
		t.Log("A length of returned bots array isn't valid")
		t.Errorf("Invalid len(manager.All()), want: %d, get: %d",
			count, len(manager.All()))
	}
	for i := 0; i < count; i++ {
		if !manager.Check(fmt.Sprint("ai_", i)) {
			t.Error("The registered bot ai_", i, "doesn't exist")
		}
	}

	var fakeAI = FakeMoveMaker{}
	manager.Register("special_ai", fakeAI)
	if manager.Get("special_ai") != fakeAI {
		t.Error("manager.Get(\"special_ai\") != fakeAI")
	}
	if manager.Get("invalid_ai_name") != nil {
		t.Error("manager.Get(\"invalid_ai_name\") != nil")
	}
	if manager.Get("ai_0") != nil {
		t.Error("manager.Get(\"ai_0\") != nil")
	}
}
