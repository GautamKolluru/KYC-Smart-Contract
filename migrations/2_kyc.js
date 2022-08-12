const KYC = artifacts.require("Kyc")

module.exports = function (deployer) {
  deployer.deploy(KYC)
}
