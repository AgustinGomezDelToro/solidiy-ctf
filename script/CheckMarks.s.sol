// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/HackMeIfYouCan.sol";

contract CheckMarks is Script {
    function run() external {

        address payable contractAddress = payable(0x05492eA87Ee275De19B19f8229C65079Dfa07903);
        address myWallet = 0x351024A4EC50612C8D1CF70cd508F77f37Da53F8;


        HackMeIfYouCan hackMe = HackMeIfYouCan(contractAddress);


        uint256 marks = hackMe.getMarks(myWallet);
        uint256 contributions = hackMe.getContribution();
        uint256 consecutiveWins = hackMe.getConsecutiveWins(myWallet);

        console.log("Marks for my wallet: ", marks);
        console.log("Contributions for my wallet: ", contributions);
        console.log("Consecutive wins for my wallet: ", consecutiveWins);
    }
}
