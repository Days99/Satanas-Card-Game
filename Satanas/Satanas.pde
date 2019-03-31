import java.util.*; 
import java.lang.*; 
import java.io.*; 

ArrayList<Card> deck;
Sort sort;

void setup() {

  fullScreen();
  deck = new ArrayList<Card>();
  sort = new Sort();
  File file = new File(dataPath("C:\\Users\\diogo\\Documents\\Processing\\Satanas-Card-Game\\Satanas\\data"));
  processFile(file);
  noLoop();
}

void draw() {
   for (Card c : deck) {
       c.display();
   }
}

void processFile(File selection) {
  String[] images = selection.list();
  ArrayList<String> cards = new ArrayList<String>();
  for (String s : images) 
    if (!s.contains("back"))
      cards.add(s);
      
  ProcessDeck(cards);
}


void ProcessDeck(ArrayList<String> cardsFile) {
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

    Collections.sort(deck, sort);
    //  Collections.shuffle(deck);
    displayDeck();
  }
}

void displayDeck() {
    for (Card c : deck) {
    if(c.getType() == CardType.Club)
    c.setPosition(new PVector(50 + c.getActualValue() * 10, 20 * c.getActualValue()));
    else if(c.getType() == CardType.Heart)
    c.setPosition(new PVector(200 + c.getActualValue() * 10, 20 * c.getActualValue()));
    else if(c.getType() == CardType.Diamond)
    c.setPosition(new PVector(350 + c.getActualValue() * 10, 20 * c.getActualValue()));
    else if(c.getType() == CardType.Spade)
    c.setPosition(new PVector(500 + c.getActualValue() * 10, 20 * c.getActualValue()));
    else
    c.setPosition(new PVector(10 + c.getActualValue() * 10, 20 * c.getActualValue()));
    
    c.setDrawn(true);
  }
  loop();
}
