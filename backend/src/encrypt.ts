import * as bcrypt from 'bcrypt';
import * as crypto from 'crypto';

async function encryptString(plainText: string): Promise<string> {
    const saltRounds = 10;
    const fixedSalt = 'urs_very_cool_salt';
    const hash = crypto.createHash('sha256').update(plainText).digest('hex');
    const salt = bcrypt.genSaltSync(saltRounds);
    const encryptedString = await bcrypt.hash(hash, salt);
    return encryptedString;
}

export default encryptString;
