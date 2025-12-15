const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();

// ------------------------------------
// MIDDLEWARES
// ------------------------------------
app.use(cors());
app.use(express.json());

// ------------------------------------
// IMPORTAR RUTAS
// ------------------------------------
const authRoutes = require('./routes/auth.routes.js');
const nominaRoutes = require('./routes/nomina.routes.js');
const hipotecaRoutes = require('./routes/hipoteca.routes.js');
const divisasRoutes = require('./routes/divisas.routes.js');

// ------------------------------------
// DEFINICIÓN DE ENDPOINTS
// ------------------------------------

// 1. Usuarios (Login y Registro)
app.use('/auth', authRoutes);

// 2. Nómina (Cálculo Laboral España)
app.use('/api/nomina', nominaRoutes);

// 3. Hipoteca (Cálculo Financiero)
app.use('/api/hipoteca', hipotecaRoutes);

// 4. Divisas (Conversor Moneda)
app.use('/api/divisas', divisasRoutes);


// ------------------------------------
// INICIO DEL SERVIDOR
// ------------------------------------
const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(` API CalcNow completa corriendo en puerto ${PORT}`);
    console.log(`   - Auth:     http://localhost:${PORT}/auth/login`);
    console.log(`   - Nómina:   http://localhost:${PORT}/api/nomina/calcular`);
    console.log(`   - Hipoteca: http://localhost:${PORT}/api/hipoteca/calcular`);
    console.log(`   - Divisas:  http://localhost:${PORT}/api/divisas/convertir`);
});