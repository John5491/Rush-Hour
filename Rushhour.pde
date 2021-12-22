import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;

//Initialise variable
List<String> lines = new ArrayList<String>();
Vehicle []v = new Vehicle[20];
Vehicle selected;

//Count for buffer reader
int i = 1;

//Count to control the iteration speed of moving blocks
int c = 0;

int x, y, tempX, tempY;
String name, filename, line;
color col;

//Boolean to control different view
boolean back, isMenu, gameStarted, run;

//Buttons
Tab AI;
Tab []tab = new Tab[3];
Tab tabselected;
Tab []levels = new Tab[40];
Tab lvlselected;
Tab BackButton;

void setup() {
    size(420, 500);
    //Initialize all buttons
    tab[0] = new Tab("Play", width/2 - 20, height/4 - 20);
    tab[1] = new Tab("How To Play", width/2 - 20, height/2 - 20);
    tab[2] = new Tab("About", width/2 - 20, height/4 * 3 - 20);
    BackButton = new Tab("Back", 10, height - 50);
    AI = new Tab("AI", 340, height - 50);
  
    //Initialize menu page
    back = true;
    isMenu = true;
    gameStarted = false;
    tempX = 10;
    tempY = 80;
    
    //Initialize level button
    for (int i=0; i<40; i++)
    {
        levels[i] = new Tab(Integer.toString(i + 1), tempX, tempY);
        tempX += 50;
        if (i == 7 || i == 15 || i == 23 || i == 31)
        {
            tempX = 10;
            tempY += 50;
        }
    }
}

void draw()
{
    background(255, 100, 255);
    col = color(int(random(255)), int(random(255)), int(random(255)));
    if(gameStarted)
        proceedgame();
    else{
        //Draw 3 button
        for (int i=0; i<3; i++)
        {
            x = tab[i].getx();
            y = tab[i].gety();
            name = tab[i].getn();
            fill(255);
            rect(x - 50, y, 140, 40);
            fill(0);
            textSize(20);
            
            text(name, 115 + (x - textWidth(name))/2, y + 28);
            
            if (tabselected != null && tabselected.getn() != "Back")
            {
                x = tabselected.getx();
                y = tabselected.gety();
                name = tabselected.getn();
                fill(col);
                rect(x, y, 40, 40);
                fill(0);
                textSize(20);
                text(name, x + 15, y + 25);
            }
        }
        //If button is selected
        if (tabselected != null)
        {
            if (tabselected.getn() == "Play")
                play();
            if (tabselected.getn() == "How To Play")
                howtoplay();
            if (tabselected.getn() == "About")
                about();
        }
    }
}

void play()
{
    background(255, 100, 100);
    fill(255);
    textSize(20);
    text("Select a level:", 10, 40);
    fill(255);
    //Draw all level buttons
    for (int i=0; i<40; i++)
    {
        x = levels[i].getx();
        y = levels[i].gety();
        name = levels[i].getn();
        fill(255);
        rect(x, y, 40, 40);
        textSize(20);
        fill(0);
        text(name,x + 34 - textWidth(name), y + 25);
        if (lvlselected != null)
        {
            x = lvlselected.getx();
            y = lvlselected.gety();
            name = lvlselected.getn();
            fill(col);
            rect(x, y, 40, 40);
            fill(0);
            textSize(20);
            text(name, x + 15, y + 25);
            filename = "/data/p" + lvlselected.getn() + ".txt";
            if (!gameStarted)
                startupgame(filename);
        }
    }
    fill(255);
    rect(BackButton.getx(), BackButton.gety(), 70, 40);
    fill(0);
    textSize(20);
    text(BackButton.getn(), BackButton.getx() + 15, BackButton.gety() + 25);
}

void howtoplay()
{
    background(0);
    fill(255);
    textSize(20);
    text("Instruction:\n- Click on any block to select it.\n- Use arrow up, down, left, right to move \n the block.\n- Press AI button for auto complete.", 10, 40);
    fill(255);
    rect(BackButton.getx(), BackButton.gety(), 70, 40);
    fill(0);
    textSize(20);
    text(BackButton.getn(), BackButton.getx() + 15, BackButton.gety() + 25);
}

void about()
{
    background(0);
    fill(255);
    textSize(20);
    text("Developed by:\nIsaiah Tang Yue Sun\nGoh Yi Fan\nKheng Siong Juan", 10, 40);
    fill(255);
    rect(BackButton.getx(), BackButton.gety(), 70, 40);
    fill(0);
    textSize(20);
    text(BackButton.getn(), BackButton.getx() + 15, BackButton .gety() + 25);
}

