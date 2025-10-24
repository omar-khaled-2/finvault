// src/auth/schemas/otp.schema.ts
import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Types } from 'mongoose';

export type OtpDocument = HydratedDocument<Otp>;

@Schema({ timestamps: true })
export class Otp {
  @Prop({ type: Types.ObjectId, ref: 'User', required: true })
  userId: Types.ObjectId;

  @Prop({ required: true })
  hashed_code: string;

  @Prop({ enum: ['auth', 'transfer'], required: true })
  purpose: string;

  @Prop({ required: true })
  expiresAt: Date;

  @Prop({ default: false })
  isUsed: boolean;
}

export const OtpSchema = SchemaFactory.createForClass(Otp);

// TTL index (auto-delete expired docs)
OtpSchema.index({ expiresAt: 1 }, { expireAfterSeconds: 0 });
