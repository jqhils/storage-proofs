// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {console} from "forge-std/console.sol";
import "forge-std/Test.sol";
import "../src/StateProofVerifier.sol";

contract StateProofVerifierTest is Test {
    StateProofVerifier public verifier;

    function setUp() public {
        verifier = new StateProofVerifier();
    }

    function testVerifyAccountState() public view {
        // Block height 17000000
        bytes32 stateRoot = 0x72eea852168e4156811869d6e40789083891288161d5a110259cf4fc922b1a09;
        address account = 0x0000000000000000000000000000000000000000;

        // curl https://eth-mainnet.g.alchemy.com/v2/<API_KEY> \
        // -X POST \
        // -H "Content-Type: application/json" \
        // -d '{"id": 1,"jsonrpc": "2.0", "method": "eth_getProof", "params":
        // ["0x0000000000000000000000000000000000000000", [],"0x96cfa0fb5e50b0a3f6cc76f3299cfbf48f17e8b41798d1394474e67ec8a97e9f"]

        // Populate accountProof with actual RLP-encoded nodes
        bytes[] memory accountProof = new bytes[](9);
        accountProof[
            0
        ] = hex"f90211a0ac56e335724fb9576f47030b7f20271daf5af760471fab3ae53a17c2a96f27eda0d438f3ad8d96a3ad7e772738fe6518669e185352fddfd6b5f701c1bbbc4a4795a0b7502318f398fa0f9e138aa9f72b43f2a9d28bb1d422086d56c0e0a986de817fa07739d2fc7475e8fd330a7366ae160827b0e9ede670202aa02749323e91d4d22fa051811bb0263fac1357365af69ab11f523f80a028aab2c642cb793d3f78fd74e7a0bf4afc0e601fb4414472ad506eb12c744326412f03a72100676bb597f379f881a0ad0dd1675c4c7d15c5b7620a24502935b5e5627a2cc80a25579abf9ed7c1049da019c036d00e5ba00689c328391861f7f6251cbbd3d4ebb62ac5274406bd737cffa0f470a85d5192e60f03cdebffee9231cbe949e354e57e6eaeee0c7544d47edd81a00922c822cd85118b773a500a5dfdd9b8a38a604a9172b87c7b3471a65bbb8501a0d2fdf356ab6eca481a4027e1c576c24a75fcf1bfd12423eed0fd50a83f8e0d0aa016a3580e08047f0479c4be7b13bc7c5446f7e394d7a08ee413c352a2caf05fbea09bae005f7c383c1b26a142c19de08a9a38abf4264e1fbaf257423586dba918e8a06387d3eafc6b71bc47e5fe5a957637406636b41c1ddfbeb85352d5a11215cdffa0df6b96d4ec703253815f4d055358ce1ef7c820e00a58ba8694adad9f2db787daa0bc7b1ee96cfe4db5e0621777f634ec35d68cb2d3baff2911ae42fedb39274cab80";
        accountProof[
            1
        ] = hex"f90211a0a9965a5aea8d1eddb920ec5afaa5a2ea5e6540fd1a969680227be5d0598c12d2a03352c7642b1e180fee152ff8c55cb2590503c838ecc5f9a987d575c80129f413a084877714f6d33e4c69dd31b60f71d45d67bbc53ee57a6a4df438b16a4acb6f30a0d079e1d1e59da7c50d51548f7000a1ea92cc437d6d8c2f2bc5a1d8474b729b78a0d13416e72f467a25c06d27e1b7bbcb4c0d03f9c235f5ed2af4926a191b91d8d7a0a16e7a3ed3597b2b77572c32f2411952af0973e8958ac9a5711804ecf52f5b5da05799c2d033408707a8a42fa689baaa939dc0b41e705dbcd4da54d4828767c029a0db2a5aa16f88de91c8978b0c8f4837cc056a02f850a2f1ac5878118dace9279ba04dcaa5f8cd0a2ed1df6c5188c3841336333170f461d023af0935f7ca19218f95a0fa1797145d2b0090492ddb4274db842fdba0ef2e9e72a2a5a335f6321c218437a0e76281766b3d302a9507c11618f2e40b0747a9238743df498a10db2175ecf0afa029aeebd1fbb069e44aebe8d6f8ebc74ce6fa62d36821610492c4b3b565c6d5eaa00396bc65921bc7896aa6ca99d9fc75695293dd8de98886f3d7875591b57f75c1a04bc540fcc6b0617418138834b19b9587fdc44b8160c9251438aa937db048e9daa03ac441209c3c969a9e0cf7a1b33b96ab299eaa95d1db3d238e65600b555d73a1a08ae1230ef93013093aaf0058fdb11a396052e7586fe5d0deb17e955ceade136780";
        accountProof[
            2
        ] = hex"f90211a0ae7e65e9bf654c6571e21ee910ee5353b3bface6e0e608aeeaf5b3b86c9c4ed3a03a51269dabdf0398c15634d21e21e81f26b9ccd00a4013e9ac6a151464f12b0da0e76ecc2e5b3d7dd8168d97aa70315c3c156782f992a653f26a5e42319f75e540a0197f260165db39853f4a91c308a253a2708c52e20d899156cc81397ba07ae4daa0b27172b9d73707a908c141e78d4d15521b73c1336a7c5a2406620d85674cc58ba0041268532f27670af0352ce14b51656a28193a543c9b8b66266f5048864ee71ca053edca184853f1d3027c8f8b0051ddfcb6ef2159fa2b845389cd4bfbfc7121a0a01492806fccf543b37746f8ca9c17781df56def243fc82d350495cde656011e37a0690c734b27bbbc46fcd2ab93d62a172c53e7295d4ed18c1fc1a209b3b1c60644a03d0210e5d592b4ac8c33b4e2455489d558121e8f012cbd3d7cff36b3e31ca35ea098af1f2ad4cd0812dfd7d738f497e03560048f0348ddcf9e1873d7ca72938be5a07d245baea1ce1411c61afc8cd4729febe7ef4348381d627b60049d9b5213e5e3a02bc153d9e0ee8ab7d0db4b0faed2c10d1399c79f227b80632fee546d96623162a046217ceaac718d4a179af0356e8f83eb42ce1295bf7a06cf9ad55ca260161ebaa0e3deeffaa9a9d1b1a326a1a2399e854e8fcb9eadb8e21f510ade34fed43d0f80a019f8e09aeaf64c016b1cb12ff4fb51472db7ea9fa1b1fb831d9c491c67dd3b3c80";
        accountProof[
            3
        ] = hex"f90211a0171cef66c045e6ee0cf9b875af4d7c919867740f467d7895730cc40cbfdc3d56a0d86128ba1adf8108d3f9e40021c6c3697848ebd057ed6f0fdac6df516f8c1eeaa0de6cd70ff7aae60b93f3688ef4d492e1658327e80012ad7785770024e76d6d70a070ca0e20d2d31d1b23681c6751d9d06200c4e00564495074de6369451ca8f5a2a0feffbe1373d84684d0e2682708c72828c436c373f086937d2f30bc802fa39a3ba03fcfa1d061bfb8ab9bbc0b612193a4d9923216545b9bef95dafde4faf79a04dba0f458f5c5f33f21dde05d650389c2d63b9d28d2b63155b7c1365d135eba38b0d6a07ac322669a192e94377828a25882c2cf21adb23c87e8e88da832f998d53752d6a01ce6f89124494f412c4e2e291d36d368266203999a8bf6876f848f23c38ae949a0cc266b66ef03ec2ddeb4ec8e3cde314a92021226f976a46f78ea8339934e0041a060e3d113a5245112a58db43cdd066456e5d4076d827ceeacca53ffe93abcecb0a0f1e925d0161f37a12518f223525b518710cf5396493c8b286d8cd68a48c64fcea0519ed3b58993248bc76fb9ed7682d12b07ee809cbfd58c27fef73f584baf1d30a002c30477eefcdca5ca72c2e021fa6c3c3bcabfaaaeb312bbe566462726e213aca015701c8ac54c29e5ea7063a4450038b6e971822ec64526e446c53610515ba47ba09a10a4d99e041ec67bc853cc6dcbe2c25de398cff045bb8cb3c1e49c58c8989380";
        accountProof[
            4
        ] = hex"f90211a0ab9c229a712d47424546d3b56083e9fc71956d3cfdd351e18c6745ccd38a78cca02f9b66f8f2f5876931648294a618b9560aed51f80ace2fd5df126ade4f6b0952a0e60f11787f7d63ae9fbd87c90ebd33bb24c933d307fbc657d844a143288d871ea077a0ead4d29ed55dc40388c7e0d8fbcb47555a8d574bb33aef0b01402f39b69fa0262e18c8bb6840fd9f3f271346a132f70cee6714c248af4fe2668a7a9695cb54a061800009e9b55df718665d8d31269e52b1b238b2c3103e9a52d85ca8324704aaa0b4d46df28c63cd8f9af19306ed64f94b1e9284999534bc92f3e394b07b35d5d0a0c2366e8b160756be7b4ecf8f4e16e36f7e8f6b9c4ede78442d2e5b9bfd229b08a05f11dfaa1aefb5e8aa387068c75d2fd593543c051aef945f8ae8d53bb901e470a078d0f39ecca392ae4b8d678c1a5c5967dd8e45d865babbb5cd69bdba29e06f72a0e7587db309e5554001faa4e486f04cd1c10d6b0587f55dbe43c7f9f009a0d2e0a059d95a7daf1f4bfdc29ffb38ca7f4e860793d8b9de0b80f3cfdba640ad97bd23a01db5d2972e60b01356a244627fd0d503e46b69e49d2f5b2389fce05d436427eca025523d65f51a0c24e4e2c5c7cba8bf07d93419929dd3e462b33078ed5c1a1b5aa08ffd39ae5dc49d96abbb2feee956b3923610ea5f5a304e0fc8ce849535c30266a033ef05a4036276222d7ded8483dbda662af3bb04f3210845fcd4f9bcbbd29a1780";
        accountProof[
            5
        ] = hex"f90211a0d4cab5a47d8043340092eba307d3b479837e51edf2975224c46b78fa5d9f2bdea0695a263632773b89fc8e16270da2e893254eeb7388fe4218bf3dbcf9b26c4834a0adfea25bac8862fb080a091f6e19a00bd137427f7a0886c8f50aeb4a3872c5a0a08179a51d62c8ee0f3ad5eb3535c56dd975a9e52260c202c36e159129779448a4a0c0f682c90f18feaa067339a7a42b583f305a79503b16d61a56f10551132773c0a028df3d931fa6fad2f30a3c471ac1a79f038980e262287030b0699bffba133ea4a0e2b138a12ce1b81f04de0f18c5cda2c1e6aedc3aa492a851f4d74d02fb8eb938a066fbcf7df4dd4794027f3665ddf2ce4fc102d3201a43b21278b8f4c35a30e4afa0651f49adb9572e81a082469d2823d728b9d40755534c997057f0085d464cd5aca0b7d9e9ca48f3c7beae701128ecd079dc62071464d505015ac54ccda9bad97216a003a0946cf1ced04b70824b889e5d78198d87948e4b039bec65a2414924df8144a0e434d71446bc0e7e57212c6e9c51404aeaef72793a78573d11b5b52ea93364eea003b39a423c7ce0663d5fa748919a7039b7f4fcbcd00db13582de55435f5d0d0da0ebfd28715bfd53b7d382584d359028ffda90da7708131a666701a4703f258ca8a03768dc2f979daec77db519b61c2629389fe2f9f71940d04fc6d5af2f6ce5f2c7a0b4d261157f8b020cf954cdb60cd3fa1744bcb61f8da0cd49e7f91165fd83a07380";
        accountProof[
            6
        ] = hex"f9011180a03464dee21bd9b7f1712c25a7bf48517d93f6cd02bc5e069e85ca98eef103792b80a0ac233ce7e7018541d154a3abf88a2d3d564777b116c94fec994ce36d0ae1582ba0fd874c87366c0aaaf7fccf6065684b0745c3dcb1632d64ebb023cfe15512924e808080a02073bcfe0a91dc4b71e13226cefc82d938a69b86d682b838f1db53f367510f8f80a040c3c8f7a9522d6df5c0028d90d360f73c5169b4cf434d95350beed43e167390a04c023127c5bb25f03f58244f07838c204c1715ac0339e21f8deed2f8001ec9b0a0a856e72e69c2131a5d4e0ac7b583725e9a400db1263a6f0b13fd298c5df84327a0598f8e0f6c6ea52b62e04c655de5e5494597c2902078b98091861dd0bf237873808080";
        accountProof[
            7
        ] = hex"f85180808080a06cb96634150a4bf19ad1cd1d29ead274d327b6c478fe4624570e3b7f848fea318080a0a584ea7f438f58ad5bf38204b58bcae404b1051204c575c896681db7aefa2df8808080808080808080";
        accountProof[
            8
        ] = hex"f8709d20ae81a58eb98d9c78de4a1fd7fd9535fc953ed2be602daaa41767312ab850f84e808a0272319756fe18f2cdfca056e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421a0c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470";

        // Call the verifier to verify the account state
        (
            bool isValid,
            StateProofVerifier.AccountState memory accountState
        ) = verifier.verifyAccountState(stateRoot, account, accountProof);

        console.log("Nonce:", accountState.nonce);
        console.log("Balance:", accountState.balance);
        console.logBytes32(accountState.storageRoot);
        console.logBytes32(accountState.codeHash);

        // Assert that the proof is valid
        assertTrue(isValid, "State proof verification failed");

        // Assert that account fields are as expected
        uint256 expectedNonce = 0;
        uint256 expectedBalance = 0x272319756fe18f2cdfc;
        bytes32 expectedStorageRoot = 0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421;
        bytes32 expectedCodeHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;

        assertEq(accountState.nonce, expectedNonce, "Nonce mismatch");
        assertEq(accountState.balance, expectedBalance, "Balance mismatch");
        assertEq(
            accountState.storageRoot,
            expectedStorageRoot,
            "Storage root mismatch"
        );
        assertEq(accountState.codeHash, expectedCodeHash, "Code hash mismatch");
    }
}
