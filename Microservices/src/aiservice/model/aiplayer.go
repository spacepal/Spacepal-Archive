package model

import (
	"aiservice/ai/iai"
	"errors"
	"fmt"
)

// AIPlayer represents main information about computer-player
type AIPlayer struct {
	Name   string `json:"aiName"`
	Player int    `json:"playerID"`
}

// Check validates AIPlayer model
func (ai AIPlayer) check(manager iai.ManagerChecker) error {
	if !manager.Check(ai.Name) {
		return errors.New(
			fmt.Sprint("Invalid AI name. PlayerID:", ai.Player))
	}
	return nil
}
