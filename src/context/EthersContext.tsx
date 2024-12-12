'use client';

import { Signer, BrowserProvider, Network, ethers, Contract } from 'ethers';
import React, {
    createContext,
    ReactNode,
    useContext,
    useEffect,
    useState,
} from 'react';

interface EthersContextType {
    provider: BrowserProvider | null;
    signer: Signer | null;
    account: string | null;
    network: Network | null;
    balance: string | null;
    connectWallet: () => Promise<void>;
    getContract: () => Contract | null;
}

// For Contract Context
import contractABI from '../abis/MyContract.json';
const contractAddress = '0xD58C47a068994f637EF8c49bdf08f602fC042b6C';

const EthersContext = createContext<EthersContextType | null>(null);

export const EthersProvider: React.FC<{ children: ReactNode }> = ({
    children,
}) => {
    const [provider, setProvider] = useState<BrowserProvider | null>(null);
    const [signer, setSigner] = useState<Signer | null>(null);
    const [account, setAccount] = useState<string | null>(null);
    const [network, setNetwork] = useState<Network | null>(null);
    const [balance, setBalance] = useState<string | null>(null);

    const connectWallet = async () => {
        try {
            const provider = new BrowserProvider(window.ethereum);
            const signer = await provider.getSigner();
            const account = await signer.getAddress();
            const network = await provider.getNetwork();
            const balance = await provider.getBalance(account);
            const balanceReadable = ethers.formatEther(balance);
            setProvider(provider);
            setSigner(signer);
            setAccount(account);
            setNetwork(network);
            setBalance(balanceReadable);
        } catch (error) {
            console.error('Error in connectWallet: ', error);
        }
    };

    const getContract = (): Contract | null => {
        if (!signer) {
            console.error('Signer not found');
            return null;
        }

        try {
            return new Contract(contractAddress, contractABI, signer);
        } catch (error) {
            console.error('Error in getContract: ', error);
            return null;
        }
    };

    useEffect(() => {
        const checkConnection = async () => {
            if (window.ethereum) {
                const ethProvider = new BrowserProvider(window.ethereum);
                const ethSigner = await ethProvider.getSigner();
                const network = await ethProvider.getNetwork();
                const account = await ethSigner.getAddress();
                const balance = await ethProvider.getBalance(account);
                const balanceReadable = ethers.formatEther(balance);

                try {
                    const account = await ethSigner.getAddress();
                    setProvider(ethProvider);
                    setSigner(ethSigner);
                    setAccount(account);
                    setNetwork(network);
                    setBalance(balanceReadable);
                } catch (error) {
                    console.error('Error in connectWallet: ', error);
                }
            } else {
                console.error('Please install MetaMask!');
            }
        };
        checkConnection();
    }, []);
    return (
        <EthersContext.Provider
            value={{
                provider,
                signer,
                account,
                network,
                balance,
                connectWallet,
                getContract,
            }}
        >
            {children}
        </EthersContext.Provider>
    );
};

export const useEthers = (): EthersContextType => {
    const context = useContext(EthersContext);
    if (!context) {
        throw new Error('useEthers must be used within a EthersProvider');
    }
    return context;
};