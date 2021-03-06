import processing.sound.*;
import java.util.Map;

PFont mplus;
PFont title;
PFont restart;
Text[] texts;
int itemMax = 4;
HashMap<String, Item> items;
SceneManager sm;
Inventory iv;
color bgColor = color(0);
boolean startScreen = true;
boolean clearScreen = false;
int currentDirection = 1; //1.North 2.East 3.South 4.West
boolean plantMoving = false;
boolean plantMoved = false;
boolean cleared = false;
int clearCounter = 0;

void setup() {
  startScreen = true;
  clearScreen = false;
  currentDirection = 1;
  plantMoving = false;
  plantMoved = false;
  cleared = false;
  clearCounter = 0;
  
  mplus = createFont("mplus-1m-light", 30, true);
  title = createFont("mplus-1m-light", 70, true);
  restart = createFont("mplus-1m-light", 40, true);
  textFont(mplus);
  JSONArray JSONtexts = loadJSONArray("texts.json");
  texts = new Text[JSONtexts.getStringArray().length];
  for (int i = 0; i< JSONtexts.getStringArray().length; i++) { 
    texts[i] = new Text(JSONtexts.getString(i));
  }
  sm = new SceneManager();
  iv = new Inventory();
  size(720, 720);
  background(bgColor);
  sm.showRoom();
  sm.getText().setVisible(false);
  items = new HashMap<String, Item>();
  if (!items.containsKey("key")) {
    items.put("key", new Item("カギ", "key.png", 455, 430, 0.15, true, 4));
  } else {
    println("カギがすでに登録されてるよ？コード見直そうか？？");
  }
  if (!items.containsKey("door")) {
    items.put("door", new Item("ドア", "door_close.png", 440, 177, 1.3, 1));
  } else {
    println("ドアがすでに登録されてるよ？コード見直そうか？？");
  }
  if (!items.containsKey("sofa")) {
    items.put("sofa", new Item("ソファー", "sofa.png", 40, 370, 1.0, 1));
  } else {
    println("ソファーがすでに登録されてるよ？コード見直そうか？？");
  }
  if (!items.containsKey("window")) {
    items.put("window", new Item("窓", "window_1.png", 120, 150, 0.5, 3));
  } else {
    println("ソファーがすでに登録されてるよ？コード見直そうか？？");
  }
  if (!items.containsKey("plant")) {
    items.put("plant", new Item("植木鉢", "plant.png", 450, 340, 0.2, 4));
  } else {
    println("植木鉢がすでに登録されてるよ？コード見直そうか？？");
  }
  if (!items.containsKey("TV")) {
    items.put("TV", new Item("テレビ", "tv_gray.png", 400, 340, 0.3, 2));
  } else {
    println("ソファーがすでに登録されてるよ？コード見直そうか？？");
  }
  if (!items.containsKey("fridge")) {
    items.put("fridge", new Item("冷蔵庫", "fridge.png", 100, 220, 0.3, 2));
  } else {
    println("植木鉢がすでに登録されてるよ？コード見直そうか？？");
  }
  if (!items.containsKey("hummer")) {
    items.put("hummer", new Item("ハンマー", "hummer.png", 450, 480, 0.3, true, 3));
  } else {
    println("ハンマーがすでに登録されてるよ？コード見直そうか？？");
  }
  if (!items.containsKey("passport")) {
    items.put("passport", new Item("パスポート", "passport.png", 100, 300, 0.02, true, 4));
  } else {
    println("パスポートがすでに登録されてるよ？コード見直そうか？？");
  }
  if (!items.containsKey("shelf")) {
    items.put("shelf", new Item("棚", "shelf.png", 80, 250, 0.25, 4));
  } else {
    println("棚がすでに登録されてるよ？コード見直そうか？？");
  }
  if (!items.containsKey("phone")) {
    items.put("phone", new Item("スマホ", "phone.png", 300, 520, 0.015, true, 2));
  } else {
    println("スマホがすでに登録されてるよ？コード見直そうか？？");
  }

  items.get("key").setVisible(true);
  items.get("door").setVisible(true);
  items.get("sofa").setVisible(true);
  items.get("window").setVisible(true);
  items.get("plant").setVisible(true);
  items.get("TV").setVisible(true);
  items.get("fridge").setVisible(true);  
  items.get("hummer").setVisible(true);
  items.get("shelf").setVisible(true);
  items.get("passport").setVisible(true);
  items.get("phone").setVisible(true);

  sm.updateText(texts[0].getStr());
  sm.getText().visible = true;
}

