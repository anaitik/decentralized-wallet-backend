require("@matterlabs/hardhat-zksync-solc");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  zksolc: {
    version: "1.3.9",
    compilerSource: "binary",
    settings: {
      optimizer: {
        enabled: true,
      },
    },
  },
  networks: {
    zksync_testnet: {
      url: "https://zksync2-testnet.zksync.dev",
      ethNetwork: "goerli",
      chainId: 280,
      // Multi-sig deployment configuration
      deployer: {
        multiSig: true,
        requiredConfirmations: 2,
        signerAddresses: [
          "0x...", // Replace with actual signer address 1
          "0x...", // Replace with actual signer address 2
          "0x..."  // Replace with actual signer address 3
        ]
      }
    }
  },
  // Security monitoring configuration
  security: {
    compilerVersionMonitoring: true,
    advisoryCheckInterval: "daily",
    checksumVerification: true
  }
}