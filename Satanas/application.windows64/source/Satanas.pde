import java.util.*; 
import java.lang.*; 
import java.io.*; 

ArrayList<Card> deck;
ArrayList<Player> players;
ArrayList<Card> selected;
ArrayList<Card> table;
Sort sort;
int state = 0;
boolean updateVisuals;
boolean played;

void setup() {

  fullScreen();
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

void draw() {
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

void startGame() {
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

void choseCards() {
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

void processFile(File selection) {
  String[] images = selection.list();
  ArrayList<String> cards = new ArrayList<String>();
  for (String s : images) 
    if (!s.contains("back"))
      cards.add(s);

  createDeck(cards);
}

void createDeck(ArrayList<String> cardsFile) {
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

void processDeck() {
  //Collections.sort(deck, sort);
  Collections.shuffle(deck);
  for (Card c : deck) {
    c.setPosition(new PVector(10 + c.getActualValue() * 5, 10 * c.getActualValue()));
  }
  if (deck.size() >= 54)
    createPlayer(deck, 0);
}

void createPlayer(ArrayList<Card> cards, int numbP) {
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

void updateHandPosition(ArrayList<Card> newHand)
{
  for(int i = 0; i < newHand.size(); i++){
      newHand.get(i).setPosition(new PVector((width/2 - 420) + (i * 120), height -500));
      newHand.get(i).setDrawn(true);
  }
}

void playCard(Card c){
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
void updateCardsStart() {
  background(0);
  for (Card c : players.get(0).getHand())
    c.display();
  for (Card c : players.get(0).getLastCards())
    c.display();
    
    updateVisuals = true;
}

void updateCardsGame(){
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

void mouseReleased(){
  if(played)
  played = false;
}
