package main

import (
	"encoding/json"
	"log"
	"net/http"
	"time"

	"github.com/gorilla/mux"
)

type Response struct {
	Message   string    `json:"message"`
	Timestamp time.Time `json:"timestamp"`
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]string{"status": "healthy"})
}

func helloHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	response := Response{
		Message:   "Hello from Go API!",
		Timestamp: time.Now(),
	}
	json.NewEncoder(w).Encode(response)
}

func main() {
	r := mux.NewRouter()
	r.HandleFunc("/", helloHandler).Methods("GET")
	r.HandleFunc("/health", healthHandler).Methods("GET")

	log.Println("Server starting on port 8080...")
	if err := http.ListenAndServe(":8080", r); err != nil {
		log.Fatal(err)
	}
}
