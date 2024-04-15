// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GDPRDataManagementProtocol {
    struct KeyPair {
        address publicKey;
        bytes privateKey;
    }

    struct DataRecord {
        bytes encryptedData;
        bytes encryptedKey;
        address owner;
        bool isUploaded;
    }

    struct AccessToken {
        bytes accessToken;
        bool isValid;
    }

    mapping(address => KeyPair) public keyPairs;
    mapping(address => DataRecord) public dataRecords;
    mapping(address => AccessToken) public accessTokens;

    event DataUploaded(address indexed dataOwner, bytes encryptedData, bytes encryptedKey);
    event DataRequested(address indexed dataOwner, address indexed dataRequester);
    event DataAccessed(address indexed dataUser, bytes decryptedData);

    constructor() {
        // Assume Service Provider (SP) deploys the contract and initializes its own key pair
        keyPairs[msg.sender] = KeyPair(msg.sender, "<SP's Public Key>");
    }

    // Function to upload data to the contract
    function uploadData(bytes memory encryptedData, bytes memory encryptedKey) public {
        require(keyPairs[msg.sender].publicKey != address(0), "Caller is not authorized");
        
        dataRecords[msg.sender] = DataRecord(encryptedData, encryptedKey, msg.sender, true);
        emit DataUploaded(msg.sender, encryptedData, encryptedKey);
    }

    // Function for a Data User (DU) to request data from a Data Owner (DO)
    function requestData(address dataOwner) public {
        require(dataRecords[dataOwner].isUploaded, "Data is not uploaded");
        
        emit DataRequested(dataOwner, msg.sender);

        // For simplicity, dummy access token generation
        bytes memory accessToken = "DummyAccessToken";
        accessTokens[dataOwner] = AccessToken(accessToken, true);
    }

    // Function for a Data User (DU) to access data from the contract
    function accessData() public view returns (bytes memory) {
        require(accessTokens[msg.sender].isValid, "Access token is not valid");
        require(dataRecords[msg.sender].isUploaded, "Data is not uploaded");

        // Emit event for accessing data (for logging purposes)
        //emit DataAccessed(msg.sender, dataRecords[msg.sender].encryptedData);

        return dataRecords[msg.sender].encryptedData;
    }

    // Function to retrieve the public key of a Data Owner (DO)
    function getPublicKey(address dataOwner) public view returns (address) {
        return keyPairs[dataOwner].publicKey;
    }
}
