// user.dto.ts
import { IsString, IsEmail, Length,IsPhoneNumber, IsPassportNumber, IS_STRING, IsNumberString } from 'class-validator';

export class RegisterDto {
  @IsString()
  @Length(2, 100)
  full_name: string;

  @IsPhoneNumber("EG")
  phone: string;
}

export class LoginDto {
  @IsPhoneNumber("EG")
  phone: string;

}



export class VerifyOtpDto {
  @IsNumberString()
  @Length(6, 6)
  code: string;

  @IsString()
  user_id:string
}
