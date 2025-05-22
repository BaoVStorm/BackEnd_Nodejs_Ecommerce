import pool from '../config/db.js';

export async function getAllCategories() {
    const [rows] = await pool.query('SELECT * FROM categories');

    return rows;
}

// ---------------------- optional

export async function createCategory(category_name) {
    const [result] = await pool.query(
        ' \
        INSERT INTO categories(category_name) \
        VALUES (?) ',
        [category_name]
    );

    return result.insertId;
}