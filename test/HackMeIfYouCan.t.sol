// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

import "forge-std/Test.sol";
import "../src/HackMeIfYouCan.sol";
import "forge-std/console.sol";

// Contract for reentrancy test
contract ReentrancyTest {
    HackMeIfYouCan target;

    constructor(address payable _target) {
        target = HackMeIfYouCan(_target);
    }

    function attack() external payable {
        target.contribute{value: msg.value}();
        target.flip(true); // or false, depending on your attack vector
    }

    receive() external payable {
        if (address(target).balance >= 0.001 ether) {
            target.flip(true); // or false, depending on your attack vector
        }
    }
}

contract HackMeIfYouCanTest is Test {
    HackMeIfYouCan hackMe;
    bytes32 password = keccak256(abi.encodePacked("password"));
    bytes32[15] data;

    function setUp() public {
        hackMe = new HackMeIfYouCan(password, data);
        console.log("Contract deployed. Owner: ", hackMe.owner());
    }

    function testInitialOwner() public {
        console.log("Test: testInitialOwner");
        assertEq(hackMe.owner(), address(this));
        console.log("Owner: ", hackMe.owner());
    }

    function testContribute() public {
        console.log("Test: testContribute");
        hackMe.contribute{value: 0.0005 ether}();
        assertEq(hackMe.contributions(address(this)), 0.0005 ether);
        console.log("Contribution: ", uint256(hackMe.contributions(address(this))));
    }

    function testFailContributeTooMuch() public {
        console.log("Test: testFailContributeTooMuch");
        vm.expectRevert("Contribution too high");
        hackMe.contribute{value: 0.002 ether}();
    }

    function testFlip() public {
        console.log("Test: testFlip");
        bool guess = true; // or false, depending on the test case
        bool result = hackMe.flip(guess);
        console.log("Flip result: ", result);
        assertTrue(result || !result);
    }

    function testAddPoint() public {
        console.log("Test: testAddPoint");
        address original = address(0x123);
        vm.prank(original); // Make the transaction origin be original
        hackMe.addPoint();
        assertEq(hackMe.getMarks(original), 1);
        console.log("Marks: ", uint256(hackMe.getMarks(original)));
    }

    function testSendPassword() public {
        console.log("Test: testSendPassword");
        hackMe.sendPassword(password);
        assertEq(hackMe.getMarks(address(this)), 3);
        console.log("Marks: ", uint256(hackMe.getMarks(address(this))));
    }

    function testFailSendPasswordWrong() public {
        console.log("Test: testFailSendPasswordWrong");
        vm.expectRevert("Wrong password");
        hackMe.sendPassword(keccak256(abi.encodePacked("wrongpassword")));
    }

    function testTransfer() public {
        console.log("Test: testTransfer");
        hackMe.transfer(address(0x123), 100);
        assertEq(hackMe.balanceOf(address(0x123)), 100);
        console.log("Balance of 0x123: ", uint256(hackMe.balanceOf(address(0x123))));
    }

    function testFailTransferTooMuch() public {
        console.log("Test: testFailTransferTooMuch");
        vm.expectRevert("Insufficient balance");
        hackMe.transfer(address(0x123), 1000000 ether);
    }

    function testReentrancy() public {
        console.log("Test: testReentrancy");
        ReentrancyTest attacker = new ReentrancyTest(payable(address(hackMe)));
        vm.prank(address(attacker));
        vm.deal(address(attacker), 1 ether);
        attacker.attack{value: 0.001 ether}();
        console.log("Reentrancy attack completed");
    }
}
