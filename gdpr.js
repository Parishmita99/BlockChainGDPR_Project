const Web3 = require('web3');

const web3 = new Web3(Web3.givenProvider);


const contractABI = JSON.parse(fs.readFileSync('gdpr.json', 'utf8'));


const contractAddress = '0xaE036c65C649172b43ef7156b009c6221B596B8b'; 

// Create a contract instance
const contractInstance = new web3.eth.Contract(contractABI, contractAddress);

const accountAddress ='0x9DD81F8422ab8cb9ED02bef56D51d89ecaE39305'; 
const privateKey = '97ec9e1a4682ab2d7383cf35ae83e31c0cb13a1b047b32624a5260435fe8e7d2'; 


async function uploadData(encryptedData, encryptedKey) {
    try {

        const options = {
            from: accountAddress,
            gas: 600000,
        };
        const signedTx = await web3.eth.accounts.signTransaction(
            {
                to: contractAddress,
                data: contractInstance.methods.uploadData(encryptedData, encryptedKey).encodeABI(),
                ...options,
            },
            privateKey
        );


        const receipt = await web3.eth.sendSignedTransaction(signedTx.rawTransaction);
        console.log('Transaction receipt:', receipt);
    } catch (error) {
        console.error('Error uploading data:', error);
    }
}

uploadData('0xabcdef...', '0x123456...');
