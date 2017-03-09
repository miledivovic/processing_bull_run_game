import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minim;

AudioPlayer pauseScreenMusic;
AudioPlayer pauseScreenSelect;
AudioPlayer moo;
AudioPlayer gameMusic;
AudioPlayer escapedCowboy;
AudioPlayer trampledCowboy;

int playerX;
int playerY;
int computerX;
int computerY;
int playerSpeed;
int computerSpeed;
boolean[] keys = new boolean[4];
boolean isPaused;
int playerScore;
int computerScore;
long startTime;
long elapsedTime;
boolean firstGameStart;
boolean firstPause;
PImage backgroundImage;
PImage bull_down;
PImage bull_downLeft;
PImage bull_downRight;
PImage bull_left;
PImage bull_right;
PImage bull_up;
PImage bull_upLeft;
PImage bull_upRight;
PImage cowboy_down;
PImage cowboy_downLeft;
PImage cowboy_downRight;
PImage cowboy_left;
PImage cowboy_right;
PImage cowboy_up;
PImage cowboy_upLeft;
PImage cowboy_upRight;
PImage raging_bull;





void setup() {
  size(800, 800);
  
  
  minim = new Minim(this);
  
  pauseScreenMusic = minim.loadFile("assets/pauseScreenMusic.mp3");
  pauseScreenSelect = minim.loadFile("assets/pauseScreenSelect.mp3");
  moo = minim.loadFile("assets/moo.mp3");
  gameMusic = minim.loadFile("assets/gameMusic.mp3");
  escapedCowboy = minim.loadFile("assets/escapedCowboy.mp3");
  trampledCowboy = minim.loadFile("assets/trampledCowboy.mp3");
  
  
  backgroundImage = loadImage("assets/desert.jpg");
  bull_down = loadImage("assets/bull_down.png");
  bull_downLeft = loadImage("assets/bull_downLeft.png");
  bull_downRight = loadImage("assets/bull_downRight.png");
  bull_left = loadImage("assets/bull_left.png");
  bull_right = loadImage("assets/bull_right.png");
  bull_up = loadImage("assets/bull_up.png");
  bull_upLeft = loadImage("assets/bull_upLeft.png");
  bull_upRight = loadImage("assets/bull_upRight.png");
  cowboy_down = loadImage("assets/cowboy_down.png");
  cowboy_downLeft = loadImage("assets/cowboy_downLeft.png");
  cowboy_downRight = loadImage("assets/cowboy_downRight.png");
  cowboy_left = loadImage("assets/cowboy_left.png");
  cowboy_right = loadImage("assets/cowboy_right.png");
  cowboy_up = loadImage("assets/cowboy_up.png");
  cowboy_upLeft = loadImage("assets/cowboy_upLeft.png");
  cowboy_upRight = loadImage("assets/cowboy_upRight.png");
  raging_bull = loadImage("assets/raging_bull.jpg");
  
  
  firstGameStart = true;
  firstPause = true;
  isPaused = true;
  playerScore = 0;
  computerScore = 0;
  playerSpeed = 8;

  computerX = 400;
  computerY = 400;
  randomStart();
}

void draw() {
  if (isPaused) {
    pauseScreen();
  } else {
    isFirstGame();
    
    drawBackground();
    playerMove();
  
    reposition();
    computerMove();
  
    distributePoints();
    
  
    screenText();
  }
  
}

void isFirstGame() {
  if (firstGameStart) {
      gameMusic.rewind();
      gameMusic.play();
      firstGameStart = false;
    }
}

void screenText() {
  elapsedTime = (millis() - startTime) / 1000;
  textSize(14);
  textAlign(LEFT);
  fill(255);
  text("# of cowboys trampled: " + playerScore, 20, 20);
  text("# of escaped cowboys: " + computerScore, 20, 40);
  text("Time played: " + elapsedTime + "s", 20, 60);
  text("Use WASD to Move", 670, 20);
}

void drawBackground() {
  image(backgroundImage, 0, 0, 800, 800);
}

void pauseScreen() {
   if (firstPause) {
      pauseScreenMusic.rewind();
      pauseScreenMusic.play();
      firstPause  = false;
    }
    
    image(raging_bull, 0, 0, 800, 800);
    
    
    fill(255);
    textSize(42);
    textAlign(CENTER);
    text("Select Difficulty Level", 400, 75);
    if (mouseX > 250 && mouseX < 550 && mouseY > 125 && mouseY < 225) {
      fill(255, 200);
      cursor(HAND);
      if (mousePressed) {
        computerSpeed = 1;
        isPaused = false;
        cursor(ARROW);
        pauseScreenMusic.pause();
        pauseScreenSelect.rewind();
        pauseScreenSelect.play();
        startTime = millis();
      }
    } else {
      fill(255, 150);
      cursor(ARROW);
    }
    rect(250, 125, 300, 100, 30);
    if (mouseX > 250 && mouseX < 550 && mouseY > 250 && mouseY < 350) {
      fill(255, 200);
      cursor(HAND);
      if (mousePressed) {
        computerSpeed = 2;
        isPaused = false;
        cursor(ARROW);
        pauseScreenMusic.pause();
        pauseScreenSelect.rewind();
        pauseScreenSelect.play();
        startTime = millis();
      }
    } else {
      fill(255, 150);
    }
    rect(250, 250, 300, 100, 30);
    if (mouseX > 250 && mouseX < 550 && mouseY > 375 && mouseY < 475) {
      fill(255, 200);
      cursor(HAND);
      if (mousePressed) {
        computerSpeed = 3;
        isPaused = false;
        cursor(ARROW);
        pauseScreenMusic.pause();
        moo.rewind();
        moo.play();
        startTime = millis();
      }
    } else {
      fill(255, 150);
    }
    
    rect(250, 375, 300, 100, 30);
    fill(255, 0, 0);
    text("EASY", 400, 190);
    text("HARD", 400, 315);
    text("MOO", 400, 440);
    
    
    
}


