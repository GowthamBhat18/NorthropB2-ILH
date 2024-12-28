import { Controller, Get, Param, Post, Body } from '@nestjs/common';
import { EthereumService } from './ethereum.service';
import { dataLength } from 'ethers';

@Controller('ethereum')
export class EthereumController {
    constructor(private readonly ethereumService: EthereumService) { }

    @Post('send-transaction')
    async sendTransaction(
        @Body() body: { from: string, to: string, amount: string, gasPrice: string }
    ): Promise<any> {
        const { from, to, amount, gasPrice } = body;

        // Log the received values (for debugging)
        console.log('Received body:', { from, to, amount, gasPrice });

        try {
            // Pass the private key (from) and other details to the service
            const result = await this.ethereumService.sendTransaction(from, to, amount, gasPrice);
            return {
                status: 'success',
                message: 'Transaction sent successfully',
                hash: result.hash,
            };
        } catch (error) {
            return {
                status: 'error',
                message: error.message,
            };
        }
    }

    @Get('getBalance/:address')
    async getBalance(@Param('address') address: string): Promise<string> {
        return this.ethereumService.getBalance(address);
    }

    @Get('getTransactions/:address')
    async getTransactions(@Param('address') address: string): Promise<any> {
        try {
            const transactions = await this.ethereumService.getTransactions(address);
            return {
                status: 'success',
                data: transactions,
            };
        } catch (error) {
            return {
                status: 'error',
                message: error.message,
            };
        }
    }

    @Get('getGasPrice')
    async getGasPrice():Promise<any>{
        try{
            const gasPrize = await this.ethereumService.getGasPrice();
            return{
                status:'success',
                data:gasPrize,
            }
        }catch(error){
            return {
                status: 'error',
                message: error.message,
            };
        }
    }
}
