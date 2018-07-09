package model

import (
	"aiservice/ai/iai"
	"errors"
	"fmt"
)

// AIPlayer represents main information about computer-player
type AIPlayer struct {
	AIName   string `json:"aiName"`
	PlayerID int    `json:"playerID"`
}

// Name returns the name of the artificial intelligence
func (ai AIPlayer) Name() string {
	return ai.AIName
}

// Player returns the AI player ID
func (ai AIPlayer) Player() int {
	return ai.PlayerID
}

// Check validates AIPlayer model
func (ai AIPlayer) check(manager iai.ManagerChecker) error {
	if !manager.Check(ai.AIName) {
		return errors.New(
			fmt.Sprint("Invalid AI name. PlayerID:", ai.PlayerID))
	}
	return nil
}
