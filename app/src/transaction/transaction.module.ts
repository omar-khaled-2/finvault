import { Module } from '@nestjs/common';
import { TransactionService } from './transaction.services';
import { MongooseModule } from '@nestjs/mongoose';
import { Transaction, TransactionSchema } from './transaction.schema';

@Module({
    imports: [
        MongooseModule.forFeature([
            {
                name:Transaction.name,
                schema:TransactionSchema
            }
        ])
    ],
    controllers: [],
    providers: [TransactionService],
    exports: [TransactionService],
})
export class TransactionModule {}
