package ai

import "aiservice/model"

// IAI is an interface of artificial intelligence
type IAI interface {
	doTurn(model.In)
}

// ManagerRegister is an interface of artificial intelligence registration
type ManagerRegister interface {
	Register(string, IAI)
	IsRegistered(string) bool
}

// ManagerGetter is an interface for getting artificial intelligences
type ManagerGetter interface {
	Get(string) IAI
	All() []string
	Count() int
}

// Manager registers all AI
type Manager struct {
	all map[string]IAI
}

// NewManager creates NewManager
func NewManager() *Manager {
	return &Manager{make(map[string]IAI)}
}

// Register adds AI to the manager
func (a *Manager) Register(name string, ai IAI) {
	a.all[name] = ai
}

// IsRegistered checks that AI is already registered
func (a *Manager) IsRegistered(name string) (ok bool) {
	_, ok = a.all[name]
	return
}

// Get returns AI by name
func (a *Manager) Get(name string) IAI {
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
