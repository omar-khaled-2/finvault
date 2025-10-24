import { Controller, Get, Request, UseGuards } from "@nestjs/common";
import { WalletService } from "./wallet.service";
import { AuthGuard } from "src/auth/auth.guard";

@Controller("wallet")
export class WalletController {
    constructor(
        private readonly walletService:WalletService
    ) {}

    @UseGuards(AuthGuard)
    @Get("balance")
    async getBalance(@Request() req){
        const userId = req.userId
        const wallet = await this.walletService.get(userId)
        
        return {
            balance: wallet.balance
        }
    }



}