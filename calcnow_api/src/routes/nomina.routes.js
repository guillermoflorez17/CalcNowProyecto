const router = require('express').Router();
const controller = require('../controllers/nomina.controller');

router.post('/calcular', controller.calcular);
router.post('/guardar', controller.guardar);
router.get('/historial/:id_usuario', controller.historial);
router.delete('/historial/:id', controller.eliminar);

module.exports = router;