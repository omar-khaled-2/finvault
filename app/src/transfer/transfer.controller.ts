import { Body, Controller, Get, Post, Request, UseGuards } from "@nestjs/common";
import { TransferService } from "./transfer.service";
import { AuthGuard } from "src/auth/auth.guard";
import { InitiateTransferDto, VerifyTransferDto } from "./dto";

@Controller("transfer")
@UseGuards(AuthGuard)
export class TransferController {
    constructor(
        private readonly transferService:TransferService
    ) {}


    
    @Post("initiate")
    async initiate(@Request() req,@Body() body:InitiateTransferDto){
        const userId = req.userId
        const transaction = await this.transferService.initiate(userId,body)
        return {
            transaction_id:transaction._id,

        }
    }


    @Post("verify")
    async verify(@Request() req, @Body() body:VerifyTransferDto){
        const userId = req.userId
        await this.transferService.verify(userId, body)
    }
}
