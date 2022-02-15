pragma solidity ^0.8.0;
import "https://github.com/open-contracts/protocol/blob/main/solidity_contracts/OpenContractRopsten.sol";

contract ReforestationCommitments is OpenContract {
    uint32 public rainforestKm2In2021 = 3470909;
    uint8 public lastRewardedYear = 21;

    uint256[] public deposits;
    uint256[] public valuesPerKm2PerYear;

    constructor() {
        setOracleHash(this.measureRainforest.selector, 0x084772360c4f8761e7d571283d445a0c51c5fa9a70e205353e73c1c32ec5b9db);
    }

    function deposit(uint256 valuePerKm2PerYear) public payable {
        deposits.push(msg.value);
        valuesPerKm2PerYear.push(valuePerKm2PerYear);
    }

    function measureRainforest(uint256 rainforestKm2, uint8 mo, uint8 yr) public requiresOracle {
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
        PayATwitterAccount(0x0D364e6Cf21da8f77FBE0de4d6D75Df35e048EA7).deposit{value:reward}("govbrazil");
    }
}

interface PayATwitterAccount {
    function deposit(string memory twitterHandle) external payable;
}
