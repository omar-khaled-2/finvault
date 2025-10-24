import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { Mongoose } from 'mongoose';
import { Wallet, WalletSchema } from './wallet.schema';
import { WalletService } from './wallet.service';
import { WalletController } from './wallet.controller';
import { JwtModule } from '@nestjs/jwt';

@Module({
    imports:[
        MongooseModule.forFeature([
            {
                name: Wallet.name,
                schema: WalletSchema   
            }
        ]),
    ],
    providers: [WalletService],
    controllers: [WalletController],
    exports: [WalletService]
})
export class WalletModule {}
