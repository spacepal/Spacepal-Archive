package handler

import "net/http"

// MainHandler receives data from main server
type MainHandler struct {
}

func (h *MainHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("hello world"))
}
