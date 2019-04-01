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
