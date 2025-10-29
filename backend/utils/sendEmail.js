// Email sending utility (placeholder for future implementation)
const sendEmail = async (options) => {
  // TODO: Implement email sending with nodemailer or similar service
  // For now, just log to console
  console.log('Email would be sent:', {
    to: options.email,
    subject: options.subject,
    message: options.message,
  });

  // In production, implement with nodemailer:
  // const transporter = nodemailer.createTransport({...});
  // await transporter.sendMail({...});
};

module.exports = sendEmail;

