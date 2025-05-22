import nodemailer from 'nodemailer';

export async function sendOrderConfirmationEmail(toEmail, orderId, items, totalPrice) {
    const transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
            user: process.env.MAIL_USER,
            pass: process.env.MAIL_PASS
        }
    });

    // Nội dung email
    let itemListHTML = items.map(item => 
        `<li>${item.name} - ${item.quantity} x ${item.unit_price}đ</li>`
    ).join('');

    const mailOptions = {
        from: `"E-Commerce Shop" <${process.env.MAIL_USER}>`,
        to: toEmail,
        subject: `Order Confirmation #${orderId}`,
        html: `
            <h3>Thank you for your order!</h3>
            <p>Your order ID is: <strong>#${orderId}</strong></p>
            <p>Order details:</p>
            <ul>${itemListHTML}</ul>
            <p><strong>Total: ${totalPrice}đ</strong></p>
        `
    };

    // Gửi mail
    await transporter.sendMail(mailOptions);
}
