import XCTest
@testable import FabricBin

@MainActor
final class FabricBinTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
        store.items = []
    }

    func testSeedDataStaysUnderFreeLimit() {
        XCTAssertLessThan(Store.seedData.count, Store.freeLimit)
    }

    func testAddItem() {
        store.add(name: "Test Bolt", pattern: "Gingham", bin: "Bin C")
        XCTAssertEqual(store.items.count, 1)
        XCTAssertEqual(store.items.first?.name, "Test Bolt")
    }

    func testCanAddBelowLimit() {
        XCTAssertTrue(store.canAdd())
    }

    func testFreeLimitBlocksAdd() {
        for i in 0..<Store.freeLimit {
            store.add(name: "Item \(i)", pattern: "Gingham", bin: "Bin C")
        }
        XCTAssertFalse(store.canAdd())
        XCTAssertTrue(store.isAtFreeLimit)
    }

    func testProBypassesLimit() {
        store.isPro = true
        for i in 0..<(Store.freeLimit + 5) {
            store.add(name: "Item \(i)", pattern: "Gingham", bin: "Bin C")
        }
        XCTAssertTrue(store.canAdd())
    }

    func testDeleteItem() {
        store.add(name: "ToDelete", pattern: "Gingham", bin: "Bin C")
        let item = store.items[0]
        store.delete(item)
        XCTAssertEqual(store.items.count, 0)
    }

    func testUpdateItem() {
        store.add(name: "Original", pattern: "Gingham", bin: "Bin C")
        var item = store.items[0]
        item.name = "Updated"
        store.update(item)
        XCTAssertEqual(store.items.first?.name, "Updated")
    }

    func testDeleteAtOffsets() {
        store.add(name: "A", pattern: "Gingham", bin: "Bin C")
        store.add(name: "B", pattern: "Gingham", bin: "Bin C")
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.items.count, 1)
        XCTAssertEqual(store.items.first?.name, "B")
    }
}
