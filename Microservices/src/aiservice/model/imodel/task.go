package imodel

// TaskGetter has methods for getting main information about task
type TaskGetter interface {
	From() int
	To() int
	Count() int
}
