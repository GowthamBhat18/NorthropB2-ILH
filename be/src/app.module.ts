import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { EthereumService } from './ethereum/ethereum.service';
import { EthereumController } from './ethereum/ethereum.controller';

@Module({
  imports: [],
  controllers: [AppController, EthereumController],
  providers: [AppService, EthereumService],
})
export class AppModule {}
