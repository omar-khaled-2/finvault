// src/transactions/schemas/transaction.schema.ts
import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Types } from 'mongoose';

export type TransactionDocument = HydratedDocument<Transaction>;

@Schema({ timestamps: true })
export class Transaction {

  @Prop({ type: Types.ObjectId, ref: 'User' })
  senderId: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: 'User' })
  receiverId: Types.ObjectId;


  @Prop({ required: true })
  amount: number;


  @Prop({ enum: ['pending' , 'completed', 'failed'], default: 'pending' })
  status: string;


  @Prop({ default: false })
  otpVerified: boolean;
}

export const TransactionSchema = SchemaFactory.createForClass(Transaction);
