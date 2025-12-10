const AuthModel = require('../models/auth.model');

exports.login = async (email, password) => {
    try {
        const user = await AuthModel.findByCredentials(email, password);
        if (user) {
            return { success: true, user: user, message: "Login correcto" };
        } else {
            return { success: false, message: "Credenciales incorrectas" };
        }
    } catch (error) {
        throw error;
    }
};

exports.register = async (email, password) => {
    try {
        const existingUser = await AuthModel.findByCredentials(email, password);
        if (existingUser) return { success: false, message: "El usuario ya existe" };

        const newUser = new AuthModel(email, password);
        if (!newUser.isValid()) return { success: false, message: "Datos inválidos" };

        await AuthModel.create(email, password);
        return { success: true, message: "Usuario creado exitosamente" };
    } catch (error) {
        throw error;
    }
};