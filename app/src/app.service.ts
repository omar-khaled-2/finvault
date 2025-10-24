import { Injectable } from '@nestjs/common';
import { InjectConnection } from '@nestjs/mongoose';
import { Connection } from 'mongoose';

@Injectable()
export class AppService {
  constructor(@InjectConnection() private connection: Connection) {}

  getHello(): string {
    return 'Hello World!';
  }

  async isDatabaseConnected(): Promise<boolean> {
    try {
      const isConnected = this.connection.readyState === 1;
      if (isConnected) {
        await this.connection.db?.admin().ping();
      }
      return isConnected;
    } catch (error) {
      return false;
    }
  }
}
