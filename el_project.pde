import gab.opencv.*;
import java.awt.Rectangle;
import processing.video.*;
Capture cam;

OpenCV opencv;

Rectangle[] faces; //open cv datatype? ellipse maybe would be better

float Player1xAxis, Player1yAxis, Player2xAxis, Player2yAxis;
int fakefacex, fakefacey, correctnumberoffaces, chosenfilter;
boolean takeThePicture, lock1Y, facesfound, correctsize, numberoffaces, filterchosen;
PImage firstFace, secondFace;
int[] face1= {0, 0, 0, 0, 0, 0, 0, 0};
void camerasetup() {
  cam = new Capture(this, 640, 480, 30);
  cam.stop();
  cam.start();
}
void opencvsetup() {
  opencv = new OpenCV(this, 640, 480);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  faces = opencv.detect();
}
void checkfacesize(float numberofpixels1, float numberofpixels2) {
  if ((numberofpixels1/numberofpixels2 >0.8 && numberofpixels1/numberofpixels2 < 1.2) &&numberofpixels1 !=0 && numberofpixels2 !=0) {
    correctsize = true;
  } else {
    correctsize = false;
  }
}
void setfacepositions(int i, int a, int b, int c, int d) {
  face1[0+i] = a; 
  face1[1+i] = b; 
  face1[2+i] = c; 
  face1[3+i] = d;
}

void setup() {
  chosenfilter = 10;
  //setting up the camera
  fakefacex = 50;
  fakefacey = 50;
  camerasetup();

  size(1000, 1000);
  takeThePicture = false;
  correctsize = false;
  numberoffaces = false;

  //configuring opencv 
  opencvsetup();

  frameRate(60); //probably not needed because of opencv
}

void draw() {
  background(255);
  fill(0); 
  textSize(30);
  //check if swap conditons are correct
  if (correctsize == false) {
    background(255, 0, 0);
    text("Make sure your heads are a similar size!", 0, 600);
  }
  if (correctnumberoffaces != 2) {
    background(255, 0, 0);
    text("There must be 2 faces for the swap to work!", 0, 550);
    numberoffaces = false;
  } else {
    numberoffaces=true;
  }
  if (correctsize == true&& numberoffaces == true) {
    background(0, 255, 0);
    text("You can face swap! Press any key to take a photo and 'S' to swap faces.", 0, 600);
  }
  //filter buttons
  stroke(0);
  textSize(15);
  //decide if the picture should update or not 

  if (takeThePicture == false) { //check if camera should update or not
    opencv.loadImage(cam); //updates image
  } //writes in console the number of detected faces
  else {
    cam.stop();
  }
  image(cam, 0, 0 ); //prints image onto screen
  //decide if the image needs to be swapped
  if (facesfound == true) {
    image(secondFace, (face1[0]+face1[2]/2)-0.5*face1[6], (face1[1]+face1[3]/2)-0.5*face1[7]);
    image(firstFace, (face1[4]+face1[6]/2)-0.5*face1[2], (face1[5]+face1[7]/2)-0.5*face1[3]);
    takeThePicture = false;
  }
  noFill(); //settings for webcam
  stroke(0, 255, 0);//^
  strokeWeight(3);//^
  Rectangle[] faces = opencv.detect(); //refresh face dectection
  //rectangles on faces
  for (int i = 0; i < faces.length; i++) { // prints rect on faces
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    if (i==0) { //sets the size of the face to be moved.
      setfacepositions(0, int(faces[i].x), int(faces[i].y), int(faces[i].width), int(faces[i].height));
    }
    if (i==1) {
      setfacepositions(4, int(faces[i].x), int(faces[i].y), int(faces[i].width), int(faces[i].height));
    }
    //ellipse(faces[i].x+faces[i].width/2, faces[i].y+faces[i].height/2, faces[i].width-Player1yAxis+20, faces[i].height );
  }
  float numberofpixels1 = face1[2]*face1[3];
  float numberofpixels2 = face1[6]*face1[7];
  checkfacesize(numberofpixels1, numberofpixels2);
  correctnumberoffaces = faces.length;
}
void keyPressed() {
  if (key=='q') { //quit
    cam.stop();
    exit();
  } else if (takeThePicture != true&& numberoffaces == true) { // stops the image updating if the photo is taken
    cam.stop();
    takeThePicture = true;
    textSize(30);
    text("Picture taken press s to swap faces!", 500, 50);
  }
  if (takeThePicture == true && key == 's') {
    // copy and paste the faces
    loadPixels();
    firstFace =get(face1[0]+2, face1[1]+2, face1[2]-4, face1[3]-4);
    secondFace = get(face1[4]+2, face1[5]+2, face1[6]-4, face1[7]-4);
    //secondFace = get(500,300,fakefacex,fakefacey);//remember to change all these values to the second face
    facesfound = true;
    image(secondFace, (face1[0]+face1[2]/2)-0.5*face1[6], (face1[1]+face1[3]/2)-0.5*face1[7]);
    image(firstFace, (face1[4]+face1[6]/2)-0.5*face1[2], (face1[5]+face1[7]/2)-0.5*face1[3]);
  }
}

void mousePressed() {
}

void mouseDragged() {
}

void mouseRelased() {
}


void captureEvent(Capture c) { //automatically updates camera image when it is able to update.
  c.read();
}