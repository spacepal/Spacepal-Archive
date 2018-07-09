package ai

import "aiservice/ai/iai"

// RegisterAll adds all AI's to the manager
func RegisterAll(r iai.ManagerRegister) {
	r.Register("base", Base{})
}
