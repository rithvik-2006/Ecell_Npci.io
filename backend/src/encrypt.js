const bcrypt = require('bcrypt');
const crypto = require('crypto');

async function encryptString(plainText) {
    const saltRounds = 10;
    const hash = crypto.createHash('sha256').update(plainText).digest('hex');
    const encryptedString = await bcrypt.hash(hash, saltRounds);
    return encryptedString;
}

module.exports = encryptString;