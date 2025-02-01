const bcrypt = require('bcrypt');
const saltRounds = 10;
const encrypt = (input) => {
    return new Promise((resolve, reject) => {
        bcrypt.hash(input, saltRounds, (err, hash) => {
            if (err) {
                reject(err);
            }
            resolve(hash);
        });
    });
};

module.exports = encrypt;