void draw() {
  background(bgColor);
  if (startScreen) {
    sm.showRoom();
    sm.startScreen();
  } else if (!clearScreen) {
    sm.showRoom();
    gameScreen();
  } else {
    sm.clearScreen();
  }
}

void gameScreen() {
  sm.showTextWindow();
  sm.drawDirectionChangeButton();
  iv.showBoxes();
  iv.showItems();
  sm.showText();
  itemDraw();
  if (plantMoving) {
    sm.movePlant();
  }
  if (cleared) {
    if (clearCounter >=100) {
      sm.getText().setVisible(true);
      clearScreen = true;
    }else{
      fill(0,70);
      rect(0,0,width,height);
      clearCounter++;
    }
  }
}


void itemDraw() {
  items.get("key").show();
  for (Item item : items.values()) {
    if (item != items.get("key")) {
      item.show();
    }
  }
}

void mousePressed() {
  if (startScreen) {
    //スタート画面のとき
    startScreen = !startScreen;
  } else if (!clearScreen) {
    //ゲーム画面のとき
    switch(sm.dirButtonClickChecker()) {
    case  LEFT:
      if (currentDirection>1) {
        currentDirection--;
      } else {
        currentDirection =4;
      }
      break;

    case RIGHT:
      if (currentDirection<4) {
        currentDirection++;
      } else {
        currentDirection = 1;
      }
      break;
    }
    //println(currentDirection);

    if (sm.textWindowCheck(mouseX, mouseY)) {
      sm.textClicked();
    }
    itemsClicked();
  } else {
    //クリア画面のとき
    if (sm.textWindowCheck(mouseX, mouseY)) {
      sm.textClicked();
    }
    if (sm.isRestartClicked()) {
      sm.restartClicked();
    }
  }
}


void itemsClicked() {

  for (Item item : items.values()) {
    if (item.isGettable() && !item.isFound() && currentDirection == item.direction) {
      if (item.isIn()) {
        if(item == items.get("key") && !plantMoved){
          break;
        }
        item.setFound(true);
        iv.put(item);
        sm.updateText(item.getName()+"を手に入れた！");
        item.setVisible(false);
        sm.getText().setVisible(true);
      }
    }

    if (!item.isGettable() && item.isIn() && currentDirection == item.direction) {

      if (item == items.get("door")) {
        if (items.get("key").isFound()) {
          items.get("door").setImage("door_opened_1.png");
          
          if (!items.get("phone").isFound()) {
            sm.setEndMsg("End 3");
            sm.updateText(texts[12].getStr());
          } else if (!items.get("passport").isFound()) {
            sm.setEndMsg("End 2");
            sm.updateText(texts[11].getStr());
          } else if (!items.get("hummer").isFound()) {
            sm.setEndMsg("End 1");
            sm.updateText(texts[10].getStr());
          } else {
            sm.setEndMsg("End 0 (True End)");
            sm.updateText(texts[9].getStr());
          }
          cleared = true;
        } else {
          sm.updateText(texts[1].getStr());
          sm.getText().setVisible(true);
        }
      }

      if (item == items.get("sofa")) {
        sm.updateText(texts[2].getStr());
        sm.getText().setVisible(true);
      }
      if (item == items.get("window")) {
        if (items.get("hummer").isFound()) {
          sm.updateText(texts[8].getStr());
        } else {
          sm.updateText(texts[3].getStr());
        }
        sm.getText().setVisible(true);
      }
      if (item == items.get("plant")) {
        if (!plantMoved) {
          sm.updateText(texts[4].getStr());
          plantMoving = true;
        } else {
          sm.updateText(texts[5].getStr());
        }
        sm.getText().setVisible(true);
      }
      if (item == items.get("TV")) {
        sm.updateText(texts[6].getStr());
        sm.getText().setVisible(true);
      }
      if (item == items.get("fridge")) {
        sm.updateText(texts[7].getStr());
        sm.getText().setVisible(true);
      }
    }
  }
}
