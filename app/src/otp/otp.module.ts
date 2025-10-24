import { Module } from '@nestjs/common';
import { OtpService } from './otp.service';
import { MongooseModule } from '@nestjs/mongoose';
import { Otp, OtpSchema } from './otp.schema';
import { UserModule } from 'src/user/user.module';

@Module({
    imports: [MongooseModule.forFeature([{ name: Otp.name, schema: OtpSchema }]),UserModule],
    controllers:[],
    providers: [OtpService],
    exports: [OtpService],
})
export class OtpModule {}
