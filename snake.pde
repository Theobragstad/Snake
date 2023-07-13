import java.util.*;
boolean start = false, options = false, dead = false, canDraw = true, paused = false, add = false, endInput = false;
int headAngle = 0, time = 0, snakeLength = 1, i = 0, score;
String[] fruitNames = {
  "strawberry.png",
  "grape.png",
  "apple.png",
  "orange.png",
  "cherry.png",
  "grapefruit.png",
  "banana.png"
};
PImage[] fruitImages = new PImage[fruitNames.length];
Checkbox[] checkBoxes = new Checkbox[9];
Fruit[] fruitObjects;
ArrayList < Integer > headX = new ArrayList < Integer > (), headY = new ArrayList < Integer > ();
PFont font;
String name = "";

void setup() {
  size(500, 500);
  background(248, 248, 255);
  initializeSnake();
  setupCheckboxes();
}

void draw() {
  if (!start) {
    startScreen();
    loadFruitImages();
  } else {
    time += 1;
    if (!dead) {
      if ((time % setSpeed()) == 0) {
        background(255);
        move();
        display();
      }
      handleSnakeEvents();
      displayFruits();
    } else if (dead) {
      hideFruits();
      gameOverScreen();
      leaderboardAddPressed();
      restartButton();
    }
  }
}

void restartButton() {
  fill(30, 144, 255);
  rect(178, 465, 154, 22);
  fill(255);
  textSize(16);
  text("Restart", 225, 482);
  if (mousePressed && mouseX <= 334 && mouseX >= 176 && mouseY <= 489 && mouseY >= 463) {
    resetVariables();
  }
}

void resetVariables() {
  keyCode = SHIFT;
  start = false;
  options = false;
  dead = false;
  canDraw = true;
  paused = false;
  add = false;
  endInput = false;
  headAngle = 0;
  time = 0;
  snakeLength = 1;
  i = 0;
  name = "";
  headX.clear();
  headY.clear();
  background(248, 248, 255);
  initializeSnake();
  setupCheckboxes();
}

void initializeSnake() {
  for (int i = 0; i < snakeLength + 1; i++) {
    headX.add(0);
    headY.add(0);
  }
  headX.set(0, 200);
  headY.set(0, 200);
}

void setupCheckboxes() {
  for (int i = 0; i < checkBoxes.length; i++) {
    if (i == 0) {
      checkBoxes[i] = new Checkbox(300, 169);
    } else if (i < 4 && i > 0) {
      checkBoxes[i] = new Checkbox(150 + (i * 20), 188);
    } else if (i > 3 && i < 6) {
      checkBoxes[i] = new Checkbox(90 + (i * 20), 208);
    } else if (i > 5 && i < 8) {
      checkBoxes[i] = new Checkbox(30 + (i * 20), 228);
    } else if (i == 8) {
      checkBoxes[i] = new Checkbox(140, 248);
    }
  }
  checkBoxes[1].setColor(color(255, 0, 0));
  checkBoxes[2].setColor(color(255, 165, 0));
  checkBoxes[3].setColor(color(255, 255, 0));
}

void startScreen() {
  options();
  displayCheckboxes();
  if (!options) {
    if (keyCode == ENTER) {
      start = true;
    }
    startScreenVisuals();
  }
}

void options() {
  if (mousePressed && mouseX > 428 && mouseX < 462 && mouseY > 393 && mouseY < 427) {
    options = true;
    stroke(0);
    fill(30, 144, 255);
    rect(42, 85, 415, 336);
    image(loadImage("backIcon.png"), 48, 100);
    textSize(42);
    fill(255);
    text("Settings", 85, 130);
    displayOptions();
  }
  if (mousePressed && mouseX > 46 && mouseX < 75 && mouseY > 90 && mouseY < 119) {
    options = false;
  }
}

void displayOptions() {
  String[] choices = {
    "Don't let snake move through edges:",
    "Secondary color:",
    "Number of fruits:",
    "Snake speed:",
    "Fruits move:"
  };
  fill(0);
  textSize(14);
  for (int i = 0; i < choices.length; i++) {
    text(choices[i], 55, (i * 20) + 180);
  }
}

void displayCheckboxes() {
  for (int i = 0; i < checkBoxes.length; i++) {
    checkBoxes[i].displayCheckBox();
  }
  onlyOneBoxSelected();
  if (options) {
    fill(0);
    textSize(14);
    text("3", checkBoxes[4].getX() + 3, checkBoxes[4].getY() + 12);
    text("5", checkBoxes[5].getX() + 3, checkBoxes[5].getY() + 12);
    textSize(10);
    text(new String(Character.toChars(0x2193)), 155, 237);
    text(new String(Character.toChars(0x2191)), 175, 238);
  }
}

