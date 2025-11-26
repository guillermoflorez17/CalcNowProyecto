const db = require('../database/db'); // Asumiendo que 'database' está al mismo nivel que 'services'

/**
 * Busca un usuario por email y contraseña para el login.
 * @param {string} email
 * @param {string} password
 * @returns {Array} Los resultados de la consulta a la base de datos.
 */
exports.findUserByCredentials = async(email, password) => {
    const [rows] = await db.query(
        "SELECT * FROM usuario WHERE correo_electronico = ? AND contrasena = ?", [email, password]
    );
    return rows;
};

/**
 * Inserta un nuevo usuario en la base de datos.
 * @param {string} email
 * @param {string} password
 * @returns {object} El resultado de la operación INSERT.
 */
exports.createUser = async(email, password) => {
    const [result] = await db.query(
        "INSERT INTO usuario (correo_electronico, contrasena) VALUES (?, ?)", [email, password]
    );
    return result;
};