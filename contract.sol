pragma solidity ^0.8.0;
import "https://github.com/open-contracts/protocol/blob/main/solidity_contracts/OpenContractRopsten.sol";

contract ReforestationIncentives is OpenContract {

    constructor() {
        setOracle("any", this.measureRainforest.selector);  // for debugging purposes, allow any oracleID
    }

    function deposit() public payable {
    }

    function measureRainforest(bytes32 oracleID, uint256 rainforest_km2, uint8 mo, uint8 yr) public payable 
    checkOracle(oracleID, this.measureRainforest.selector) {
        uint256 reward = 1 * (rainforest_km2 - 0);
        PayATwitterAccount(0xc8bf1115EB097A4c33d865Be7040ffde8D4FDeA5).deposit{value:reward}("govbrazil");
    }

}

interface PayATwitterAccount {
    function deposit(string memory twitterHandle) external payable;
}
