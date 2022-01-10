// SPDX-License-Identifier: MIT

pragma solidity ^0.6.6;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FundMe {
    using SafeMathChainlink for uint256;

    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    address public owner;
    string public merhaba = "kou blockchain kulübüne hoş geldiniz!";

    AggregatorV3Interface public priceFeed;
    uint256 decimals;

    constructor(address _priceFeed, uint256 _decimals) public {
        priceFeed = AggregatorV3Interface(_priceFeed);
        decimals = _decimals;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    /*function fund() public payable {
        uint256 minimumUSD = 50 * 10**18;
        require(
            getConversionRate(msg.value) >= minimumUSD,
            "You need to spend more ETH!"
        );
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }*/

    function fund() public payable {
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    function getVersion() public view returns (uint256) {
        return priceFeed.version();
    }

    function getPrice() public view returns (uint256) {
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        //return uint256(answer * 10000000000);
        uint256 ui_answer = uint256(answer);
        return uint256(ui_answer * (10**(18 - decimals)));
        //return ui_answer;
        //2000_0000000000_00000000
        //2000 is starting price which is 2000 ether
        //10 zero is *10000000000
        //8 zero is decimals
    }

    function getEntranceFee() public view returns (uint256) {
        uint256 minimumUSD = 50 * (10**18);
        uint256 price = getPrice();
        uint256 precision = 10**18;
        return (minimumUSD * precision) / price;
    }

    // 1000000000
    function getConversionRate(uint256 ethAmount)
        public
        view
        returns (uint256)
    {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / (10**18);
        return ethAmountInUsd;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function weiToUSD(uint256 weiAmount) public view returns (uint256) {
        return (weiAmount * getPrice()) / 10**18 / 10**18;
    }

    function withdraw() public payable onlyOwner {
        msg.sender.transfer(address(this).balance);

        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
    }
}
