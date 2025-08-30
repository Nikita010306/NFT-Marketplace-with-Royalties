// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title NFT Marketplace with Royalties
 * @dev A marketplace contract that enables buying/selling NFTs with automatic royalty payments
 */
contract Project is ReentrancyGuard, Ownable {
    
    // Marketplace fee percentage (in basis points, e.g., 250 = 2.5%)
    uint256 public marketplaceFee = 250;
    
    // Struct to store listing information
    struct Listing {
        address seller;
        address nftContract;
        uint256 tokenId;
        uint256 price;
        bool active;
    }
    
    // Struct to store royalty information
    struct RoyaltyInfo {
        address creator;
        uint256 royaltyPercentage; // in basis points (e.g., 1000 = 10%)
    }
    
    // Mapping from listing ID to listing details
    mapping(uint256 => Listing) public listings;
    
    // Mapping from NFT contract and token ID to royalty info
    mapping(address => mapping(uint256 => RoyaltyInfo)) public royalties;
    
    // Counter for listing IDs
    uint256 public listingCounter;
    
    // Events
    event NFTListed(
        uint256 indexed listingId,
        address indexed seller,
        address indexed nftContract,
        uint256 tokenId,
        uint256 price
    );
    
    event NFTSold(
        uint256 indexed listingId,
        address indexed buyer,
        address indexed seller,
        uint256 price,
        uint256 royaltyPaid,
        uint256 marketplaceFeePaid
    );
    
    event RoyaltySet(
        address indexed nftContract,
        uint256 indexed tokenId,
        address indexed creator,
        uint256 royaltyPercentage
    );
    
    constructor() Ownable(msg.sender) ReentrancyGuard() {}
    
    /**
     * @dev Core Function 1: List an NFT for sale
     * @param _nftContract Address of the NFT contract
     * @param _tokenId Token ID of the NFT
     * @param _price Sale price in wei
     * @param _royaltyPercentage Royalty percentage for the creator (in basis points)
     */
    function listNFT(
        address _nftContract,
        uint256 _tokenId,
        uint256 _price,
        uint256 _royaltyPercentage
    ) external {
        require(_price > 0, "Price must be greater than 0");
        require(_royaltyPercentage <= 1000, "Royalty cannot exceed 10%");
        
        IERC721 nft = IERC721(_nftContract);
        require(nft.ownerOf(_tokenId) == msg.sender, "You don't own this NFT");
        require(
            nft.isApprovedForAll(msg.sender, address(this)) || 
            nft.getApproved(_tokenId) == address(this),
            "Marketplace not approved to transfer NFT"
        );
        
        listingCounter++;
        
        listings[listingCounter] = Listing({
            seller: msg.sender,
            nftContract: _nftContract,
            tokenId: _tokenId,
            price: _price,
            active: true
        });
        
        // Set royalty info if not already set
        if (royalties[_nftContract][_tokenId].creator == address(0)) {
            royalties[_nftContract][_tokenId] = RoyaltyInfo({
                creator: msg.sender,
                royaltyPercentage: _royaltyPercentage
            });
            
            emit RoyaltySet(_nftContract, _tokenId, msg.sender, _royaltyPercentage);
        }
        
        emit NFTListed(listingCounter, msg.sender, _nftContract, _tokenId, _price);
    }
    
    /**
     * @dev Core Function 2: Buy an NFT from the marketplace
     * @param _listingId ID of the listing to purchase
     */
    function buyNFT(uint256 _listingId) external payable nonReentrant {
        Listing storage listing = listings[_listingId];
        require(listing.active, "Listing is not active");
        require(msg.value >= listing.price, "Insufficient payment");
        
        IERC721 nft = IERC721(listing.nftContract);
        require(nft.ownerOf(listing.tokenId) == listing.seller, "NFT no longer owned by seller");
        
        // Calculate fees and payments
        uint256 totalPrice = listing.price;
        uint256 marketplaceFeeAmount = (totalPrice * marketplaceFee) / 10000;
        
        RoyaltyInfo memory royaltyInfo = royalties[listing.nftContract][listing.tokenId];
        uint256 royaltyAmount = 0;
        
        // Calculate royalty if creator is different from seller
        if (royaltyInfo.creator != address(0) && royaltyInfo.creator != listing.seller) {
            royaltyAmount = (totalPrice * royaltyInfo.royaltyPercentage) / 10000;
        }
        
        uint256 sellerAmount = totalPrice - marketplaceFeeAmount - royaltyAmount;
        
        // Mark listing as inactive
        listing.active = false;
        
        // Transfer NFT to buyer
        nft.safeTransferFrom(listing.seller, msg.sender, listing.tokenId);
        
        // Transfer payments
        if (royaltyAmount > 0) {
            payable(royaltyInfo.creator).transfer(royaltyAmount);
        }
        
        payable(listing.seller).transfer(sellerAmount);
        payable(owner()).transfer(marketplaceFeeAmount);
        
        // Refund excess payment
        if (msg.value > totalPrice) {
            payable(msg.sender).transfer(msg.value - totalPrice);
        }
        
        emit NFTSold(_listingId, msg.sender, listing.seller, totalPrice, royaltyAmount, marketplaceFeeAmount);
    }
    
    /**
     * @dev Core Function 3: Update royalty information for an NFT
     * @param _nftContract Address of the NFT contract
     * @param _tokenId Token ID of the NFT
     * @param _newCreator New creator address
     * @param _newRoyaltyPercentage New royalty percentage (in basis points)
     */
    function updateRoyalty(
        address _nftContract,
        uint256 _tokenId,
        address _newCreator,
        uint256 _newRoyaltyPercentage
    ) external {
        require(_newRoyaltyPercentage <= 1000, "Royalty cannot exceed 10%");
        
        RoyaltyInfo storage royaltyInfo = royalties[_nftContract][_tokenId];
        
        // Only current creator or NFT owner can update royalty
        IERC721 nft = IERC721(_nftContract);
        require(
            msg.sender == royaltyInfo.creator || msg.sender == nft.ownerOf(_tokenId),
            "Not authorized to update royalty"
        );
        
        royaltyInfo.creator = _newCreator;
        royaltyInfo.royaltyPercentage = _newRoyaltyPercentage;
        
        emit RoyaltySet(_nftContract, _tokenId, _newCreator, _newRoyaltyPercentage);
    }
    
    // Additional utility functions
    
    /**
     * @dev Cancel a listing
     * @param _listingId ID of the listing to cancel
     */
    function cancelListing(uint256 _listingId) external {
        Listing storage listing = listings[_listingId];
        require(listing.seller == msg.sender, "Only seller can cancel listing");
        require(listing.active, "Listing is not active");
        
        listing.active = false;
    }
    
    /**
     * @dev Get listing details
     * @param _listingId ID of the listing
     */
    function getListing(uint256 _listingId) external view returns (Listing memory) {
        return listings[_listingId];
    }
    
    /**
     * @dev Get royalty information for an NFT
     * @param _nftContract Address of the NFT contract
     * @param _tokenId Token ID of the NFT
     */
    function getRoyaltyInfo(address _nftContract, uint256 _tokenId) 
        external 
        view 
        returns (RoyaltyInfo memory) 
    {
        return royalties[_nftContract][_tokenId];
    }
    
    /**
     * @dev Update marketplace fee (only owner)
     * @param _newFee New marketplace fee in basis points
     */
    function updateMarketplaceFee(uint256 _newFee) external onlyOwner {
        require(_newFee <= 1000, "Fee cannot exceed 10%");
        marketplaceFee = _newFee;
    }
    
    /**
     * @dev Withdraw marketplace fees (only owner)
     */
    function withdrawFees() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No fees to withdraw");
        payable(owner()).transfer(balance);
    }
}
