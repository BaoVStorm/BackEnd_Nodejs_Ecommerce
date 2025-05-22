import { createOrder } from "../models/Orders.js";
import { sendOrderConfirmationEmail } from "../utils/sendMail.js";
import pool from "../config/db.js";

export const createOrderController = async (req, res) => {
    try {
        const { user_id, shipping_fee, order_date, delivery_type, payment_method, items } = req.body;

        if (!user_id || !items || items.length === 0) {
            return res.status(400).json({ msg: "Invalid order data" });
        }

        // Tạo đơn hàng
        const orderId = await createOrder(user_id, shipping_fee, order_date, delivery_type, payment_method, items);

        // Lấy email của user
        const [[user]] = await pool.query(`SELECT email FROM users WHERE id = ?`, [user_id]);

        // Tính lại tổng tiền và thêm tên sản phẩm
        let total = 0;
        const detailedItems = [];

        for (const item of items) {
            const [[product]] = await pool.query(`SELECT name, price FROM products WHERE id = ?`, [item.product_id]);
            total += product.price * item.quantity;
            detailedItems.push({
                name: product.name,
                quantity: item.quantity,
                price: product.price
            });
        }

        // Gửi mail xác nhận
        await sendOrderConfirmationEmail(user.email, orderId, detailedItems, total);

        return res.status(201).json({ msg: "Order created successfully", orderId });
    } catch (err) {
        console.error(err);
        return res.status(500).json({ msg: "Server Error" });
    }
};
