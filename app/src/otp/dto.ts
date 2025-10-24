import { IsEnum, IsString,Length } from 'class-validator';

export class CreateOtpDto {
  
    @IsEnum(['auth', 'transfer'])
    purpose: string;

    @IsString()
    userId: string;

}


export class VerifyOtpDto {
  
    @IsEnum(['auth', 'transfer'])
    purpose: string;

    @IsString()
    userId: string;

    @IsString()
    @Length(6, 6)
    code: string;

}