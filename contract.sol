pragma solidity ^0.8.0;
import "https://github.com/open-contracts/protocol/blob/main/solidity_contracts/OpenContractRopsten.sol";

contract ReforestationCommitments is OpenContract {
    uint32 public rainforestKm2In2021 = 3470909;
    uint8 public lastRewardedYear = 21;

    uint256[] public deposits;
    uint256[] public valuesPerKm2PerYear;

    constructor() {
        setOracleHash(this.measureRainforest.selector, 0xc2c67acdd86a8ef691f2af349535d93f7b71dce8264908f2bc0711d01796f6d8);
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
        PayATwitterAccount(0x507D995e5E1aDf0e6B77BD18AC15F8Aa747B6D07).deposit{value:reward}("govbrazil");
    }
}

interface PayATwitterAccount {
    function deposit(string memory twitterHandle) external payable;
}