void onlyOneBoxSelected() {
  if (checkBoxes[1].getChecked()) {
    checkBoxes[2].setChecked(false);
    checkBoxes[3].setChecked(false);
  } else if (checkBoxes[2].getChecked()) {
    checkBoxes[1].setChecked(false);
    checkBoxes[3].setChecked(false);
  } else if (checkBoxes[3].getChecked()) {
    checkBoxes[1].setChecked(false);
    checkBoxes[2].setChecked(false);
  }
  if (checkBoxes[4].getChecked()) {
    checkBoxes[5].setChecked(false);
  } else if (checkBoxes[5].getChecked()) {
    checkBoxes[4].setChecked(false);
  }
  if (checkBoxes[6].getChecked()) {
    checkBoxes[7].setChecked(false);
  } else if (checkBoxes[7].getChecked()) {
    checkBoxes[6].setChecked(false);
  }
}

void startScreenVisuals() {
  font = createFont("font.ttf", 32);
  textFont(font);
  image(loadImage("colorPattern.png"), 30, 72);
  image(loadImage("greenSnake.png"), 42, 85);
  fill(255);
  textSize(42);
  text("Snake Game", 145, 245);
  textSize(16);
  text("Press return to play", 195, 280);
  fill(30, 144, 255);
  rect(195, 305, 140, 35);
  fill(0);
  textSize(12);
  text("use arrow keys to move", 198, 320);
  text("press shift to pause/play", 198, 335);
  image(loadImage("settingsIcon.png"), 430, 395);
}

void loadFruitImages() {
  int fruitCount = 1;
  if (checkBoxes[4].getChecked()) {
    fruitCount = 3;
  } else if (checkBoxes[5].getChecked()) {
    fruitCount = 5;
  }
  fruitObjects = new Fruit[fruitCount];
  for (int i = 0; i < fruitNames.length; i++) {
    fruitImages[i] = loadImage(fruitNames[i]);
  }
  for (int i = 0; i < fruitObjects.length; i++) {
    fruitObjects[i] = new Fruit(random(30, width - 30), random(30, height - 30), fruitImages[(int) random(0, fruitNames.length)]);
  }
}

int setSpeed() {
  int speed = 5;
  if (checkBoxes[6].getChecked()) {
    speed = 10;
  } else if (checkBoxes[7].getChecked()) {
    speed = 3;
  }
  return speed;
}

void move() {
  if (!paused) {
    for (int i = snakeLength; i >= 0; i--) {
      if (i == 0) {
        if (headAngle == 0) {
          headX.set(0, headX.get(0) + 20);
        } else if (headAngle == 90) {
          headY.set(0, headY.get(0) - 20);
        } else if (headAngle == 180) {
          headX.set(0, headX.get(0) - 20);
        } else if (headAngle == 270) {
          headY.set(0, headY.get(0) + 20);
        }
      } else {
        headX.set(i, headX.get(i - 1));
        headY.set(i, headY.get(i - 1));
      }
    }
  }
}

void display() {
  color secondary = color(27, 234, 45);
  for (int i = 1; i < 4; i++) {
    if (checkBoxes[i].getChecked()) {
      secondary = checkBoxes[i].getColor();
    }
  }
  stroke(27, 234, 45);
  for (int i = 0; i < snakeLength; i++) {
    if (i % 2 == 0) {
      fill(27, 234, 45);
    } else if (i % 2 == 1) {
      fill(secondary);
    }
    rect(headX.get(i), headY.get(i), 20, 20, 5);
  }
  headImages();
}

void headImages() {
  if (headAngle == 0) {
    image(loadImage("right.jpg"), headX.get(0) + 20, headY.get(0) + 1);
  } else if (headAngle == 90) {
    image(loadImage("up.jpg"), headX.get(0) + 1, headY.get(0) - 18);
  } else if (headAngle == 180) {
    image(loadImage("left.jpg"), headX.get(0) - 18, headY.get(0) + 1);
  } else if (headAngle == 270) {
    image(loadImage("down.jpg"), headX.get(0) + 1, headY.get(0) + 20);
  }
}

void handleSnakeEvents() {
  die();
  grow();
  onEdge();
}

