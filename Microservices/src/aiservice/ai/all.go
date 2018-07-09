package ai

// RegisterAll adds all AI's to the manager
func RegisterAll(r ManagerRegister) {
	r.Register("base", BaseAI{})
}
