import { Controller, Post, Body, Get, UseGuards, Request } from '@nestjs/common';
import { UserService } from './user.service';
import { AuthGuard } from 'src/auth/auth.guard';
import { UserDto } from './dto';

@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}


    @UseGuards(AuthGuard)
    @Get()
    async get(@Request() req) {
        const user = await this.userService.get(req.userId)
        if(!user)
            throw Error("User not found")
        return new UserDto(user._id.toString(),user.fullName,user.phone)
    }


}