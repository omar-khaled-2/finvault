import { Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { LoginDto, RegisterDto, VerifyOtpDto } from './dto';
import { InjectModel } from '@nestjs/mongoose';
import { User, UserDocument } from 'src/user/user.schema';
import { Model } from 'mongoose';
import { UserService } from 'src/user/user.service';
import { OtpService } from 'src/otp/otp.service';

@Injectable()
export class AuthService {
  constructor(private readonly jwtService: JwtService,private readonly userService: UserService,private readonly otpService: OtpService) {

  }

  
  async register(registerDto: RegisterDto) {
    
    let user = await this.userService.findOneByPhone(registerDto.phone);
    if(user?.isVerified)
      throw new Error('User already exists');
    
    if(user)
      await this.userService.delete(user._id)


    user = await this.userService.create({
      phone: registerDto.phone,
      fullName: registerDto.full_name
    });
    

    await this.otpService.create({
      userId:user._id.toString(),
      purpose:"auth"
    })

    return {
      user_id:user._id,
      message: `Otp sent to ${user.phone}`
    };
  }

  async login(loginDto: LoginDto) {
    
    const user = await this.userService.findOneByPhone(loginDto.phone)

    if(!user)
      throw new Error('User not found');


    await this.otpService.create({
      userId:user._id.toString(),
      purpose:"auth"
    })


    return {
      user_id:user._id,
      message: `Otp sent to ${user.phone}`
    };
  }

  async verify(verifyOtpDto:VerifyOtpDto){
    const {code,user_id:userId} = verifyOtpDto;
    const user = await this.userService.get(userId)

    if(!user)
      throw new Error('User not found');

    await this.otpService.verify({
      code,
      userId,
      purpose:"auth"
    });

    user.isVerified = true;

    await user.save()


    const payload = { sub: userId };
    return {
      access_token: await this.jwtService.signAsync(payload),
      expires_in: 3600,
    };
  }
}