import { Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';

import { InjectModel } from '@nestjs/mongoose';
import { User, UserDocument } from 'src/user/user.schema';
import { Model, Types } from 'mongoose';
import { CreateUserDto } from './dto';
import { WalletService } from 'src/wallet/wallet.service';

@Injectable()
export class  UserService {
  constructor(@InjectModel(User.name) private userModel: Model<UserDocument>,private readonly walletService:WalletService) {

  }

  async get(id:string):Promise<UserDocument | null> {
    const user = await this.userModel.findOne({ _id:id }).exec();
    return user
  }
  async create(createUserDto: CreateUserDto):Promise<UserDocument> {
    const createdUser = new this.userModel(createUserDto);
    await createdUser.save();

    this.walletService.create(createdUser._id.toString())
    return createdUser;
  }

  async findOneByPhone(phone: string): Promise<UserDocument | null> {
    const user = await this.userModel.findOne({ phone }).exec();
    return user 
  }

  async delete(userId:Types.ObjectId){
    await this.userModel.deleteOne({ _id:userId }).exec();
  }
  

}