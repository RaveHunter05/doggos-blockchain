import { PrivyClient } from '@privy-io/server-auth';

class PrivyUtil {
  static PRIVY_APP_ID: string = process.env.PRIVY_APP_ID;
  static PRIVY_APP_SECRET: string = process.env.PRIVY_APP_SECRET;

  constructor() {}

  private privyClient: PrivyClient = new PrivyClient(
    PrivyUtil.PRIVY_APP_ID,
    PrivyUtil.PRIVY_APP_SECRET,
  );

  async createServerWallet() {
    try {
      const wallet = await this.privyClient.walletApi.create({
        chainType: 'ethereum',
      });
      return wallet;
    } catch (error) {
      console.error(error);
      throw new Error('Error creating wallet');
    }
  }

  async serverWalletSendTransaction(
    walletId: string,
    to: string,
    amount: number,
  ): Promise<any> {
    try {
      const { data } = await this.privyClient.walletApi.rpc({
        walletId,
        method: 'eth_sendTransaction',
        caip2: 'eip155:11155111',
        params: {
          transaction: {
            to,
            value: amount,
            chainId: 84532,
          },
        },
      });

      return data;
    } catch (error) {
      console.error(error);
      throw new Error('Error sending transaction');
    }
  }

  async getServerWallets() {
    try {
      const wallets = await this.privyClient.walletApi.getWallets();
      return wallets;
    } catch (error) {
      console.error(error);
      throw new Error('Error getting wallets');
    }
  }
}

export default PrivyUtil;
