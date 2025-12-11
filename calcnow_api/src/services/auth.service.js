const AuthModel = require('../models/auth.model');

exports.register = async (nombre, email, password) => {
    const existe = await AuthModel.findByEmail(email);
    if (existe) throw new Error("El correo ya está registrado");
    const id = await AuthModel.create({ nombre, email, password });
    return { id, nombre, email };
};

exports.login = async (email, password) => {
    const user = await AuthModel.findByEmail(email);
    if (!user || user.contrasena !== password) throw new Error("Credenciales inválidas");
    const { contrasena, ...datosUsuario } = user; // No devolvemos el pass
    return datosUsuario;
};

exports.obtenerPerfil = async (id) => {
    const user = await AuthModel.findById(id);
    if (!user) throw new Error("Usuario no encontrado");
    const { contrasena, ...datosUsuario } = user;
    return datosUsuario;
};

exports.actualizarPerfil = async (id, datos) => {
    return await AuthModel.update(id, datos);
};

exports.eliminarCuenta = async (id) => {
    return await AuthModel.delete(id);
};