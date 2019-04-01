class Card
{
    private CardType type;
    private String value;
    private PImage image;
    private PImage backImage;
    private PVector pos;
    private PVector size;
    private boolean drawn;
    private int actualValue;
    private color cardColor = 255;
    private float transparency = 255;
   

    Card(CardType newType, String newValue, String path){
        type = newType;
        value = newValue;
        image = loadImage(path);
        backImage = loadImage("back.png");
        size = new PVector(100,200);
        actualValue = setActualValue(value);
    }

    public CardType getType(){
        return type;
    }
    public String getValue(){
        return value;
    }
    public int getActualValue(){
        return actualValue;
    }
    public PVector getPosition(){
      return pos;
    }
    public PVector getSize(){
      return size;
    }
    public PImage getImage(){
        return  image;
    }
    public float getTransparency(){
      return transparency;
    }
    public void setPosition(PVector newPos){
    pos = newPos;
    }
    
    public void setDrawn(boolean newState){
      if(newState)
      drawn = true;
      else
      drawn = false;
    }
    public void setTransparency(float trans){
      transparency = trans;
    }
    void update(){
    
    }
    
    void display(){
      push();
      image(backImage, pos.x, pos.y, size.x,size.y);
      if(drawn){
      tint(cardColor, transparency); 
      image(image, pos.x,pos.y, size.x, size.y);
      }
      pop();
    }
    
    private int setActualValue(String cardValue)
    {
      if(cardValue.contains("2"))
      return 15;
      if(cardValue.contains("ace")) 
      return 14;
      else if(cardValue.contains("king")) 
      return 13;
      else if(cardValue.contains("queen"))
      return 12;
      else if(cardValue.contains("jack"))
      return 11;
      else if(cardValue.contains("joker"))
      return 0;
      else
      return Integer.parseInt(cardValue);
    }
    
    private void setVelocity(PVector position){
    }
}
