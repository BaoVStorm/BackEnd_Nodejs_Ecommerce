import pool from "../config/db.js";

export async function createOrder(user_id, shipping_fee, order_date, delivery_type, payment_method, items) {
    const conn = await pool.getConnection();
    try {
        await conn.beginTransaction();

        // 1. Tính tổng giá tiền
        let total = 0;
        for (const item of items) {
            const [product] = await conn.query(`SELECT price FROM products WHERE id = ?`, [item.product_id]);
            if (product.length === 0) throw new Error("Product not found");

            item.unit_price = product[0].price;
            total += item.unit_price * item.quantity;
        }

        // 2. Tạo order
        const [orderResult] = await conn.query(
            `INSERT INTO orders (user_id, total_price, shipping_fee, order_date, delivery_type, payment_method) VALUES (?, ?, ?, ?, ?, ?)`,
            [user_id, total, shipping_fee, order_date, delivery_type, payment_method]
        );

        const orderId = orderResult.insertId;

        // 3. Tạo order_items
        for (const item of items) {
            await conn.query(
                `INSERT INTO order_items (order_id, product_id, product_color_id, product_size_id, quantity, price) VALUES (?, ?, ?, ?)`,
                [orderId, item.product_id, item.product_color_id, item.product_size_id, item.quantity, item.unit_price]
            );
        }

        await conn.commit();
        return orderId;
    } catch (err) {
        await conn.rollback();
        throw err;
    } finally {
        conn.release();
    }
}
