package main

import (
	"aiservice/constants"
	"aiservice/handler"
	"flag"
	"net/http"

	log "github.com/sirupsen/logrus"
)

func main() {
	var addr = flag.String("addr", constants.Address, "address to serve")
	flag.Parse()
	var handler = new(handler.MainHandler)
	http.Handle("/do", handler)
	log.Fatal(http.ListenAndServe(*addr, nil))
}
