import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { TransferController } from './transfer.controller';
import { TransferService } from './transfer.service';
import { APP_GUARD } from '@nestjs/core';
import { AuthGuard } from 'src/auth/auth.guard';
import { TransactionModule } from 'src/transaction/transaction.module';
import { UserModule } from 'src/user/user.module';
import { OtpModule } from 'src/otp/otp.module';
import { WalletModule } from 'src/wallet/wallet.module';

@Module({
    imports: [
        TransactionModule,
        UserModule,
        OtpModule,
        WalletModule
    ],
    controllers: [TransferController],
    providers: [ TransferService],
})
export class TransferModule {}
