import java.util.Arrays;

ArrayList<Card> deck;
File data;

void setup() {

  fullScreen();
  deck = new ArrayList<Card>();
  selectFolder("Process data: ", "fileSelected");
  noLoop();
}

void draw() {
  //if (data != null)
   // for(Card c : deck)
   // c.display();
}

void fileSelected(File selected) {
  if (selected == null)
    println("Shut");
  else {
    processFile(selected);
    data = selected;
  }
}

void processFile(File selection) {
  String[] images = selection.list();
  ArrayList<String> cards = new ArrayList<String>();
  for(String s : images){
    if(!s.contains("back"))
    cards.add(s);
  }
  
  ProcessDeck(cards);
  loop();
}

void ProcessDeck(ArrayList<String> cardsFile) {
  for (int i = 0; i < cardsFile.size(); i++) {
      String cardString = cardsFile.get(i).split(".png")[0];
      if(!cardString.contains("joker")){
      String value = cardString.split("_")[1];
      String type = cardString.split("_")[0];
      
      println(type);
      if (type.contains("clubs")) 
        deck.add(new Card( 0, value, cardsFile.get(i)));
      else if (type.contains("spades"))  
        deck.add(new Card( 1, value, cardsFile.get(i)));
      else if (type.contains("hearts")) 
        deck.add(new Card( 2, value, cardsFile.get(i)));
      else if (type.contains("diamonds")) 
        deck.add(new Card( 3, value, cardsFile.get(i)));
      }
      else
        deck.add(new Card(4, cardString, cardsFile.get(i)));
    }
}
