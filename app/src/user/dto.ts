import { IsString, IsEmail, Length,IsPhoneNumber, IsPassportNumber } from 'class-validator';

export class CreateUserDto {
  @IsString()
  @Length(2, 100)
  fullName: string;



  @IsPhoneNumber("EG")
  phone: string;
}


export class UserDto{
    constructor(
        public id:string,
        public full_name:string,
        public phone:string,
    ){}
}