const jwt = require('jsonwebtoken');
const express = require('express');
const app = express();
const key = "testKEY";
const algorithm = 'HS256';
const verifyToken = (req, res, next) => {
    try {
        const token = req.headers.authorization.split(' ')[1];
        const decoded = jwt.verify(token, key);
        console.log(decoded.foo);
        next();
    } catch (err) {
        console.log('Invalid token');
        res.status(401).send('Invalid token');
    }
};

app.post('/token', (req, res) => {
    const token = jwt.sign({data: 'foobar'}, key);
    res.send(token);
});

app.get('/protected', verifyToken, (req, res) => {
    res.sendFile(__dirname + '/data.json');
    console.log('File sent');
});

app.listen(3000, () => {
    console.log('Server started on port 3000');
});