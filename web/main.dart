import 'dart:html';
import 'dart:async';
import 'dart:math' as Math;

//Some top-level variables
Element app = querySelector("#app"), snack;
var emptycell, turn, state;
List<Element> Cells;

void main(){
  emptycell = 9; //For draw check
  turn = 0; //For knowing who's turn
  state = 0; //For checking if the game is over

  //Main screen elements and their onClicks
  AddElement(new ParagraphElement(), app, "Choose Your Game Mode", "");
  AddElement(new ButtonElement(), app, "Play Against The Game", "play").onClick.listen((event) => play("game"));
  AddElement(new BRElement(), app, "", "");
  AddElement(new ButtonElement(), app, "Play Against Your Friend", "play").onClick.listen((event) => play("friend"));
}

//Adding elements to screen as programmatically
Element AddElement(Element type, Element parent, var values, var ids){
  Element element = type;
  element.text = values;
  element.id = ids;
  parent.children.add(element);
  return element;
}

//Choosing X or O
void play(var against){
  clear();
  AddElement(new ParagraphElement(), app, "Choose Your Weapon", "");
  AddElement(new ButtonElement(), app, "X", "play").onClick.listen((event) => table(against, 0));
  AddElement(new ButtonElement(), app, "O", "play").onClick.listen((event) => table(against, 1));
}

//Clearing the screen
void clear(){
  app.children.clear();
}

//Game Table
void table(var against, var Turn){
  clear();

  turn = Turn;

  //Game Table elements and their onClicks
  Element table = AddElement(new TableElement(), app, "", ""); //Table
  for(int i = 0; i < 3; i++){
    Element tr = AddElement(new TableRowElement(), table, "", ""); //Table rows
    for(int j = 0; j < 3; j++){
      tr.innerHtml = "<th></th><th></th><th></th>"; //Table cells
    }
  }

  //Adding All <th> Elements to List
  //Btw <th> elements can't definable like other elements in the app
  //That's why we doing like this
  Cells = querySelectorAll("th");

  for(var i = 0; i < Cells.length; i++)
    Cells[i].onClick.listen((event) => onCellClick(i, against)); //and onClicks of cells
}

void onCellClick(var cursor, var against){
  
  if(Cells[cursor].text == "" && state == 0){ //If clicked cell is empty and game haven't ended yet
    switch(turn){
      case 0:
        Cells[cursor].text = "x";
        turn = 1;
        break;
      case 1:
        Cells[cursor].text = "o";
        turn = 0;
        break;
    }

    //Controlling game state for player's move
    ControlTheState();

    if(against == "game" && state == 0){
      //Finding empty cells
      List<int> EmptyCells = [];

      for(var i = 0; i < Cells.length; i++){
        if(Cells[i].text == "")
          EmptyCells.add(i);
      }

      var rand = Math.Random().nextInt(EmptyCells.length);
      
      move(var m){
        //Selecting random cell to make a move
        Cells[EmptyCells[rand]].text = m;
        //Controling again for game's move
        ControlTheState();
      };
      
      switch(turn){
        case 0:
          new Timer(new Duration(milliseconds: 500), () => move("x"));
          turn = 1;
          break;
        case 1:
          new Timer(new Duration(milliseconds: 500), () => move("o"));
          turn = 0;
          break;
      }
    }
  }
}

//Game statue control
void State(var a,b,c,d){
  if(Cells[a].text == d && Cells[b].text == d && Cells[c].text == d)
    if(d == "x")
      state = 1;
    else if(d == "o")
      state = 2;
}

//Controlling
void ControlTheState(){
  //Draw
  if(emptycell > 0)
    emptycell--;
  if(emptycell <= 0)
    state = 3;
  
  List<String> xo = ["x", "o"];
  
  for(int i = 0; i < xo.length; i++){
      //Horizontal win statues
      State(0, 1, 2, xo[i]); //1.1 1.2 1.3
      State(3, 4, 5, xo[i]); //2.1 2.2 2.3
      State(6, 7, 8, xo[i]); //3.1 3.2 3.3

      //Vertical win statues
      State(0, 3, 6, xo[i]); //1.1 2.1 3.1
      State(1, 4, 7, xo[i]); //1.2 2.2 3.3
      State(2, 5, 8, xo[i]); //1.3 2.3 3.3

      //Cross win statues
      State(0, 4, 8, xo[i]); //1.1 2.2 3.3
      State(2, 4, 6, xo[i]); //1.3 2.2 3.1
    }
  
  	//When game over
    if(state != 0 || emptycell <= 0){
      switch(state){
        case 1:
          Snack("Winner is X. ");
          break;
        case 2:
          Snack("Winner is O.");
          break;
        case 3:
          Snack("Draw. ");
          break;
      }
    }
}

//Snackbar for game over message
void Snack(var winner){
  snack = AddElement(new DivElement(), querySelector("body"), "", "snackbar");
  AddElement(new ParagraphElement(), snack, winner + "Wanna restart the game?", "");
  Element b = AddElement(new ButtonElement(), snack, "OK", "ok");
  b.onClick.listen((event) => OkButton(snack, b));
  snack.style.opacity = "1";
  snack.style.bottom = "0";
}

//Snackbar's OK button
void OkButton(Element snack, Element p){
  snack.style.opacity = "0";
  clear();
  snack.remove();
  main();
}
