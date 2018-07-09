package iai

// ManagerRegister is an interface for artificial intelligence registration
type ManagerRegister interface {
	Register(string, MoveMaker)
}

// ManagerChecker is an interface that checks AI registration
type ManagerChecker interface {
	Check(string) bool
}

// ManagerGetter is an interface for getting artificial intelligences
type ManagerGetter interface {
	Get(string) MoveMaker
	All() []string
	Count() int
}
