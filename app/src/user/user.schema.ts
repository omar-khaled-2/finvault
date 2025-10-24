// src/users/schemas/user.schema.ts
import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';

export type UserDocument = HydratedDocument<User>;

@Schema({ timestamps: true })
export class User {
  @Prop({ required: true, trim: true })
  fullName: string;


  @Prop({ required: true, unique: true })
  phone: string;


  @Prop({ default: false })
  isVerified: boolean;

  
}

export const UserSchema = SchemaFactory.createForClass(User);
