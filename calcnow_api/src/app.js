const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();

app.use(cors());
app.use(express.json());

// Rutas existentes
const authRoutes = require('./routes/auth.routes.js');
app.use('/auth', authRoutes);

// Nueva ruta Nómina
const nominaRoutes = require('./routes/nomina.routes.js');
app.use('/api/calcular', nominaRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`🚀 Servidor API funcionando en puerto ${PORT}`);
});