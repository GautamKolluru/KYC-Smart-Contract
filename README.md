# Decentralized-KYC-Verification-Process-for-Banks

Know your customer or KYC originated as a standard to fight against the laundering of illicit money flowing from terrorism, organised crime and drug trafficking. The main process behind KYC is that government and enterprises need to track the customers for illegal and money laundering activities. Moreover, KYC also enables banks to better understand their customers and their financial dealings. This helps them manage their risks and make better decisions.

# Need For KYC

Customer Admittance: This sector defines making anonymous accounts as restricted entry into the banking system. In other words, no anonymous accounts are allowed. Preliminary information, such as names, date of birth, addresses and contact numbers, is to be collected to provide banking service.

Customer Identification: In the case of suspicious banking transactions through a customer, customer accounts can be tracked and flagged. Further, they can be sent for processing under the bank head office for review.

Monitoring of Bank Activities: Suspicious and doubtful activities in any account can be zeroed in by the bank after understanding its customer base using KYC.

Risk Management: Now that the bank has all the preliminary information and the activity pattern, it can assess the risk and the likelihood of the customer being involved in illegal transactions.

# Solution Using Blockchain

The blockchain is an immutable distributed ledger shared with everyone involved in the network. Every participant interacts with the blockchain using a public-private cryptographic key combination. Moreover, immutable record storage is provided, which is extremely hard to tamper with.

 

Banks can utilise the feature set of blockchain to reduce the difficulties faced by the traditional KYC process. A distributed ledger can be set up between all the banks, where one bank can upload the KYC of a customer and other banks can vote on the legitimacy of the customer details. KYC for the customers will be immutably stored on the blockchain and will be accessible to all the banks in the blockchain.

 # Smart Contract Flow
 
 The bank collects the information for the KYC from the customer.

The information given by the customer includes username and customer data, which is the hash of the link for the customer data. This username is unique for each customer. 

A bank creates the request for submission, which is stored in the smart contract.

A bank then verifies the KYC data, which is then added to the customer list.

Other banks can get customer information from the customer list.

Other banks can also provide upvotes/downvotes on customer data to showcase the authenticity of the data. If the number of upvotes is greater than the number of downvotes, then the kycStatus of that customer is set to true. If a customer gets downvoted by one-third of the banks, then the kycStatus of the customer is changed to false even if the number of upvotes is more than that of downvotes. For such logic, there should be a minimum of 5 or 10 banks in the network. 

In short, there are two conditions to be checked: The number of upvotes and downvotes and whether the number of downvotes is greater than one-third of the total number of banks. 

Banks can also complain against other banks if they find the bank to be corrupt and if it is verifying false customers. Such corrupted banks will then be banned from upvoting/downvoting further. If more than one-third of the total banks in the network complain against a certain bank, then the bank will be banned (i.e., set isAllowedToVote to false of that corrupt bank.).

# Graphical Representation

![bank](https://user-images.githubusercontent.com/39323954/177722055-a96e4009-7e47-45a1-89c3-e4d1ddbb8eb1.png)
