import { Module } from '@nestjs/common';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { JwtModule } from '@nestjs/jwt';
import { UserModule } from 'src/user/user.module';
import { OtpModule } from 'src/otp/otp.module';

@Module({
  imports: [

    UserModule,
    OtpModule
  ],
  controllers: [AuthController],
  providers: [AuthService],
})
export class AuthModule {}