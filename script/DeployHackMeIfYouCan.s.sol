// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/HackMeIfYouCan.sol";

contract DeployHackMeIfYouCan is Script {
    function run() external {
        vm.startBroadcast();

        bytes32 password = keccak256(abi.encodePacked("password"));
        bytes32[15] memory data;

        HackMeIfYouCan hackMe = new HackMeIfYouCan(password, data);

        console.log("Contract deployed at:", address(hackMe));

        vm.stopBroadcast();
    }
}
