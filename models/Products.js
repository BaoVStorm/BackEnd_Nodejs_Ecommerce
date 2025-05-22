import pool from '../config/db.js'

export async function getProductsByCategory(category_id) {
    const [products] = await pool.query(
                            'SELECT * FROM products WHERE category_id = ?',
                            [category_id]);

    return products;
}

export async function searchProducts(filters) {
    const { keyword, minPrice, maxPrice, brand, category_id } = filters;

    let sql = `SELECT * FROM products WHERE 1=1`;
    const params = [];

    // Full-text search
    if (keyword) {
        sql += ` AND MATCH(name, description) AGAINST(? IN NATURAL LANGUAGE MODE)`;
        params.push(keyword);
    }

    if (minPrice) {
        sql += ` AND price >= ?`;
        params.push(minPrice);
    }

    if (maxPrice) {
        sql += ` AND price <= ?`;
        params.push(maxPrice);
    }

    if (brand) {
        sql += ` AND brand = ?`;
        params.push(brand);
    }

    if (category_id) {
        sql += ` AND category_id = ?`;
        params.push(category_id);
    }

    const [rows] = await pool.query(sql, params);
    return rows;
}