void die() {
  for (int i = 1; i < headX.size(); i++) {
    if (headX.get(0).equals(headX.get(i)) && headY.get(0).equals(headY.get(i))) {
      dead = true;
    }
  }
}

void grow() {
  for (int i = 0; i < fruitObjects.length; i++) {
    if (headY.get(0) < fruitObjects[i].getY() + 20 && headY.get(0) > fruitObjects[i].getY() - 20 && headX.get(0) < fruitObjects[i].getX() + 22 && headX.get(0) > fruitObjects[i].getX() - 20) {
      fruitObjects[i].setDraw(false);
      snakeLength++;
      headX.add(0);
      headY.add(0);
      fruitObjects[i].setXYIS(random(30, width - 30), random(30, height - 30), fruitImages[(int) random(0, fruitNames.length)], random(-2, 2), random(-2, 2));
      fruitObjects[i].setDraw(true);
    }
  }
}

void onEdge() {
  if (!checkBoxes[0].getChecked()) {
    if (headAngle == 180 && headX.get(0) + 10 <= 0) {
      headX.set(0, width - 20);
    }
    if (headAngle == 90 && headY.get(0) + 10 <= 0) {
      headY.set(0, height - 20);
    }
    if (headAngle == 0 && headX.get(0) > width - 10) {
      headX.set(0, 0);
    }
    if (headAngle == 270 && headY.get(0) > height - 10) {
      headY.set(0, 0);
    }
  } else {
    if (headX.get(0) == 0 || headY.get(0) == 0 || headX.get(0) == width || headY.get(0) == height) {
      dead = true;
    }
  }
}

void displayFruits() {
  for (int i = 0; i < fruitObjects.length; i++) {
    if (fruitObjects[i].getDraw()) {
      image(fruitObjects[i].getImg(), fruitObjects[i].getX(), fruitObjects[i].getY());
      if (checkBoxes[8].getChecked()) {
        fruitObjects[i].move();
      }
    }
  }
}

void hideFruits() {
  for (int i = 0; i < fruitObjects.length; i++) {
    fruitObjects[i].setDraw(false);
  }
}

void gameOverScreen() {
  score = snakeLength - 1;
  if (setSpeed() == 10) {
    score /= 2;
  } else if (setSpeed() == 3) {
    score *= 2;
  }
  fill(0);
  stroke(0);
  textSize(30);
  text("Game over", 180, 200);
  textSize(20);
  text("score: " + score, 211, 250);
  fill(30, 144, 255);
  rect(178, 278, 154, 22);
  fill(255);
  textSize(16);
  text("Add to leaderboard", 180, 295);
}

void leaderboardAddPressed() {
  if (!add) {
    if (mousePressed && mouseX >= 176 && mouseX <= 334 && mouseY >= 276 && mouseY <= 302) {
      add = true;
    }
    if (add) {
      fill(0);
      textSize(14);
      text("Type initials: ", 210, 350);
      textSize(10);
      text("press enter when done", 200, 400);
    }
  }
}

void keyPressed() {
  if (dead) {
    nameInput();
  }
  if (keyCode == SHIFT && !paused) {
    paused = true;
  } else if (keyCode == SHIFT && paused) {
    paused = false;
  }
  if (!paused) {
    if (keyCode == UP && headAngle != 270 && (headY.get(0) - 20) != headY.get(1)) {
      headAngle = 90;
    }
    if (keyCode == DOWN && headAngle != 90 && (headY.get(0) + 20) != headY.get(1)) {
      headAngle = 270;
    }
    if (keyCode == LEFT && headAngle != 0 && (headX.get(0) - 20) != headX.get(1)) {
      headAngle = 180;
    }
    if (keyCode == RIGHT && headAngle != 180 && (headX.get(0) + 20) != headX.get(1)) {
      headAngle = 0;
    }
  }
}

void nameInput() {
  textSize(14);
  if ((key == ENTER && name.length() > 0) || name.length() > 2 && key != BACKSPACE) {
    endInput = true;
    addToLeaderboard(name, score);
  } else if (!endInput) {
    if (key == BACKSPACE) {
      fill(255);
      noStroke();
      if (i >= 0)
        rect(217 + (i * 14), 369, 16, 16);
      if (name.length() > 0) {
        name = name.substring(0, name.length() - 1);
      }
      if (i > 0) {
        i--;
      }
    }
    if (key != BACKSPACE && inAlphabet(key)) {
      fill(0);
      text(key, 230 + (i * 15), 380);
      name += key;
      i++;
    }
  }
}

