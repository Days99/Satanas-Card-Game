import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.*; 
import java.lang.*; 
import java.io.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Satanas extends PApplet {

 
 
 

ArrayList<Card> deck;
ArrayList<Player> players;
ArrayList<Card> selected;
ArrayList<Card> table;
Sort sort;
int state = 0;
boolean updateVisuals;
boolean played;

public void setup() {

  
  background(0);
  frameRate(60);
  deck = new ArrayList<Card>();
  players = new ArrayList<Player>();
  selected = new ArrayList<Card>();
  table = new ArrayList<Card>();
  sort = new Sort();
  //TODO get Absolute Path 
  File file = new File(dataPath("C:\\Users\\diogo\\Documents\\Processing\\Satanas-Card-Game\\Satanas\\data"));
  processFile(file);
}

public void draw() {
  if (players.size() > 0)
  {
    switch(state) {
    case 0:
      choseCards();
      break;
    case 1:
      startGame();
      break;
    }
  }
     println(frameRate);
}

public void startGame() {
  if(!updateVisuals)
  updateCardsGame();
  
  for (Card c : players.get(0).getHand()) {
    PVector cardPos = c.getPosition();
    PVector size = c.getSize();
    if (mouseX > cardPos.x && mouseX < cardPos.x + size.x && mouseY > cardPos.y && mouseY < cardPos.y + size.y) {
      if (mousePressed && !played){
      c.setTransparency(100);
      played = true;
      playCard(c);
      break;
      }
    }
  }
}

public void choseCards() {
  if(!updateVisuals)
  updateCardsStart();
  
  for (Card c : players.get(0).getHand()) {
    PVector cardPos = c.getPosition();
    PVector size = c.getSize();
    if (mouseX > cardPos.x && mouseX < cardPos.x + size.x && mouseY > cardPos.y && mouseY < cardPos.y + size.y) {
      if (mousePressed && !selected.contains(c)){
        selected.add(c);
        c.setTransparency(100);
        updateVisuals = false;
      }
    }
  }
  if(selected.size() > 2){
        Card[] cards = new Card[selected.size()];
        for(int i = 0; i < selected.size(); i++){
        cards[i] = selected.get(i);
        players.get(0).getHand().remove(selected.get(i));
        }
        players.get(0).setPlantedCards(cards);
        updateHandPosition(players.get(0).getHand());
        updateVisuals = false;
        state = 1;
  }
}

public void processFile(File selection) {
  String[] images = selection.list();
  ArrayList<String> cards = new ArrayList<String>();
  for (String s : images) 
    if (!s.contains("back"))
      cards.add(s);

  createDeck(cards);
}

public void createDeck(ArrayList<String> cardsFile) {
  for (int i = 0; i < cardsFile.size(); i++) {
    String cardString = cardsFile.get(i).split(".png")[0];
    if (!cardString.contains("joker")) {
      String value = cardString.split("_")[1];
      String type = cardString.split("_")[0];

      if (type.contains("clubs")) 
        deck.add(new Card(CardType.Club, value, cardsFile.get(i)));
      else if (type.contains("spades"))  
        deck.add(new Card(CardType.Spade, value, cardsFile.get(i)));
      else if (type.contains("hearts")) 
        deck.add(new Card(CardType.Heart, value, cardsFile.get(i)));
      else if (type.contains("diamonds")) 
        deck.add(new Card(CardType.Diamond, value, cardsFile.get(i)));
    } else
      deck.add(new Card(CardType.Joker, cardString, cardsFile.get(i)));
    processDeck();
  }
}

public void processDeck() {
  //Collections.sort(deck, sort);
  Collections.shuffle(deck);
  for (Card c : deck) {
    c.setPosition(new PVector(10 + c.getActualValue() * 5, 10 * c.getActualValue()));
  }
  if (deck.size() >= 54)
    createPlayer(deck, 0);
}

public void createPlayer(ArrayList<Card> cards, int numbP) {
  Card[] lastCards = new Card[3];
  ArrayList<Card> hand = new ArrayList<Card>() ;
  for (int i = 0; i < 10; i++) {   
    if (i < 3) {
      lastCards[i] = cards.get(i);
      cards.get(i).setPosition(new PVector((width/2 - 120) + (i * 120), height -200));
      cards.get(i).display();
      cards.remove(i);
    } else if (i > 2 && i < 9) {
      hand.add(cards.get(i));
      cards.remove(i);
    } else {   
      updateHandPosition(hand);
      players.add(new Player(hand, lastCards));
      break;
    }
  }
}

public void updateHandPosition(ArrayList<Card> newHand)
{
  for(int i = 0; i < newHand.size(); i++){
      newHand.get(i).setPosition(new PVector((width/2 - 420) + (i * 120), height -500));
      newHand.get(i).setDrawn(true);
  }
}

public void playCard(Card c){
  table.add(c);
  c.setPosition(new PVector(width/2, height/2));
  players.get(0).getHand().remove(c);
  if(players.get(0).getHand().size() < 3){
  players.get(0).getHand().add(deck.get(0));
  deck.get(0).setDrawn(true);
  deck.remove(deck.get(0));
  }
  updateHandPosition(players.get(0).getHand());
  updateVisuals = false;
  
}
public void updateCardsStart() {
  background(0);
  for (Card c : players.get(0).getHand())
    c.display();
  for (Card c : players.get(0).getLastCards())
    c.display();
    
    updateVisuals = true;
}

public void updateCardsGame(){
    background(0);
    Collections.sort(players.get(0).getHand(),sort);
    for (Card c : players.get(0).getHand())
    c.display();
    for (Card c : players.get(0).getLastCards())
    c.display();
    for (Card c : players.get(0).getPlantedCards())
    c.display();
    if(table.size() > 0)
    for (Card c : table)
    c.display();  
    updateVisuals = true;
}

public void mouseReleased(){
  if(played)
  played = false;
}


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
    private int cardColor = 255;
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
    public void update(){
    
    }
    
    public void display(){
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
public enum CardType {
  Club,
  Spade,
  Heart,
  Diamond,
  Joker,
}
class Player
{
  ArrayList<Card> currentHand;
  Card[] plantedCards;
  Card[] lastCards;
  
  Player(ArrayList<Card> hand, Card[] lastCards){
    currentHand = hand;
    this.lastCards = lastCards;
  }
  
  public ArrayList<Card> getHand(){
    return currentHand;
  }
  public Card[] getLastCards(){
    return lastCards;
  }
  public Card[] getPlantedCards(){
    return plantedCards;
  }
  public void setPlantedCards(Card[] selectedCards){
    plantedCards = selectedCards;
    for(int i = 0; i < selectedCards.length; i++){
      PVector newPosition = new PVector(lastCards[i].getPosition().x + 10,lastCards[i].getPosition().y - 10);  
      selectedCards[i].setPosition(newPosition);
      selectedCards[i].setTransparency(255);
    }

  }
  
  


}
public class Sort implements Comparator<Card> 
{ 
    public int compare(Card a, Card b) 
    { 
        return a.getActualValue() - b.getActualValue(); 
    } 
} 
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Satanas" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