void playerMove() {
  // allow for diagonal movement with simultaneous keypresses
  if (keys[0]) {
    playerY -= playerSpeed;
  }

  if (keys[1]) {
    playerX -= playerSpeed;
  }

  if (keys[2]) {
    playerY += playerSpeed;
  }

  if (keys[3]) {
    playerX += playerSpeed;
  }
  
  if (keys[0] && keys[1]) {
    image(bull_upLeft, playerX, playerY, 75, 75);
  } else if (keys[0] && keys[3]) {
    image(bull_upRight, playerX, playerY, 75, 75);
  } else if (keys[0]) {
    image(bull_up, playerX, playerY, 75, 75);
  } else if (keys[2] && keys[1]) {
    image(bull_downLeft, playerX, playerY, 75, 75);
  } else if (keys[2] && keys[3]) {
    image(bull_downRight, playerX, playerY, 75, 75);
  } else if (keys[2]) {
    image(bull_down, playerX, playerY, 75, 75);
  } else if (keys[1]) {
    image(bull_left, playerX, playerY, 75, 75);
  } else if (keys[3]) {
    image(bull_right, playerX, playerY, 75, 75);
  } else {
    image(bull_right, playerX, playerY, 75, 75);
  }
}


void keyPressed() {
  if (key == 'w') {
    keys[0] = true;
  }

  if (key == 'a') {
    keys[1] = true;
  }

  if (key == 's') {
    keys[2] = true;
  }

  if (key == 'd') {
    keys[3] = true;
  }
}

void keyReleased() {
  if (key == 'w') {
    keys[0] = false;
  }

  if (key == 'a') {
    keys[1] = false;
  }

  if (key == 's') {
    keys[2] = false;
  }

  if (key == 'd') {
    keys[3] = false;
  }
}

//always move the computer away from player
void computerMove() {
  if (playerX > computerX) {
    computerX -= computerSpeed;
  } else if (playerX < computerX) {
    computerX += computerSpeed;
  }

  if (playerY > computerY) {
    computerY -= computerSpeed;
  } else if (playerY < computerY) {
    computerY += computerSpeed;
  }
  
  
  if (playerX > computerX && playerY > computerY) {
    computerX -= computerSpeed;
    computerY -= computerSpeed;
    image(cowboy_upLeft, computerX, computerY, 75, 75);
  } else if (playerX > computerX && playerY < computerY) {
    computerX -= computerSpeed;
    computerY += computerSpeed;
    image(cowboy_downLeft, computerX, computerY, 75, 75);
  } else if (playerX > computerX) {
    computerX -= computerSpeed;
    image(cowboy_left, computerX, computerY, 75, 75);
  } else if (playerX < computerX && playerY > computerY) {
    computerX += computerSpeed;
    computerY -= computerSpeed;
    image(cowboy_upRight, computerX, computerY, 75, 75);
  } else if (playerX < computerX && playerY < computerY) {
    computerX += computerSpeed;
    computerY += computerSpeed;
    image(cowboy_downRight, computerX, computerY, 75, 75);
  } else if (playerX < computerX) {
    computerX += computerSpeed;
    image(cowboy_right, computerX, computerY, 75, 75);
  } else if (playerY > computerY) {
    computerY -= computerSpeed;
    image(cowboy_up, computerX, computerY, 75, 75);
  } else if (playerY < computerY) {
    computerY += computerSpeed;
    image(cowboy_down, computerX, computerY, 75, 75);
  }
}
//wrap player character around edges
void reposition() {
  if (playerX > width) {
    playerX = playerX - width;
  } else if (playerX < 0) {
    playerX = playerX + width;
  }

  if (playerY > height) {
    playerY = playerY - height;
  } else if (playerY < 0) {
    playerY = playerY + height;
  }
}
// calculate who won the game and distribute points accordingly
void distributePoints() {
  if ( abs((playerX - computerX)) <= 30 && abs((playerY - computerY)) <= 30) {
    trampledCowboy.rewind();
    trampledCowboy.play();
    playerScore++;
    newGame();
  } else if ( computerX < 0 || computerX > width || computerY < 0 || computerY > height) {
    escapedCowboy.rewind();
    escapedCowboy.play();
    computerScore++;
    newGame();
  }
}
//start a new game
void newGame() {
  for (int i = 0; i < 4; i++) {
    keys[i] = false;
  }
  randomStart();
  computerX = 400;
  computerY = 400;
}
//determine which of 4 sides to start the player at
void randomStart () {
  float x = random(4);
  if (x < 1) {
    image(bull_down, 400, 50, 75, 75);
    playerX = 400;
    playerY = 50;
  } else if (x < 2) {
    image(bull_left, 750, 400, 75, 75);
    playerX = 750;
    playerY = 400;
  } else if (x < 3) {
    image(bull_up, 400, 750, 75, 75);
    playerX = 400;
    playerY = 750;
  } else if (x < 4) {
    image(bull_right, 50, 400, 75, 75);
    playerX = 50;
    playerY = 400;
  }
}

