package main

import (
	"attendance-go/routes"
	"database/sql"
	"fmt"
	"log"

	"github.com/gin-gonic/gin"
	_ "github.com/denisenkom/go-mssqldb"
)

func InitDB() (*sql.DB, error) {
	connectionString := "server=localhost;user id=sa;password=mauraallexa;database=attendance"
	db, err := sql.Open("mssql", connectionString)
	if err != nil {
		return nil, fmt.Errorf("error opening database: %v", err)
	}

	if err = db.Ping(); err != nil {
		return nil, fmt.Errorf("error connecting to database: %v", err)
	}

	return db, nil
}

func main() {
	db, err := InitDB()
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	r := gin.Default()
	routes.SetupRoutes(r, db)

	log.Println("Server berjalan pada http://localhost:8080")
	log.Fatal(r.Run(":8080"))
}