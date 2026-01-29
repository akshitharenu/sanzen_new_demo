import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as nodemailer from 'nodemailer';

@Injectable()
export class MailService {
  private transporter: nodemailer.Transporter;

  constructor(private configService: ConfigService) {
    this.transporter = nodemailer.createTransport({
      host: this.configService.get<string>('MAIL_HOST') || 'smtp.gmail.com',
      port: this.configService.get<number>('MAIL_PORT') || 587,
      secure: false,
      auth: {
        user: this.configService.get<string>('MAIL_USER'),
        pass: this.configService.get<string>('MAIL_PASSWORD'),
      },
    });
  }

  async sendOtpEmail(to: string, otp: string, firstName: string): Promise<void> {
    const mailOptions = {
      from: `"Sanzen" <noreply@sanzen.ae>`,
      to,
      subject: 'Password Reset - Verification Code',
      html: `
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
        </head>
        <body style="margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f5f5f5;">
          <table role="presentation" style="width: 100%; border-collapse: collapse;">
            <tr>
              <td align="center" style="padding: 40px 0;">
                <table role="presentation" style="width: 600px; border-collapse: collapse; background-color: #ffffff; border-radius: 16px; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);">
                  <!-- Header -->
                  <tr>
                    <td style="padding: 40px 40px 30px; text-align: center; background: linear-gradient(135deg, #1D3724 0%, #0E552B 100%); border-radius: 16px 16px 0 0;">
                      <h1 style="margin: 0; color: #ffffff; font-size: 28px; font-weight: 700; letter-spacing: 4px;">SANZEN</h1>
                    </td>
                  </tr>
                  <!-- Content -->
                  <tr>
                    <td style="padding: 40px;">
                      <h2 style="margin: 0 0 20px; color: #1D3724; font-size: 24px; font-weight: 600;">Password Reset Request</h2>
                      <p style="margin: 0 0 20px; color: #333333; font-size: 16px; line-height: 1.6;">
                        Hello <strong>${firstName}</strong>,
                      </p>
                      <p style="margin: 0 0 30px; color: #666666; font-size: 14px; line-height: 1.6;">
                        We received a request to reset your password. Use the verification code below to complete the process.
                      </p>
                      <!-- OTP Box -->
                      <div style="text-align: center; margin: 30px 0;">
                        <div style="display: inline-block; padding: 20px 40px; background: linear-gradient(135deg, #1D3724 0%, #0E552B 100%); border-radius: 12px;">
                          <span style="font-size: 36px; font-weight: 700; color: #C2A563; letter-spacing: 12px;">${otp}</span>
                        </div>
                      </div>
                      <p style="margin: 30px 0 20px; color: #666666; font-size: 14px; line-height: 1.6; text-align: center;">
                        This code will expire in <strong>10 minutes</strong>.
                      </p>
                      <hr style="border: none; border-top: 1px solid #e0e0e0; margin: 30px 0;">
                      <p style="margin: 0; color: #999999; font-size: 12px; line-height: 1.6;">
                        If you didn't request this password reset, please ignore this email or contact support if you have concerns.
                      </p>
                    </td>
                  </tr>
                  <!-- Footer -->
                  <tr>
                    <td style="padding: 20px 40px; text-align: center; background-color: #f9f9f9; border-radius: 0 0 16px 16px;">
                      <p style="margin: 0; color: #999999; font-size: 12px;">
                        © ${new Date().getFullYear()} Sanzen. All rights reserved.
                      </p>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
          </table>
        </body>
        </html>
      `,
    };

    await this.transporter.sendMail(mailOptions);
  }

  async sendWelcomeEmail(to: string, firstName: string): Promise<void> {
    const mailOptions = {
      from: `"Sanzen" <noreply@sanzen.ae>`,
      to,
      subject: 'Welcome to Sanzen',
      html: `
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
        </head>
        <body style="margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f5f5f5;">
          <table role="presentation" style="width: 100%; border-collapse: collapse;">
            <tr>
              <td align="center" style="padding: 40px 0;">
                <table role="presentation" style="width: 600px; border-collapse: collapse; background-color: #ffffff; border-radius: 16px; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);">
                  <!-- Header -->
                  <tr>
                    <td style="padding: 40px 40px 30px; text-align: center; background: linear-gradient(135deg, #1D3724 0%, #0E552B 100%); border-radius: 16px 16px 0 0;">
                      <h1 style="margin: 0; color: #ffffff; font-size: 28px; font-weight: 700; letter-spacing: 4px;">SANZEN</h1>
                    </td>
                  </tr>
                  <!-- Content -->
                  <tr>
                    <td style="padding: 40px;">
                      <h2 style="margin: 0 0 20px; color: #1D3724; font-size: 24px; font-weight: 600;">Welcome to Sanzen!</h2>
                      <p style="margin: 0 0 20px; color: #333333; font-size: 16px; line-height: 1.6;">
                        Hello <strong>${firstName}</strong>,
                      </p>
                      <p style="margin: 0 0 30px; color: #666666; font-size: 14px; line-height: 1.6;">
                        Thank you for joining Sanzen. We're excited to have you on board!
                      </p>
                      <p style="margin: 0; color: #666666; font-size: 14px; line-height: 1.6;">
                        If you have any questions, feel free to reach out to our support team.
                      </p>
                    </td>
                  </tr>
                  <!-- Footer -->
                  <tr>
                    <td style="padding: 20px 40px; text-align: center; background-color: #f9f9f9; border-radius: 0 0 16px 16px;">
                      <p style="margin: 0; color: #999999; font-size: 12px;">
                        © ${new Date().getFullYear()} Sanzen. All rights reserved.
                      </p>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
          </table>
        </body>
        </html>
      `,
    };

    await this.transporter.sendMail(mailOptions);
  }
}
