import java.util.*; 
import java.lang.*; 
import java.io.*; 

ArrayList<Card> deck;
Sort sort;

void setup() {

  fullScreen(P2D);
  background(0);
  frameRate(60);
  deck = new ArrayList<Card>();
  sort = new Sort();
  File file = new File(dataPath("C:\\Users\\diogo\\Documents\\Processing\\Satanas-Card-Game\\Satanas\\data"));
  processFile(file);
}

void draw() {
  for (Card c : deck) {
    PVector cardPos = c.getPosition();
    PVector size = c.getSize();
    if(mouseX > cardPos.x && mouseX < cardPos.x + size.x && mouseY > cardPos.y && mouseY < cardPos.y + size.y){
      c.setTransparency(100);
    }
    else
      c.setTransparency(255);
    
    c.display();
  }
  println(frameRate);
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
  Collections.sort(deck, sort);
  //Collections.shuffle(deck);
  for (Card c : deck) {
    if (c.getType() == CardType.Club)
      c.setPosition(new PVector(100 + c.getActualValue() * 10, 20 * c.getActualValue()));
    else if (c.getType() == CardType.Heart)
      c.setPosition(new PVector(300 + c.getActualValue() * 10, 20 * c.getActualValue()));
    else if (c.getType() == CardType.Diamond)
      c.setPosition(new PVector(500 + c.getActualValue() * 10, 20 * c.getActualValue()));
    else if (c.getType() == CardType.Spade)
      c.setPosition(new PVector(700 + c.getActualValue() * 10, 20 * c.getActualValue()));
    else
      c.setPosition(new PVector(10 + c.getActualValue() * 10, 20 * c.getActualValue()));
    c.setDrawn(true);
  }
}
