import { Injectable } from '@nestjs/common';
import { ethers } from 'ethers';
import * as API_KEY from 'secret.json';
import axios from 'axios';


@Injectable()
export class EthereumService {
    private provider: ethers.JsonRpcProvider;
    private wallet: ethers.Wallet;
    private etherscanApiKey = API_KEY.etherscan_api_key;
    private etherscanApiUrl = 'https://api-sepolia.etherscan.io/api';
    private etherscanApiUrl1='https://api.etherscan.io/api';

    constructor() {
        const apikey = API_KEY;

        this.provider = new ethers.JsonRpcProvider(`https://sepolia.infura.io/v3/${apikey.metamask_api_key}`);
    }

    // Accept publicKey, amount, gasPrice as parameters
    async sendTransaction(
        privateKey: string,// Accept the private key to create the wallet
        publicKey: string,
        amount: string,
        gasPrice: string
    ) {
        // Create a wallet instance using the provided private key
        this.wallet = new ethers.Wallet(privateKey, this.provider);

        // Create a transaction object
        const tx = {
            to: publicKey,  // Public key passed from the controller
            value: ethers.parseEther(amount),  // Convert amount to wei
            gasLimit: 21000,  // Gas limit for a simple transfer
            gasPrice: ethers.parseUnits(gasPrice, 'gwei'),  // Gas price (in gwei)
            nonce: await this.provider.getTransactionCount(this.wallet.address),  // Get nonce
            chainId: 11155111,  // Arbitrum Sepolia chain ID
        };

        try {
            // Sign and send the transaction
            const signedTx = await this.wallet.sendTransaction(tx);
            console.log('Signed Transaction:', signedTx);
            console.log('Transaction Mined!');
            return signedTx;  // Return the signed transaction
        } catch (error) {
            console.error('Error sending transaction:', error);
            throw new Error('Error sending transaction');
        }
    }

    async getBalance(address: string): Promise<string> {
        try {
            const balance = await this.provider.getBalance(address);
            return ethers.formatEther(balance);
        } catch (error) {
            console.error('Error getting balance:', error);
            throw new Error('Error getting balance');
        } 
    }

    async getTransactions(address: string, startBlock: number = 0, endBlock: number = 99999999): Promise<any> {
        try {
            const response = await axios.get(this.etherscanApiUrl, {
                params: {
                    module: 'account',
                    action: 'txlist',  // Get list of transactions
                    address: address,  // Ethereum address to get transactions for
                    startblock: startBlock,  // Starting block (optional, default is 0)
                    endblock: endBlock,  // Ending block (optional, default is latest block)
                    sort: 'desc',  // Sort by descending order (latest transactions first)
                    apiKey: this.etherscanApiKey,  
                },
            });

            if (response.data.status === '1') {
                return response.data.result;  // Return the list of transactions
            } else {
                throw new Error(response.data.message || 'Error fetching transactions');
            }
        } catch (error) {
            console.error('Error fetching transactions:', error);
            throw new Error('Unable to fetch transactions from Etherscan');
        }
    }


    async getGasPrice(): Promise<any> {
        try {
            const response = await axios.get(this.etherscanApiUrl1, {
                params: {
                    module: 'gastracker',
                    action: 'gasoracle',  
                    apiKey: this.etherscanApiKey,  // Your Etherscan API key
                }
            });
            console.log(response.data);

            if (response.data.status === '1') {
                // Extracting gas prices from t response
                const gasPrice = {
                    low: response.data.result.SafeGasPrice,  // Low gas price (in Gwei)
                    standard: response.data.result.ProposeGasPrice,  // Standard gas price (in Gwei)
                    high: response.data.result.FastGasPrice,  // High gas price (in Gwei)
                };
    
                return gasPrice;  // Return the gas price details
            } else {
                throw new Error(response.data.message || 'Error fetching gas price');
            }
        } catch (error) {
            console.error('Error fetching gas price:', error);
            throw new Error('Unable to fetch gas price from Etherscan');
        }
    }
    
}
