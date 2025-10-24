import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModule } from './auth/auth.module';
import { MongooseModule } from '@nestjs/mongoose';
import { UserModule } from './user/user.module';
import { OtpModule } from './otp/otp.module';
import { WalletModule } from './wallet/wallet.module';
import { TransferModule } from './transfer/transfer.module';
import { JwtModule } from '@nestjs/jwt';
import { TransactionModule } from './transaction/transaction.module';
import { ConfigModule } from '@nestjs/config';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal:true
    }),
    JwtModule.register({
      global: true,
      secret: process.env.JWT_SECRET,
      signOptions: { expiresIn: '1h' },
    }),
    MongooseModule.forRoot(process.env.MONGO_URL!,{
      serverSelectionTimeoutMS:5000
    }),
    AuthModule,UserModule, OtpModule,
    WalletModule,
    TransferModule,
    TransactionModule
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}

