# HackMeIfYouCan

## Tests Réussis

### \`testInitialOwner()\`

- **Description:** Vérifie que le propriétaire initial du contrat est celui qui déploie le contrat.
- **Résultat:** PASSED


### \`testContribute()\`

- **Description:** Vérifie que les utilisateurs peuvent contribuer avec un montant inférieur à 0.001 ether.
- **Résultat:** PASSED


### \`testFlip()\`

- **Description:** Vérifie le fonctionnement du jeu de pile ou face.
- **Résultat:** PASSED


### \`testSendPassword()\`

- **Description:** Vérifie que la fonction \`sendPassword\` ajoute des marques si le mot de passe est correct.
- **Résultat:** PASSED


EOL


## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```


### Deploy

```shell
forge script script/DeployHackMeIfYouCan.s.sol:DeployHackMeIfYouCan --rpc-url https://sepolia.infura.io/v3/<tonaddresalinfura>
 --private-key <taprivatekey> 
 ```

address: 0x351024A4EC50612C8D1CF70cd508F77f37Da53F8