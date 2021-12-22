public class Tab
{
    private int x;
    private int y;
    private String name;
    public Tab(){}
    public Tab(String name, int x, int y)
    {
        this.name = name;
        this.x = x;
        this.y = y;
    }
    
    public int getx()
    {
        return x;
    }
    
    public int gety()
    {
        return y;
    }
    public String getn()
    {
        return name;
    }
    
    public boolean clickOnTab(int mouseX, int mouseY)
    {  
        if(mouseX >= x - 50 && mouseX<= x + 90 && mouseY >= y && mouseY <= y + 40)
            return true;
        return false;
    }
    public boolean clickOnLvl(int mouseX, int mouseY)
    {  
        if(mouseX >= x && mouseX<= x + 40 && mouseY >= y && mouseY <= y + 40)
            return true;
        return false;
    }
    public boolean clickOnBack(int mouseX, int mouseY)
    {  
        if(mouseX >= x && mouseX<= x + 70 && mouseY >= y && mouseY <= y + 40)
            return true;
        return false;
    }
        public boolean clickOnAI(int mouseX, int mouseY)
    {  
        if(mouseX >= x && mouseX<= x + 70 && mouseY >= y && mouseY <= y + 40)
            return true;
        return false;
    }
}
