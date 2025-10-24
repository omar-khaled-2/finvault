import { Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';

import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Otp, OtpDocument } from './otp.schema';
import { UserService } from 'src/user/user.service';
import { CreateOtpDto, VerifyOtpDto } from './dto';
import crypto from "crypto";

import { SNSClient, PublishCommand , PublishCommandInput } from "@aws-sdk/client-sns";


const snsClient = new SNSClient({
  region:"us-east-1"
});

@Injectable()
export class  OtpService {
  constructor(@InjectModel(Otp.name) private otpModel: Model<OtpDocument>,private readonly userService: UserService ) {

  }

  private generateOtp() {
    const max = 10 ** 6;
    const num = crypto.randomInt(0, max);
    return String(num).padStart(6, "0");
  } 

  private hashOtp(otp:string) {
    return crypto.createHmac("sha256", "omar").update(otp).digest("hex");
  }

  private verifyOtp(otp:string, hashed_code:string) {
    const hash = this.hashOtp(otp);
    return crypto.timingSafeEqual(Buffer.from(hash, "hex"), Buffer.from(hashed_code, "hex"));
  }

  async create(createOtpDto:CreateOtpDto):Promise<void> {
    const {userId,purpose} = createOtpDto
    const user = await this.userService.get(userId);
    if(!user)
      throw "User Not found"
    const code = this.generateOtp()
    const hashedCode = this.hashOtp(code)
    const expiresAt = new Date(Date.now() + 1000 * 60 * 10);
    const otp = new this.otpModel({ hashed_code: hashedCode, userId,purpose,expiresAt });

    const publishCommandInput:PublishCommandInput = {
      PhoneNumber:user.phone,
      Message: `Your OTP is: ${code}`,
    }

    const publishCommand = new PublishCommand(publishCommandInput)
    console.log(code)
    await snsClient.send(publishCommand)
    await otp.save()

  }

  async verify(verifyOtpDto:VerifyOtpDto){
    const {userId,code,purpose} = verifyOtpDto
    const otp = await this.otpModel.findOne({ userId, purpose, isUsed: false}).exec();
    if(!otp)
      throw Error("Invalid OTP")

    if(otp.expiresAt < new Date())
      throw Error("OTP Expired")
  
    if(!this.verifyOtp(code, otp.hashed_code))
      throw Error("Invalid OTP")

    otp.isUsed = true;
    await otp.save();


  }


}