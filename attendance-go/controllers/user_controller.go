package controllers

import (
    "attendance-go/models"
    "database/sql"
    "net/http"
    "github.com/gin-gonic/gin"
    "golang.org/x/crypto/bcrypt"
    "log"
)

type UserController struct {
    DB *sql.DB
}

func NewUserController(db *sql.DB) *UserController {
    return &UserController{DB: db}
}

func (uc *UserController) Register(c *gin.Context) {
    var user models.User
    if err := c.ShouldBindJSON(&user); err != nil {
        log.Printf("Error binding JSON for registration: %v", err)
        c.JSON(http.StatusBadRequest, gin.H{"error": "Gagal membaca data registrasi"})
        return
    }

    if user.Username == "" || user.Password == "" || user.Email == "" {
        c.JSON(http.StatusBadRequest, gin.H{"error": "Username, password, dan email harus diisi"})
        return
    }

    hashedPassword, err := bcrypt.GenerateFromPassword([]byte(user.Password), bcrypt.DefaultCost)
    if err != nil {
        log.Printf("Error hashing password: %v", err)
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal mengenkripsi password"})
        return
    }

    query := `INSERT INTO users (username, password, email) VALUES (?, ?, ?)`
    result, err := uc.DB.Exec(query, user.Username, string(hashedPassword), user.Email)
    if err != nil {
        log.Printf("Error inserting user: %v", err)
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal menyimpan data pengguna"})
        return
    }

    userID, _ := result.LastInsertId()

    c.JSON(http.StatusCreated, gin.H{
        "message": "Registrasi berhasil",
        "user_id": userID,
        "username": user.Username,
        "email": user.Email,
    })
}

func (uc *UserController) Login(c *gin.Context) {
    var creds models.User
    if err := c.ShouldBindJSON(&creds); err != nil {
        log.Printf("Error binding JSON for login: %v", err)
        c.JSON(http.StatusBadRequest, gin.H{"error": "Gagal membaca data login"})
        return
    }

    if creds.Username == "" || creds.Password == "" {
        c.JSON(http.StatusBadRequest, gin.H{"error": "Username dan password harus diisi"})
        return
    }

    var user models.User
    err := uc.DB.QueryRow("SELECT id, username, password, email FROM users WHERE username = ?", creds.Username).Scan(&user.ID, &user.Username, &user.Password, &user.Email)
    if err != nil {
        if err == sql.ErrNoRows {
            c.JSON(http.StatusUnauthorized, gin.H{"error": "Pengguna tidak ditemukan"})
            return
        }
        log.Printf("Error querying user: %v", err)
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Terjadi kesalahan saat mengambil data pengguna"})
        return
    }

    err = bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(creds.Password))
    if err != nil {
        c.JSON(http.StatusUnauthorized, gin.H{"error": "Password salah"})
        return
    }

    c.JSON(http.StatusOK, gin.H{
        "message": "Login berhasil",
        "user_id": user.ID,
        "username": user.Username,
        "email": user.Email,
    })
}

func (uc *UserController) GetAllUsers(c *gin.Context) {
    var users []models.User
    rows, err := uc.DB.Query("SELECT id, username, email FROM users")
    if err != nil {
        log.Printf("Error querying users: %v", err)
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal mengambil data pengguna"})
        return
    }
    defer rows.Close()

    for rows.Next() {
        var user models.User
        if err := rows.Scan(&user.ID, &user.Username, &user.Email); err != nil {
            log.Printf("Error scanning user row: %v", err)
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal memproses data pengguna"})
            return
        }
        users = append(users, user)
    }

    c.JSON(http.StatusOK, gin.H{"users": users})
}