import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get("health")
  async checkHealth(){
    const isDatabaseConnected = await this.appService.isDatabaseConnected()
    if(!isDatabaseConnected)
      throw new Error('Database connection failed')

  }

}

