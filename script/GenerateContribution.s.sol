// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/HackMeIfYouCan.sol";

contract GenerateContribution is Script {
    function run() external {
        address payable contractAddress = payable(0x05492eA87Ee275De19B19f8229C65079Dfa07903);
        address myWallet = 0x351024A4EC50612C8D1CF70cd508F77f37Da53F8;

        vm.startBroadcast(myWallet);

        HackMeIfYouCan hackMe = HackMeIfYouCan(contractAddress);

        // Contribuir al contrato
        hackMe.contribute{value: 0.0005 ether}();

        // Verifica la contribución
        uint256 contributions = hackMe.getContribution();
        console.log("Contributions for my wallet: ", contributions);

        vm.stopBroadcast();
    }
}
