class Inventory {
  Item[] items = new Item[itemMax];
  int found = 0;


  void put(Item item) {
    if (found < itemMax) {
      items[found] = item;
      found++;
    } else {
      println("error:インベントリのアイテムの数が最大数を超えています。");
    }
  }

  void showBoxes() {
    fill(0);
    stroke(255, 215, 0);
    strokeWeight(2);
    for (int i = 0; i < itemMax; i++) {
      rect(i * 50 + 20, 20, 50, 50);
    }
  }

  void showItems() {
    for (int i = 0; i < itemMax; i++) {
      if (items[i] != null) {
        image(items[i].image, i * 50 + 22, 22, 45, 45);
      }
    }
  }
}
