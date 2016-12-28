/**
 * Recursive Tree
 * by Daniel Shiffman.  
 * 
 * Renders a simple tree-like structure via recursion. 
 * The branching angle is calculated as a function of 
 * the horizontal mouse location. Move the mouse left
 * and right to change the angle.
 */
 
 /*
 For the total count of leveles in the tree, we count starting from 1. 
 For the arrays we count starting from 0. Odd, right?, correct is necessary 
 */
 
// TODO, too many casts, fix this as soon as you check its ok to do it. 
float theta; 
//float thickness            = 10;
int   levels                 = 10;  // levels of branches 
int   levelsToDraw           = 10;
float sizeMainBranch         = 150;
float sizeMainBranchAxon     = 50;
float initialThicknessProximal =  11;
float initialThicknessDistal = 11;
float distance               = sizeMainBranch; // The length of the longest branch;
int numberDendriteProximal   = 0;   // Number of the dendrite that will have a spark
int numberDendriteDistal     = 0;
int currentLevel             = 0;   // TODO: see if can be replace with "level"
int sparkSpeed               = 10;
int numberSparks             = 0;


int  [] repeatedThetaCounter = new int   [levels];                         // Aux value to repeat thetas in next matrix
int  [] repeatedThetaCounter2= new int   [levels];                         // Aux value to repeat thetas in next matrix
float[][] thetas             = new float [levels] [int(pow(2,levels-1))];  // Store a matrix of thethas for each branching node. Distal Dendrites
float[][] thetas0            = new float [levels] [int(pow(2,levels-1))];  // Store a matrix of thethas for each branching node. Proximal Dendrites

int   numberOfAngles         = int(pow(2.0,levels) - 2.0);

float thicknessDecrementProximal  = 0.75;
float thicknessDecrementDistal    = 0.55;
float lengthDecrement             = 0.76;

float tempDistance = 0;

float a = 0; // angle

boolean DRAWN       = false;
boolean SPARK       = false;
boolean STARTSPARK  = false;
boolean AXONSPARK   = false;
boolean DISTAL      = true;
boolean PROXIMAL    = false;
boolean RUN         = false;
boolean INIT        = false;

int widthScreen   = 940;                            // Simulated screen space
int heightScreen  = 660;                            // Simulated screen space

color black = #000000;
color blue  = #5B779B;  //91,119,155
color white = #FFFFFF;

Neuron neuron = new Neuron();
Spark  spark  = new Spark();

void setup() {
  size(1200, 960);
  frameRate (200);
}


void draw() {
  println(frameRate);
  if (DRAWN == false)                                   // Draw Neurons for the first time, only once. 
  { 
    background(0);
    neuron.drawNeuron(false, initialThicknessProximal, initialThicknessDistal);// All drawing algorithms, calls branch(...)
    DRAWN = true;    // Never come in here again
    RUN   = true;
  }
  
  if (RUN == true)
  {
    neuron.drawNeuron(true,initialThicknessProximal, initialThicknessDistal);
    RUN =  false; // Only draw when a spark has finished, otherwise the position matrix is messed up. TODO: fix
  }
  
  if (SPARK == true)                        // At the time this means If mouse has been clicked 
  {
    spark.proximalSpark(thetas0);
  }

  if(AXONSPARK == true)
  {
    int temp = 0;
    while(temp < 60){                       // 60 sparks at the same time
    spark.distalSpark();
    temp += 1;
    }
    SPARK = true;
  }
}

/*
Everytime the matrix is reset
*/
void moveToStartPosition()
{
  translate(width/2,height/2);               
  rotate(PI);                                          // Locate in the center of the canvas 
}


/*
Callback
*/
void mouseClicked()
{
  if(numberSparks >= 0)
  { 
    SPARK        = false;
    AXONSPARK    = true;      // Goes in the queue.
    numberSparks = 0;
  }
  else
  {
    
    SPARK      = true;                                   // Start a new spark drawing
    STARTSPARK = true;                                   // Enable the first part of the drawint only. TODO: maybe unnecesary 
  
    numberSparks += 1;
  }
}

/*
For Debugging purposes
*/
void printThetas(float[][] thetas)
{
  for( int i  = 0 ; i < levels; i++)
  {
    for( int j = 0 ; j < pow(2, levels-1); j ++)
    {
      if (thetas[i][j] > 0)  print(thetas[i][j] + "  " );  // Print the matrix with all angles/
      else                   print(thetas[i][j] + " "  );
    } 
    println("");
  }
}

void clearArray(int[] array){
  
  for (int i = 0 ;i < array.length; i++){
    array[i] = 0;
  }
}