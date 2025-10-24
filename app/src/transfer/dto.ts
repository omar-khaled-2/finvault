import { IsNumberString, IsPhoneNumber, IsPositive, IsString } from "class-validator";

export class InitiateTransferDto{
  @IsPhoneNumber("EG")
  recipient_phone:string


  @IsPositive()
  amount:number
}

export class VerifyTransferDto{
  @IsString()
  transaction_id:string

  @IsNumberString()
  code:string
}