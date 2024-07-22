// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

import "forge-std/Script.sol";
import "../src/HackMeIfYouCan.sol";

contract GenerateMarks is Script {
    function run() external {
        // Reemplaza esta dirección con tu dirección
        address myWallet = 0x351024A4EC50612C8D1CF70cd508F77f37Da53F8;

        // Dirección del contrato desplegado
        address payable hackMeContractAddress = payable(0x7CcBcd07b1187A430EDaB0c17C8b7BA00458A03a);

        // Inicializa el contrato
        HackMeIfYouCan hackMe = HackMeIfYouCan(hackMeContractAddress);

        // Comienza la transmisión de las transacciones
        vm.startBroadcast();

        // Interactúa con el contrato para generar marks
        hackMe.contribute{value: 0.0005 ether}();

        // Asegúrate de ajustar los parámetros de las funciones según sea necesario
        hackMe.flip(true); // or false, depending on your guess
        hackMe.addPoint();
        hackMe.sendPassword(keccak256(abi.encodePacked("password")));

        // Omitimos la llamada a sendKey por ahora
        // hackMe.sendKey(bytes16("0x1234")); // Ajusta según sea necesario

        // Finaliza la transmisión de las transacciones
        vm.stopBroadcast();

        // Verifica los marks
        uint256 marks = hackMe.getMarks(myWallet);
        console.log("Marks for my wallet: ", marks);
    }
}
