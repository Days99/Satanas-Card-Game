public class Sort implements Comparator<Card> 
{ 
    public int compare(Card a, Card b) 
    { 
        return a.getActualValue() - b.getActualValue(); 
    } 
} 
