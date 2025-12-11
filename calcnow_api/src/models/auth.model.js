// src/models/auth.model.js
const db = require('../database/db'); // Importamos la conexión creada arriba

class AuthModel {
    
    static async findByEmail(email) {
        // Busca usuario por email
        const [rows] = await db.query('SELECT * FROM usuarios WHERE email = ?', [email]);
        return rows[0];
    }

    static async create({ nombre, email, password }) {
        // Inserta nuevo usuario
        const [result] = await db.query(
            'INSERT INTO usuarios (nombre, email, contrasena) VALUES (?, ?, ?)', 
            [nombre, email, password]
        );
        return result.insertId;
    }

    static async findById(id) {
        const [rows] = await db.query('SELECT * FROM usuarios WHERE id = ?', [id]);
        return rows[0];
    }

    static async update(id, datos) {
        // Ejemplo simplificado (ajustar según tus columnas reales)
        const [result] = await db.query('UPDATE usuarios SET ? WHERE id = ?', [datos, id]);
        return result;
    }

    static async delete(id) {
        const [result] = await db.query('DELETE FROM usuarios WHERE id = ?', [id]);
        return result;
    }
}

module.exports = AuthModel;