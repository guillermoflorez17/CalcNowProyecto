// src/controllers/auth.controller.js
const authService = require('../services/auth.service');

exports.register = async (req, res) => {
    try {
        const { nombre, email, password } = req.body;
        // Llama al servicio de registro
        const nuevoUsuario = await authService.register(nombre, email, password);
        res.status(201).json({
            success: true,
            message: "Usuario registrado correctamente",
            data: nuevoUsuario
        });
    } catch (error) {
        res.status(400).json({ success: false, error: error.message });
    }
};

exports.login = async (req, res) => {
    try {
        const { email, password } = req.body;
        // Llama al servicio de login
        const datos = await authService.login(email, password);
        res.status(200).json({
            success: true,
            message: "Inicio de sesión exitoso",
            data: datos
        });
    } catch (error) {
        // Maneja errores como credenciales inválidas
        res.status(401).json({ success: false, error: error.message });
    }
};

exports.getProfile = async (req, res) => {
    try {
        const { id } = req.params;
        const perfil = await authService.obtenerPerfil(id);
        res.status(200).json({ success: true, data: perfil });
    } catch (error) {
        res.status(404).json({ success: false, error: error.message });
    }
};

exports.updateProfile = async (req, res) => {
    try {
        const { id } = req.params;
        const datos = req.body;
        const resultado = await authService.actualizarPerfil(id, datos);
        res.status(200).json({ success: true, resultado });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

exports.deleteAccount = async (req, res) => {
    try {
        const { id } = req.params;
        const resultado = await authService.eliminarCuenta(id);
        res.status(200).json({ success: true, resultado });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};