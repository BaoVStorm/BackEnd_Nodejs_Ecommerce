import mysql from 'mysql2/promise';

// kết nối mysql
// npm install mysql2
const pool = mysql.createPool({
    host: process.env.HOST,
    user: process.env.USER,
    password: process.env.PASSWORD,
    database: process.env.DATABASE,
    waitForConnections: true,
    connectionLimit: process.env.CONNECTION_LIMIT,
    queueLimit: process.env.QUERY_LIMIT
});

export default pool;