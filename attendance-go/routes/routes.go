package routes

import (
    "attendance-go/controllers"
    "github.com/gin-gonic/gin"
    "database/sql"
)

func SetupRoutes(r *gin.Engine, db *sql.DB) {
    userController := controllers.NewUserController(db)
    r.GET("/users", userController.GetAllUsers)
    r.POST("/register", userController.Register)
    r.POST("/login", userController.Login)
}