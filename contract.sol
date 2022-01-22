pragma solidity ^0.8.0;
import "https://github.com/open-contracts/protocol/blob/main/solidity_contracts/OpenContractRopsten.sol";

contract ReforestationIncentives is OpenContract {
    uint32 public rainforestKm2In2021 = 3470909;
    uint8 public lastRewardedYear = 21;

    uint256[] public deposits;
    uint256[] public valuesPerKm2PerYear;
    

    constructor() {
        setOracle("any", this.measureRainforest.selector);  // for debugging purposes, allow any oracleID
    }

    function deposit(uint256 valuePerKm2PerYear) public payable {
        deposits.push(msg.value);
        valuesPerKm2PerYear.push(valuePerKm2PerYear);
    }

    function measureRainforest(bytes32 oracleID, uint256 rainforestKm2, uint8 mo, uint8 yr) public 
    checkOracle(oracleID, this.measureRainforest.selector) {
        require(mo == 1, "The contract currently rewards rainforest size yearly, every January.");
        require(yr > lastRewardedYear, "The reward for the submitted year was already claimed.");
        lastRewardedYear += 1;
        uint256 reward = 0;
        for (uint32 i=0; i<deposits.length; i++) {
            uint256 valueGenerated = valuesPerKm2PerYear[i] * (rainforestKm2 - rainforestKm2In2021);
            if (valueGenerated > deposits[i]) {
                reward += deposits[i];
                deposits[i] = 0;
            } else {
                reward += valueGenerated;
                deposits[i] -= valueGenerated;
            }
        }
        PayATwitterAccount(0xc8bf1115EB097A4c33d865Be7040ffde8D4FDeA5).deposit{value:reward}("govbrazil");
    }
}

interface PayATwitterAccount {
    function deposit(string memory twitterHandle) external payable;
}
