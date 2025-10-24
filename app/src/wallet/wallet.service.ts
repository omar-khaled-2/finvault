import { Injectable } from "@nestjs/common";
import {InjectConnection, InjectModel} from "@nestjs/mongoose"
import { Connection, Model } from "mongoose";
import { Wallet, WalletDocument } from "./wallet.schema";
@Injectable()
export class WalletService{
    constructor(
        @InjectModel(Wallet.name) private walletModel: Model<WalletDocument>,
        @InjectConnection() private readonly connection: Connection
    ){}


    async create(userId:string):Promise<WalletDocument>{
        const wallet = new this.walletModel({ userId });
        await wallet.save();
        return wallet;
    }

    async get(userId:string):Promise<WalletDocument>{
        const wallet = await this.walletModel.findOne({ userId }).exec();
        if(!wallet)
            throw Error("")
        return wallet;
    }

    async transfer(from:string,to:string,amount:number){
        const fromWallet = await this.get(from);
        const toWallet = await this.get(to);
        if(fromWallet.balance < amount)
            throw Error("Insufficient balance")
        fromWallet.balance -= amount;
        toWallet.balance += amount;
        await fromWallet.save();
        await toWallet.save();
    }
}