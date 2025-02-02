var admin = require("../utils/firebase");

module.exports = function (req, res, next) {
    var authHeader = req.headers.authorization;
    
    console.log("authHeader: ", authHeader);

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        res.status(401).json({ error: "Unauthorized: No Token provided" });
        return;
    }

    var authToken = authHeader.split(" ")[1];

    admin.auth().verifyIdToken(authToken)
        .then(function (decodedToken) {
            req.user = decodedToken;
            next();
        })
        .catch(function (err) {
            res.status(401).json({ error: "Unauthorized: Invalid Token" });
        });
};
