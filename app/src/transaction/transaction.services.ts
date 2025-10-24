import { Injectable } from "@nestjs/common";
import { InjectModel } from "@nestjs/mongoose";
import { Transaction, TransactionDocument } from "./transaction.schema";
import { Model, Types } from "mongoose";
import { CreateTransactionDto } from "./dto";

@Injectable()
export class TransactionService {

    constructor(
        @InjectModel(Transaction.name) private readonly transactionModel: Model<TransactionDocument>
    ){}


    async create(createTransactionDto:CreateTransactionDto){
        const transaction = await this.transactionModel.create({
            senderId:createTransactionDto.sender_id,
            receiverId:createTransactionDto.receiver_id,
            amount:createTransactionDto.amount
        });
        return transaction
    }

    async get(id:string):Promise<TransactionDocument>{
        const transaction = await this.transactionModel.findOne({ _id:id }).exec();
        if(!transaction) throw Error("Transaction not found")
        return transaction
    }

    async complete(id:string){
        const transaction = await this.get(id);
        transaction.status = "completed";
        transaction.otpVerified = true;
        await transaction.save();
    }
}