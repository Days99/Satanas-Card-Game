class Card
{
    private int type;
    private String value;
    private PImage image;
    private PImage backImage;
    private PVector pos;
    private PVector size;
   

    Card(int newType, String newValue, String path){
        type = newType;
        value = newValue;
        image = loadImage(path);
        backImage = loadImage("back.png");
        size = new PVector(100,200);
    }

    public int getType(){
        return type;
    }
    public String getValue(){
        return value;
    }
    public PImage getImage(){
        return  image;
    }
    public void setPosition(PVector newPos){
    pos = newPos;
    }
    void update(){
    
    }
    
    void display(){
      image(backImage, pos.x, pos.y, size.x,size.y);
      image(image, pos.x,pos.y, size.x, size.y);
    }

}
