import { ethers } from 'ethers';

class EthersUtil {
  private provider: ethers.JsonRpcProvider;
  private signer: ethers.Wallet;

  constructor(privateKey: string) {
    this.provider = new ethers.JsonRpcProvider('https://sepolia.base.org');

    this.signer = new ethers.Wallet(privateKey, this.provider);
  }

  async getBalance() {
    const balance = await this.provider.getBalance(this.signer.address);
    return ethers.formatEther(balance);
  }

  async callContractMethod(
    contractAddress: string,
    abi: any[],
    methodName: string,
    args: any[],
  ) {
    const contract = new ethers.Contract(contractAddress, abi, this.signer);
    const result = await contract[methodName](...args);
    return result;
  }
}

export default EthersUtil;
