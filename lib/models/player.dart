class Player {
  double x = 600;
  double y = 200;

  void moveLeft() {
    x -= 10;
  }

  void moveRight() {
    x += 10;
  }

  void moveUp() {
    y -= 10;
  }

  void moveDown() {
    y += 10;
  }
}
