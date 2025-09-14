const express = require("express");
const router = express.Router();

router.get("/", (req, res) => {
    res.json({ success: true, data: { resumo: {}, obras: [] }, message: "Dashboard básico" });
});

module.exports = router;
