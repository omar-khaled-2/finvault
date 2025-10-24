// src/wallets/schemas/wallet.schema.ts
import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Types } from 'mongoose';

export type WalletDocument = HydratedDocument<Wallet>;

@Schema({ timestamps: true })
export class Wallet {
  @Prop({ type: Types.ObjectId, ref: 'User', required: true })
  userId: Types.ObjectId;

  @Prop({ default: 1000 })
  balance: number;

  @Prop({ default: false })
  isLocked: boolean;

  @Prop()
  lastTransactionAt?: Date;
}

export const WalletSchema = SchemaFactory.createForClass(Wallet);