void startupgame(String file)
{
     //Use command to execute rushhour.py
     try{
            String s = null;
            String command = "python " + sketchPath() + "/rushhour.py " + sketchPath() +"/data/p" + lvlselected.getn() + ".txt" ;
            Process p = Runtime.getRuntime().exec(command);
            BufferedReader in = new BufferedReader(new InputStreamReader(p.getInputStream()));
            while((s = in.readLine()) != null){
                //System.out.println(s);
            }
       } catch (IOException e) {
            e.printStackTrace();
       }
      for (int j = 0; j < 6; j++) {
          for (int k = 0; k < 6; k++) {
              grid[j][k] = ' ';
          }
      }
      //Load the problem file
      BufferedReader reader;
      try {
          reader = createReader(sketchPath() + file);
          lines.add(reader.readLine());
          while ((line = reader.readLine()) != null) {
              lines.add(line);
              //System.out.println(lines);
              i++;
          }
          for (int j = 0; j < i; j++) {
              //Initialise all vehicle
              v[j] = new Vehicle(lines.get(j).charAt(0), (Character.getNumericValue(lines.get(j).charAt(1))), (Character.getNumericValue(lines.get(j).charAt(2))), lines.get(j).charAt(3));
          }
          lines.clear();
          reader.close();
      } 
      catch (IOException e) {
          e.printStackTrace();
      }
      //Load the solution.txt produced by the rushhour.py
      BufferedReader reader2;
      try {
          reader2 = createReader(System.getProperty("user.dir") + "/Solution.txt");
          lines.add(reader2.readLine());
          while ((line = reader2.readLine()) != null) {
            lines.add(line);
            //System.out.println(lines);
          }
          reader2.close();
      } 
      catch (IOException e) {
          e.printStackTrace();
      }
      gameStarted = true;
}

void proceedgame()
{
    background(255);
    stroke(0);
    strokeWeight(1);
    for (int j = 0; j < i; j++) {
        v[j].display();
    }
    for (int j = 0; j < 6; j++) {
        for (int k =0; k < 6; k++) {
            //System.out.print(grid[j][k]);
          }
        //System.out.print("\n");
    }
    if (run) {
        //Slow down the movement of the blocks, easier to see the movement
        try {
          Thread.sleep(100);
        } 
        catch (InterruptedException ex) {
        }
        if (c < lines.size()) {
            for (int k = 0; k < i; k++) {
                if (v[k].getID() == lines.get(c).charAt(0)) {
                    if (lines.get(c).charAt(1) == 'U') {
                      v[k].moveUP();
                    }
                    if (lines.get(c).charAt(1) == 'D') {
                      v[k].moveDOWN();
                    }
                    if (lines.get(c).charAt(1) == 'R') {
                      v[k].moveRIGHT();
                    }
                    if (lines.get(c).charAt(1) == 'L') {
                      v[k].moveLEFT();
                    }
                }
            }
        }
        c++;
    }
    //If goal sate, displat won
    if(grid[5][2] == 'X'){
        String won = "You Won!!!";
        fill(color(255,0,0));
        rect(0,175,420,70);
        fill(255);
        text(won,(240 - textWidth(won)/2) - 30,220);
    }
    fill(255);
    rect(BackButton.getx(), BackButton.gety(), 70, 40);
    rect(AI.getx(),AI.gety(), 70, 40);
    fill(0);
    textSize(20);
    text(BackButton.getn(), BackButton.getx() + 15, BackButton.gety() + 25);
    text(AI.getn(), AI.getx() + 25, AI.gety() + 25);
    stroke(12);
    strokeWeight(5);
    line(0,0,420,0);
    line(0,0,0,420);
    line(0,420,420,420);
    line(420,0,420,140);
    line(420,210,420,420);
    stroke(0);
    strokeWeight(1);
}

void mousePressed()
{
    System.out.printf("%d, %d\n", mouseX, mouseY);
    if (BackButton.clickOnBack(mouseX, mouseY) && !isMenu && !gameStarted)
    {
        tabselected = BackButton;
        System.out.println(tabselected.getn());
        isMenu = true;
        lvlselected = null;
    } else if (isMenu && !gameStarted) {
        for (int j = 0; j < 3; j++) {
            if (tab[j].clickOnTab(mouseX, mouseY))
            {
                tabselected = tab[j];
                isMenu = false;
                System.out.println(tabselected.getn());
            }
        }
    } else if (!isMenu && tabselected.getn() == "Play" && !gameStarted) {
        for (int i=0; i<40; i++)
        {
            if (levels[i].clickOnLvl(mouseX, mouseY))
            {
                lvlselected = levels[i];
                System.out.println(lvlselected.getn());
            }
        }
    } else if (gameStarted) {
        System.out.printf("%d, %d\n", mouseX, mouseY);
        for (int j = 0; j < i; j++) {
           if (v[j].clickOnRec(mouseX, mouseY)) {
              selected = v[j];
              System.out.println(selected.getID());
            }
            if(AI.clickOnAI(mouseX,mouseY)){
                run = true;
            }
            if(BackButton.clickOnBack(mouseX, mouseY)){
                tabselected = tab[0];
                v = new Vehicle[20];
                i = 1;
                c = 0;
                lines.clear();
                isMenu = false;
                lvlselected = null;
                gameStarted = false;
                run = false;
            }
        }
    } 
}
void keyPressed(){
    System.out.println(keyCode);
    if(keyCode == UP && selected.getOrientation() == 'V'){
        System.out.println("UP");
        selected.moveUP();
    }
    if(keyCode == DOWN && selected.getOrientation() == 'V'){
        selected.moveDOWN();
    }
    if(keyCode == LEFT && selected.getOrientation() == 'H'){
        selected.moveLEFT();
    }
    if(keyCode == RIGHT && selected.getOrientation() == 'H'){
        selected.moveRIGHT();
    }
}
