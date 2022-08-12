//SPDX-License-Identifier: GPL - 3.0
pragma solidity >=0.7.0 <0.9.0;

contract Kyc {
    struct Customer {
        string name;
        string data;
        bool kycStatus;
        uint256 upVotes;
        uint256 downVotes;
        address kycValidatedBank;
    }

    struct KYCRequest {
        string customername;
        string customerdata;
        address kycRequestedBank;
    }

    struct Bank {
        string name;
        address ethAddress;
        uint256 complaintReported;
        uint256 kycCount;
        bool isAllowedToVote;
        string regNumber;
    }

    mapping(string => KYCRequest) public kycRequestList;
    mapping(string => Customer) customerList;
    mapping(address => Bank) bankList;
    uint256 totalNumberOfBanks;
    address public admin;
    mapping(string => mapping(address => bool)) bankCustomerVote;

    constructor() {
        admin = msg.sender;
        totalNumberOfBanks = 0;
        Bank memory bank = Bank({
            name: "Admin",
            ethAddress: admin,
            complaintReported: 0,
            kycCount: 0,
            isAllowedToVote: true,
            regNumber: "0"
        });

        bankList[admin] = bank;
    }

    /* This modifier is to validate whether customer present when we add first time */

    modifier validateCustomer(string memory _name) {
        require(
            customerList[_name].kycValidatedBank == address(0),
            "Customer is already present, please call modifyCustomer to edit the customer data"
        );

        _;
    }

    /* This modifier is to validate whether Kyc request for customer is present  */
    modifier validateCustomerKycRequest(string memory _name) {
        require(
            kycRequestList[_name].kycRequestedBank != address(0),
            "Customer is not present in the kyc request list"
        );

        _;
    }

    /* This modifier is to validate whether KYC request for specifit customer is present  */
    modifier validateKycRequestList(string memory _name) {
        require(
            kycRequestList[_name].kycRequestedBank == address(0),
            "Customer already present in the kyc request list"
        );

        _;
    }

    /* This modifier is to validate whether customer exist in the system */

    modifier validateCustomerExist(string memory _name) {
        require(
            bytes(customerList[_name].name).length > 0,
            "Customer is not present in the database"
        );

        _;
    }

    /* This modifier is to validate whether bank exist in the system */

    modifier validateBankExist(address _bankAddress) {
        require(
            bankList[_bankAddress].ethAddress != address(0),
            "Bank not added in the network to perform this operation"
        );

        _;
    }

    /* This modifier is to validate whether bank already added to the network */

    modifier validateBankAlreadyAdded(address _bankAddress) {
        require(
            bankList[_bankAddress].ethAddress == address(0),
            "Bank already added in the network"
        );

        _;
    }

    /* This modifier is to validate admin status */

    modifier validateAdminStatus(address _bankAddress) {
        require(_bankAddress == admin, "Only Admin can perform this operation");

        _;
    }

    /* This modifier is to validate voting capability for bank for individiual customer */
    modifier validateBankCustomerVoteStatus(
        address _bankAddress,
        string memory _customerName
    ) {
        require(
            bankCustomerVote[_customerName][_bankAddress] == false,
            "Bank already voted for this customer"
        );
        require(
            bankList[_bankAddress].isAllowedToVote == true,
            "Bank is not allowed to vote"
        );

        _;
    }

    /* Desc:This function is to add customer for KYC Verification
       @param:customer name
       @param:hash of customer data 
     */

    function addKYCRequest(
        string memory _customerName,
        string memory _customerData
    )
        public
        validateBankExist(msg.sender)
        validateKycRequestList(_customerName)
    {
        KYCRequest memory customerKYC = KYCRequest({
            customername: _customerName,
            customerdata: _customerData,
            kycRequestedBank: msg.sender
        });

        kycRequestList[_customerName] = customerKYC;
    }

    /*  Desc:This function is to add customer in customer list after kyc verification
        @param:customer name
        @param:hash of customer data 
     */

    function addCustomer(
        string memory _customerName,
        string memory _customerData
    ) public validateCustomer(_customerName) validateBankExist(msg.sender) {
        Customer memory customer = Customer({
            name: _customerName,
            data: _customerData,
            kycValidatedBank: msg.sender,
            upVotes: 0,
            downVotes: 0,
            kycStatus: true
        });

        bankCustomerVote[_customerName][msg.sender] = false;

        customerList[_customerName] = customer;
    }

    /*  Desc:This function is to remove customer for kyc request list
        @param:customer name
        @param:hash of customer data 
     */

    function removeKYCRequest(string memory _customerName)
        public
        validateCustomerKycRequest(_customerName)
        validateBankExist(msg.sender)
    {
        delete kycRequestList[_customerName];
    }

    /*  Desc:This function is to view customer details
         @param:customer name
         @return: customer details
     */

    function viewCustomer(string memory _name)
        public
        view
        validateCustomerExist(_name)
        validateBankExist(msg.sender)
        returns (Customer memory)
    {
        return customerList[_name];
    }

    /*  Desc:This function is to add upVote for customer 
        @param:customer name   
     */

    function upVoteCustomer(string memory _customerName)
        public
        validateCustomerExist(_customerName)
        validateBankExist(msg.sender)
        validateBankCustomerVoteStatus(msg.sender, _customerName)
    {
        customerList[_customerName].upVotes++;
        validateCustomerStatus(_customerName);
        bankCustomerVote[_customerName][msg.sender] = true;
    }

    /*   Desc:This function is to add downVote for customer 
         @param:customer name  
     */

    function downVoteCustomer(string memory _customerName)
        public
        validateCustomerExist(_customerName)
        validateBankExist(msg.sender)
        validateBankCustomerVoteStatus(msg.sender, _customerName)
    {
        customerList[_customerName].downVotes++;
        validateCustomerStatus(_customerName);
        bankCustomerVote[_customerName][msg.sender] = true;
    }

    /*    Desc:This function is to check whether upvote count is more the downvote
          @param:customer name 
       */

    function validateCustomerStatus(string memory _customerName) internal {
        if (
            customerList[_customerName].upVotes >
            customerList[_customerName].downVotes &&
            customerList[_customerName].downVotes < totalNumberOfBanks / 3
        ) {
            customerList[_customerName].kycStatus = true;
        } else {
            customerList[_customerName].kycStatus = false;
        }
    }

    /*   Desc:This function is to modify customer details
         @param:customer name
         
     */

    function modifyCustomerDetail(string memory _customerName)
        public
        validateBankExist(msg.sender)
        validateCustomerExist(_customerName)
    {
        delete kycRequestList[_customerName];
        customerList[_customerName].upVotes = 0;
        customerList[_customerName].downVotes = 0;
    }

    /*   Desc:This function is to get of complaint count for a bank
         @param: bank address
         @return:number of complaint bank received 
     */

    function getBankComplaint(address _bank)
        public
        view
        validateBankExist(_bank)
        returns (uint256)
    {
        return bankList[_bank].complaintReported;
    }

    /*   Desc:This function is to view bank details
         @param: bank address
         @return: bank details 
     */

    function viewBankDetails(address _bank)
        public
        view
        validateBankExist(_bank)
        returns (Bank memory)
    {
        return bankList[_bank];
    }

    /*   Desc:This function is to raised compalin against bank
         @param: bank address
         @return: bank details 
     */

    function reportBank(address _bank) public validateBankExist(_bank) {
        bankList[_bank].complaintReported += 1;
        validateBankComplaintStatus(_bank);
    }

    /*   Desc:This function is to validate bank complaint status
         @param: bank address
         
     */
    function validateBankComplaintStatus(address _bank) internal {
        if (bankList[_bank].complaintReported > (totalNumberOfBanks / 3)) {
            bankList[_bank].isAllowedToVote = false;
        } else {
            bankList[_bank].isAllowedToVote = true;
        }
    }

    /*    Desc:This function is for Admin to add a bank
          @param: bank name
          @param: bank address
          @param: bank registration number 
     */

    function addBank(
        string memory _bankName,
        address _bankAddress,
        string memory _bankRegistration
    )
        public
        validateAdminStatus(msg.sender)
        validateBankAlreadyAdded(_bankAddress)
    {
        Bank memory bank = Bank({
            name: _bankName,
            ethAddress: _bankAddress,
            complaintReported: 0,
            kycCount: 0,
            isAllowedToVote: true,
            regNumber: _bankRegistration
        });

        bankList[_bankAddress] = bank;
        totalNumberOfBanks = totalNumberOfBanks + 1;
    }

    /*    Desc: This function is for Admin to modify bank voting status
          @param: bank address
          @param: boolean value true/false 
     */

    function modifyBank(address _bankAddress, bool _isAllowedToVote)
        public
        validateAdminStatus(msg.sender)
        validateBankAlreadyAdded(_bankAddress)
    {
        bankList[_bankAddress].isAllowedToVote = _isAllowedToVote;
    }

    /*    Desc: This function is for Admin to remove bank from network 
          @param: bank address
         
     */

    function removerBank(address _bankAddress)
        public
        validateAdminStatus(msg.sender)
        validateBankAlreadyAdded(_bankAddress)
    {
        delete bankList[_bankAddress];
    }
}
