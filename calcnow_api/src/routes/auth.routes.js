const router = require('express').Router();
const controller = require('../controllers/auth.controller');

router.post('/register', controller.register);
router.post('/login', controller.login);
router.get('/:id', controller.getProfile);     // GET
router.put('/:id', controller.updateProfile);  // PUT
router.delete('/:id', controller.deleteAccount); // DELETE

module.exports = router;