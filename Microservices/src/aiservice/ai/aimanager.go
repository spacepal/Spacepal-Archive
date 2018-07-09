package ai

import "aiservice/ai/iai"

// Manager registers all AI
type Manager struct {
	all map[string]iai.MoveMaker
}

// NewManager creates NewManager
func NewManager() *Manager {
	return &Manager{make(map[string]iai.MoveMaker)}
}

// Register adds AI to the manager
func (a *Manager) Register(name string, ai iai.MoveMaker) {
	a.all[name] = ai
}

// Check tests that AI is already registered
func (a *Manager) Check(name string) (ok bool) {
	_, ok = a.all[name]
	return
}

// Get returns AI by name
func (a *Manager) Get(name string) iai.MoveMaker {
	return a.all[name]
}

// All returns all AI names
func (a *Manager) All() []string {
	var names = make([]string, len(a.all))
	i := 0
	for name := range a.all {
		names[i] = name
		i++
	}
	return names
}

// Count returns count of registered AI
func (a *Manager) Count() int {
	return len(a.all)
}