void addToLeaderboard(String name, int score) {
  ArrayList < Person > people = new ArrayList < Person > ();

  String[] names = loadStrings("names.txt");
  String[] scores = loadStrings("scores.txt");
  for (int i = 0; i < names.length; i++) {
    people.add(new Person(names[i], Integer.parseInt(scores[i])));
  }

  people.add(new Person(name, score));
  Collections.sort(people);

  String[] newNames = new String[1];
  String[] newScores = new String[1];

  if (people.size() > 2) {
    newNames = new String[3];
    newScores = new String[3];
    for (int i = 0; i < 3; i++) {
      newNames[i] = people.get(i).returnName();
      newScores[i] = String.valueOf(people.get(i).returnScore());
    }
  } else if (people.size() == 2) {
    newNames = new String[2];
    newScores = new String[2];
    for (int i = 0; i < 2; i++) {
      newNames[i] = people.get(i).returnName();
      newScores[i] = String.valueOf(people.get(i).returnScore());
    }
  } else if (people.size() == 0) {
    newNames = new String[0];
    newScores = new String[0];
    for (int i = 0; i < 1; i++) {
      newNames[i] = people.get(i).returnName();
      newScores[i] = String.valueOf(people.get(i).returnScore());
    }
  }
  saveStrings("names.txt", newNames);
  saveStrings("scores.txt", newScores);

  displayLeaderboard(newScores, newNames);
}

void displayLeaderboard(String[] newScores, String[] newNames) {
  image(loadImage("yellowSnake.png"), 0, 0);
  fill(0);
  textSize(20);
  text("Leaderboard:", 190, 350);
  textSize(16);
  for (int i = 0; i < newScores.length; i++) {
    text(newNames[i] + ":", 210, 380 + (i * 20));
    text(newScores[i], 272, 380 + (i * 20));
  }
}

boolean inAlphabet(char c) {
  char[] alphabet = {
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z'
  };
  boolean found = false;
  for (char ch: alphabet) {
    if (ch == c) {
      found = true;
    }
  }
  return found;
}

void mousePressed() {
  for (int i = 0; i < checkBoxes.length; i++) {
    checkBoxes[i].click();
  }
}

class Person implements Comparable < Person > {
  String name;
  int score;

  Person(String name, int score) {
    this.name = name;
    this.score = score;
  }

  int returnScore() {
    return score;
  }

  String returnName() {
    return name;
  }

  int compareTo(Person another) {
    int compareScore = ((Person) another).returnScore();
    return compareScore - this.score;
  }
}

class Fruit {
  float x, y, xSpeed = random(-2, 2), ySpeed = random(-2, 2);
  PImage img;
  boolean draw = true;

  Fruit(float x, float y, PImage img) {
    this.x = x;
    this.y = y;
    this.img = img;
  }

  boolean getDraw() {
    return draw;
  }

  PImage getImg() {
    return img;
  }

  void setDraw(boolean draw) {
    this.draw = draw;
  }

  int getX() {
    return (int) x;
  }

  int getY() {
    return (int) y;
  }

  void setXYIS(float x, float y, PImage img, float xSpeed, float ySpeed) {
    this.x = x;
    this.y = y;
    this.img = img;
    this.xSpeed = xSpeed;
    this.ySpeed = ySpeed;
  }

  void move() {
    if (x >= width || x <= 0) {
      xSpeed *= -1;
    }
    if (y >= height || y <= 0) {
      ySpeed *= -1;
    }
    x += xSpeed;
    y += ySpeed;
  }
}

class Checkbox {
  float x, y;
  boolean checked;
  color c = color(255);
  int size = 12;

  Checkbox(float x, float y) {
    this.x = x;
    this.y = y;
    checked = false;
  }

  void displayCheckBox() {
    if (options) {
      stroke(0);
      fill(c);
      rect(x, y, size, size);
      if (checked) {
        line(x + (size / 4), y + (size / 2), x + (size / 2.7), y + (size / 1.3));
        line(x + (size / 2.7), y + (size / 1.3), x + (size / 1.1), y + (size / size));
      }
    }
  }

  void click() {
    if (mouseX > x && mouseX < x + 20 && mouseY > y && mouseY < y + 20) {
      checked = !checked;
    }
  }

  boolean getChecked() {
    return checked;
  }

  void setColor(color c) {
    this.c = c;
  }

  color getColor() {
    return c;
  }

  void setChecked(boolean checked) {
    this.checked = checked;
  }

  float getX() {
    return x;
  }

  float getY() {
    return y;
  }
}