// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

contract UniversalRewardToken is ERC20, Ownable {
    mapping(address => bool) public authorizedSellers;
    mapping(address => uint256) public sellerSales; // Seller's monthly sales (Si)
    mapping(address => mapping(address => uint256)) public customerFrequency; // Customer's transaction frequency at seller (Fi)
    uint256 public totalTransactionVolume; // Total transaction volume across all sellers (T)
    uint256 public K = 1; // Scaling constant

    event PointsNormalized(address indexed seller, address indexed customer, uint256 points, uint256 tokensIssued);
    event PointsRedeemed(address indexed customer, uint256 amount);

    constructor() ERC20("Universal Reward Token", "URT") Ownable(msg.sender) {
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }

    modifier onlyAuthorizedSeller() {
        require(authorizedSellers[msg.sender], "Not an authorized seller");
        _;
    }

    function authorizeSeller(address seller) external onlyOwner {
        authorizedSellers[seller] = true;
    }

    function revokeSeller(address seller) external onlyOwner {
        authorizedSellers[seller] = false;
    }

    function setSellerSales(address seller, uint256 sales) external onlyOwner {
        totalTransactionVolume -= sellerSales[seller];
        sellerSales[seller] = sales;
        totalTransactionVolume += sales;
    }

    function setCustomerFrequency(address seller, address customer, uint256 frequency) external onlyOwner {
        customerFrequency[seller][customer] = frequency;
    }

    function setK(uint256 newK) external onlyOwner {
        K = newK;
    }

    function normalizePoints(address customer, uint256 Pi) external onlyAuthorizedSeller {
        address seller = msg.sender;
        uint256 Fi = customerFrequency[seller][customer];
        uint256 Si = sellerSales[seller];
        require(Si > 0, "Seller sales must be greater than zero");
        require(totalTransactionVolume > 0, "Total transaction volume must be greater than zero");
        require(Fi > 0, "Customer frequency must be greater than zero");

        uint256 numerator = Pi * Fi * K;
        uint256 denominator = Si * totalTransactionVolume;

        uint256 tokens = numerator / denominator;
        require(tokens > 0, "Token amount must be greater than zero");

        _mint(customer, tokens);
        emit PointsNormalized(seller, customer, Pi, tokens);
    }

    function redeemPoints(uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        _burn(msg.sender, amount);
        emit PointsRedeemed(msg.sender, amount);
    }
}
