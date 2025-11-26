const authServices = require('../services/auth.services'); // Importar el nuevo archivo de servicios

// ---------------- LOGIN ----------------
exports.login = async(req, res) => {
    console.log("📥 LLEGA PETICIÓN A /auth/login");
    console.log("📨 BODY:", req.body);

    const { email, password } = req.body;

    try {
        // Llamar al servicio para obtener los datos
        const rows = await authServices.findUserByCredentials(email, password);

        if (rows.length > 0) {
            return res.json({
                success: true,
                message: "Login correcto",
                user: rows[0]
            });
        }

        return res.json({
            success: false,
            message: "Credenciales incorrectas"
        });

    } catch (error) {
        console.error("🔥 ERROR LOGIN:", error);
        // Error de servidor, podría ser de DB, conexión, etc.
        res.status(500).json({
            success: false,
            message: "Error en el servidor"
        });
    }
};

// ---------------- REGISTER ----------------
exports.register = async(req, res) => {
    console.log("📥 LLEGA PETICIÓN A /auth/register");
    console.log("📨 BODY:", req.body);

    const { email, password } = req.body;

    try {
        // Llamar al servicio para crear el usuario
        await authServices.createUser(email, password);

        return res.json({
            success: true,
            message: "Usuario creado correctamente"
        });

    } catch (error) {
        // Este catch podría ser más específico (ej. para errores de duplicados de email en la DB)
        console.error("🔥 ERROR REGISTER:", error);
        return res.status(500).json({
            success: false,
            message: "Error en el servidor"
        });
    }
};