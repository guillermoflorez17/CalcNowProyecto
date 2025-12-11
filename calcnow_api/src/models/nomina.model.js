const db = require('../database/db'); // Ajusta la ruta a tu db.js

class NominaModel {
    constructor(brutoAnual, pagas, discapacidad, hijos, edad, grupo) {
        this.salario = parseFloat(brutoAnual);
        this.pagas = parseInt(pagas) || 12;
        this.discapacidad = discapacidad;
        this.hijos = hijos === "Si";
        this.edad = parseInt(edad);
        this.grupo = grupo;
    }

    // --- LÓGICA DE DOMINIO (Cálculos) ---
    _calcularSeguridadSocial() {
        const baseMin = 1260; 
        const baseMax = 4720;
        const tipoTotal = 6.35 / 100; // Suma de contingencias
        const salarioMensual = this.salario / 12;
        const baseCotMensual = Math.min(Math.max(salarioMensual, baseMin), baseMax);
        return baseCotMensual * tipoTotal * 12;
    }

    _calcularIRPF(baseImponible) {
        // Lógica simplificada o tu lógica completa de tramos
        return baseImponible > 0 ? baseImponible * 0.15 : 0; 
    }

    obtenerResultados() {
        const seguridadSocial = this._calcularSeguridadSocial();
        const baseImponible = this.salario - seguridadSocial - 2000;
        const irpf = this._calcularIRPF(baseImponible);
        const netoAnual = this.salario - seguridadSocial - irpf;
        const netoMensual = netoAnual / this.pagas;

        return {
            salario_bruto_anual: this.salario.toFixed(2),
            salario_neto_anual: netoAnual.toFixed(2),
            salario_neto_mensual: netoMensual.toFixed(2),
            seguridad_social: seguridadSocial.toFixed(2),
            retencion_anual: irpf.toFixed(2),
            pagas: this.pagas
        };
    }

    // --- ACCESO A DATOS (SQL) ---
    // Mover aquí lo que tenías en el Service
    static async create({ id_usuario, bruto, pagas, edad, grupo, discapacidad, hijos, ss, neto }) {
        const query = `
            INSERT INTO CALCULO_NOMINA 
            (sueldo_bruto_anual, pagas_anuales, edad, grupo_profesional, grado_discapacidad, hijos, cuota_seguridad_social, sueldo_neto_mensual, id_usuario)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        `;
        const params = [bruto, pagas, edad, grupo, discapacidad, hijos, ss, neto, id_usuario];
        const [result] = await db.query(query, params);
        return result.insertId;
    }

    static async findByUserId(idUsuario) {
        const query = "SELECT * FROM CALCULO_NOMINA WHERE id_usuario = ? ORDER BY id_nomina DESC";
        const [rows] = await db.query(query, [idUsuario]);
        return rows;
    }

    static async delete(idNomina) {
        const query = "DELETE FROM CALCULO_NOMINA WHERE id_nomina = ?";
        const [result] = await db.query(query, [idNomina]);
        return result.affectedRows;
    }
}

module.exports = NominaModel;