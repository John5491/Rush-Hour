import java.util.*; 
import java.lang.*; 
private static char [][] grid = new char[6][6];
public class Vehicle{
    public char CAR_ID[]= new char[]{'X','A','B','C','D','E','F','G','H','I','J','K'};
    public char TRUCK_ID[] = new char[]{'O','P','Q','R'};
    private char id;
    private char orientation;
    private int x, y, length;
    private int x_end,y_end;
    private color Color;
    public Vehicle(){}
    public Vehicle( char id, int x,int y,char orientation){
        Color = color(0,123,123);
        //Color = color((int)random(0,255),(int)random(0,255),(int)random(0,255));
        for(int i = 0;i < 12; i++){
            if(id == CAR_ID[i]){
                this.id = id;
                this.length = 2;
                break;
            } else if(i <= 3 && id == TRUCK_ID[i]){
                this.id = id;
                this.length = 3;
                break;
            }
        }
        if(0 <= x && x <= 5){
            this.x = x;
        } else {
            System.exit(1);
        }
        if(0 <= y && y <= 5){
            this.y = y;
        }
        
        if(orientation == 'H'){
            this.orientation = orientation;
            x_end = this.x + (this.length - 1);
            y_end = this.y;
        } else if(orientation == 'V'){
            this.orientation = orientation;
            x_end = this.x;
            y_end = this.y + (this.length - 1);
        }
        
        if(x_end > 5 || y_end > 5){
            System.out.println("Invalid configuration");
            System.exit(1);
        }
        fillGrid();
        
    }
    public void fillGrid(){
       grid[getX()][getY()] = this.id;
       grid[getX_end()][getY_end()] = this.id;
       if(length == 3 && orientation == 'V'){
           grid[getX()][getY() + 1] = this.id;
       }
       if(length == 3 && orientation == 'H'){
           grid[getX() + 1][getY()] = this.id;
       }
    }
    public void setGrid(){
        for(int i = 0;i < 6; i++){
           for(int j = 0;j < 6; j++){
                grid[i][j] = ' ';
            }
        }
    }
    public int getX(){
        return this.x;
    }
    public int getY(){
        return this.y;
    }
    public int getX_end(){
        return this.x_end;
    }
    public int getY_end(){
        return this.y_end;
    }
    public char getID(){
        return this.id;
    }
    public char getOrientation(){
        return this.orientation;
    }
    public void display(){
        fill(Color);
        if(this.id == 'X'){
            fill(0);
        }
        if(orientation == 'H'){
            rect(getX()*70,getY()*70,(length)*70,(getY_end() + 1)*70 - getY()*70);
            fill(255);
            textSize(36);
            text(this.id, getX()*70 + (length/2)*70, getY()*70 + 50);
            //System.out.printf("%d, %d\n",(getX_end() + 1 - getX())*35, (getY() + 1)*35);
        }
        if(orientation == 'V'){
            rect(getX()*70,getY()*70,(getX_end() + 1)*70 - getX()*70,(length)*70 );
            fill(255);
            textSize(36);
            text(this.id, getX()*70 + 25,getY()*70 + (length/2)*70);
            //System.out.printf("%d, %d, %d, %d\n",getX()*70,getY()*70,(getX() + 1)*70,(getY() + 2)*70);
        }
    }
    public void FillColor(int r,int g,int b){
        fill(r,g,b);
    }
    public boolean clickOnRec(int mouseX, int mouseY){
        if(this.orientation == 'V'){
            if(mouseX < (getX_end() + 1)*70 && mouseX > getX()*70 && mouseY < (getY_end()+1)*70 && mouseY > getY()*70){
                return true;
            }
        }
        else if(this.orientation == 'H'){
            if(mouseX < (getX_end()+1)*70 && mouseX > getX()*70 && mouseY < (getY_end()+1)*70 && mouseY > getY()*70){
                return true;
            }
        }

        return false;
    }
    public void moveUP(){
        if(y*70 <= height && y > 0){
            if(grid[x][y - 1] == ' '){
                grid[x][y - 1] = getID();
                this.y = this.y - 1;
                grid[x_end][y_end] = ' ';
                this.y_end = this.y_end - 1;
            }
            
        }
    }
    public void moveDOWN(){
        if((y_end + 1) * 70 < 420 && y_end > 0){
            if(grid[x_end][y_end + 1] == ' '){
                grid[x_end][y_end + 1] = getID();
                this.y_end = this.y_end + 1;
                grid[x][y] = ' ';
                this.y = this.y + 1;
            }
            
        }
    }
    public void moveLEFT(){
        if(x*70 < width && x > 0){
            if(grid[x - 1][y] == ' '){
                grid[x - 1][y] = getID();
                this.x = this.x - 1;
                grid[x_end][y_end] = ' ';
                this.x_end = this.x_end - 1;
            }
            
        }
    }
    public void moveRIGHT(){
         if((x_end + 1)*70 < width && x_end > 0){
            if(grid[x_end + 1][y_end] == ' '){
                grid[x_end + 1][y_end] = getID();
                this.x_end = this.x_end + 1;
                grid[x][y] = ' ';
                this.x = this.x + 1;
            }
            
        }
    }
}
