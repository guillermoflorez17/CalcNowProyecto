const db = require('../database/db');

class NominaModel {

    constructor(brutoAnual, pagas, discapacidad, hijos, edad, grupo) {
        this.salario = brutoAnual;
        this.pagas = pagas || 12;
        this.discapacidad = discapacidad;
        this.hijos = hijos === "Si";
        this.edad = edad;
        this.grupo = grupo;
    }

    _calcularSeguridadSocial() {
        const baseMin = 1260;
        const baseMax = 4720;
        const tipo = 6.35 / 100;
        const salarioMensual = this.salario / 12;
        const base = Math.min(Math.max(salarioMensual, baseMin), baseMax);
        return base * tipo * 12;
    }

    _calcularIRPF(base) {
        return base > 0 ? base * 0.15 : 0;
    }

    obtenerResultados() {
        const ss = this._calcularSeguridadSocial();
        const base = this.salario - ss - 2000;
        const irpf = this._calcularIRPF(base);
        const netoAnual = this.salario - ss - irpf;
        const netoMensual = netoAnual / this.pagas;

        return {
            salario_neto_mensual: netoMensual.toFixed(2),
            salario_neto_anual: netoAnual.toFixed(2),
            seguridad_social: ss.toFixed(2),
            retencion_anual: irpf.toFixed(2)
        };
    }

    static async create(datos) {
        const sql = `
            INSERT INTO calculo_nomina (
                sueldo_bruto_anual,
                pagas_anuales,
                edad,
                ubicacion_fiscal,
                grupo_profesional,
                grado_discapacidad,
                estado_civil,
                hijos,
                cuota_seguridad_social,
                sueldo_neto_mensual,
                id_usuario
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `;

        const params = [
            datos.sueldo_bruto_anual,
            datos.pagas_anuales,
            datos.edad,
            datos.ubicacion_fiscal,
            datos.grupo_profesional,
            datos.grado_discapacidad,
            datos.estado_civil,
            datos.hijos,
            datos.cuota_seguridad_social,
            datos.sueldo_neto_mensual,
            datos.id_usuario
        ];

        const [result] = await db.query(sql, params);
        return result.insertId;
    }

    static async findByUserId(idUsuario) {
        const [rows] = await db.query(
            "SELECT * FROM calculo_nomina WHERE id_usuario = ? ORDER BY id_nomina DESC", [idUsuario]
        );
        return rows;
    }

    static async delete(id) {
        const [result] = await db.query(
            "DELETE FROM calculo_nomina WHERE id_nomina = ?", [id]
        );
        return result.affectedRows;
    }
}

module.exports = NominaModel;