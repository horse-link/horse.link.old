const Horse = artifacts.require("Horse");

contract("Horse", (accounts) => {
  let horse;

  beforeEach(async () => {
    horse = await Horse.new();
  });

  describe("results", () => {
    it("should have 0 count", async () => {
      const count = await horse.count();
      assert.equal(count, 0, "Should have no values");
    });

    it("should add a result", async () => {
        await horse.addResult("0x534841", 2021, 7, 4, 2, [12, 4, 8, 11]);
        const count = await horse.count();
        assert.equal(count, 1, "Should have no values");
      });
  });
});
