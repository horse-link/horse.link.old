const Horse = artifacts.require("Horse");

module.exports = (deployer) => {
  deployer.deploy(Horse);
};
