package iai

import "aiservice/model/imodel"

// MoveMaker is an interface for artificial intelligence end turn
type MoveMaker interface {
	MakeMove(imodel.InGetter, int) []imodel.TaskGetter
}
