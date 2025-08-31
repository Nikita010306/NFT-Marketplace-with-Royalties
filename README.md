# NFT Marketplace with Royalties

## Project Description

The NFT Marketplace with Royalties is a decentralized marketplace smart contract built on Ethereum that enables users to buy and sell NFTs while automatically distributing royalty payments to original creators. This marketplace ensures that artists and creators continue to receive compensation from secondary sales of their digital assets, promoting a sustainable creator economy in the NFT space.

The smart contract acts as an intermediary that facilitates secure NFT transactions, handles payment distribution, and maintains royalty information for each NFT. It supports any ERC-721 compliant NFT collection and provides a transparent, trustless trading environment.

## Project Vision

Our vision is to create a fair and sustainable NFT ecosystem where creators are rewarded for their work throughout the entire lifecycle of their digital assets. By implementing automatic royalty payments and transparent fee structures, we aim to build a marketplace that prioritizes creator welfare while providing a seamless trading experience for collectors and investors.

We envision this platform becoming a cornerstone for digital art commerce, where creativity is valued and creators can build sustainable income streams from their intellectual property.

## Key Features

### Core Functionality
- **NFT Listing**: Sellers can list their NFTs with custom pricing and royalty settings
- **Secure Purchasing**: Buyers can purchase NFTs with automatic payment distribution
- **Royalty Management**: Creators receive automatic royalty payments on secondary sales
- **Fee Transparency**: Clear marketplace fee structure with owner-controlled rates

### Technical Features
- **ERC-721 Compatibility**: Works with any standard NFT collection
- **Reentrancy Protection**: Secure against common smart contract vulnerabilities
- **Access Control**: Role-based permissions for sensitive operations
- **Event Logging**: Comprehensive event emission for transaction tracking
- **Gas Optimization**: Efficient contract design to minimize transaction costs

### Security Features
- **Ownership Verification**: Ensures only NFT owners can list their assets
- **Approval Checks**: Verifies marketplace permissions before transfers
- **Payment Validation**: Prevents underpayment and handles excess refunds
- **State Management**: Proper listing status tracking to prevent double-spending

## Future Scope

### Phase 1 Enhancements
- **Auction Mechanism**: Implement timed auctions with bidding functionality
- **Batch Operations**: Allow users to list/buy multiple NFTs in single transactions
- **Price Discovery**: Add floor price tracking and price history analytics
- **Collection Support**: Enhanced features for entire NFT collections

### Phase 2 Advanced Features
- **Cross-Chain Compatibility**: Expand to multiple blockchain networks
- **Fractional Ownership**: Enable shared ownership of high-value NFTs
- **Rental Marketplace**: Allow NFT holders to rent out their assets
- **Social Features**: User profiles, following system, and community features

### Phase 3 Ecosystem Development
- **Creator Tools**: Integrated minting and metadata management
- **Analytics Dashboard**: Comprehensive trading and performance metrics
- **Mobile Application**: Native mobile app for iOS and Android
- **DeFi Integration**: NFT-backed lending and staking mechanisms

### Long-term Vision
- **AI-Powered Recommendations**: Personalized NFT discovery algorithms
- **Virtual Gallery Integration**: Metaverse display and exhibition features
- **Educational Platform**: Resources for creators and collectors
- **Governance Token**: Community-driven platform governance and decisions

---

## Project Structure

```
NFT-Marketplace-with-Royalties/
├── contracts/
│   └── Project.sol
├── README.md
└── package.json (for development dependencies)
```

## Getting Started

1. Install dependencies:
   ```bash
   npm install @openzeppelin/contracts
   ```

2. Compile the contract using your preferred development environment (Hardhat, Truffle, or Remix)

3. Deploy to your chosen network

4. Interact with the contract using Web3.js, Ethers.js, or through a frontend application

## Contract Functions

### Core Functions
- `listNFT()`: List an NFT for sale with royalty settings
- `buyNFT()`: Purchase a listed NFT with automatic payment distribution
- `updateRoyalty()`: Update royalty information for an NFT

### Utility Functions
- `cancelListing()`: Cancel an active listing
- `getListing()`: Retrieve listing details
- `getRoyaltyInfo()`: Get royalty information for an NFT

## License

MIT License - Feel free to use and modify for your projects.

Contract address :- 0x1440d8fd0adceb9963911c22f4a242b7530faa06

<img width="1920" height="1020" alt="Address _ Core Testnet2 Scan - Google Chrome 30-08-2025 22_51_05" src="https://github.com/user-attachments/assets/c34f222f-acf0-4cd2-a2b9-802cfe86e5bd" />

