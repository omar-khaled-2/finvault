import { Injectable } from "@nestjs/common";
import { TransactionService } from "src/transaction/transaction.services";
import { InitiateTransferDto, VerifyTransferDto } from "./dto";
import { UserService } from "src/user/user.service";
import { TransactionDocument } from "src/transaction/transaction.schema";
import { OtpService } from "src/otp/otp.service";
import { WalletService } from "src/wallet/wallet.service";

@Injectable()
export class TransferService {
  constructor(
    private readonly transactionService:TransactionService,
    private readonly userService:UserService,
    private readonly otpService:OtpService,
    private readonly walletService:WalletService
  ) {}



  async initiate(userId:string,initiateTransferDto:InitiateTransferDto):Promise<TransactionDocument>{
    const recipient = await this.userService.findOneByPhone(initiateTransferDto.recipient_phone)
    if(!recipient) throw Error("Recipient not found")
    if(userId == recipient._id.toString()) throw Error("You can't transfer to yourself")
    const transaction = await this.transactionService.create({
      sender_id:userId,
      receiver_id:recipient._id.toString(),
      amount:initiateTransferDto.amount
    })
    await this.otpService.create({
      userId,
      purpose:"transfer"
    })
    return transaction
  }

  async verify(userId:string,verifyTransferDto:VerifyTransferDto):Promise<void>{

    const transaction = await this.transactionService.get(verifyTransferDto.transaction_id)
    if(!transaction) throw Error("Transaction not found")

    if(transaction.otpVerified) throw Error("Transaction already verified")
    
    await this.otpService.verify({
      userId,
      code:verifyTransferDto.code,
      purpose:"transfer"
    })

    await this.walletService.transfer(
      transaction.senderId.toString(),
      transaction.receiverId.toString(),
      transaction.amount
    )

    await this.transactionService.complete(verifyTransferDto.transaction_id)
    
  }
}