## Getting Started

Clone this repo, run this to download packages - <br/>
    flutter pub get <br/>
run this to actually run the project - <br/>
    flutter run <br/>
    or Run from VSCode <br/>

## Actual Logic

 As can be seen, the HomePageState class is a stateful widget inside the
 createState() of the HomePage class.

 The main methods are - build(), taskList(), addTaskButton(), displayTaskPopup(),
 and taskView(), along with another class in another file task.dart.
 task.dart file has the Task class, whose work is to create a Map() using the 
 parameters provided in the constructor, and also a factory constructor is used
 so that the map can be returned.


 build() method returns a Scaffold, that has three main properties - appBar, body
 and floatingActionWidget. We created the appbar within it, body property returns
 a SafeArea containing taskView() and floatingActionWidget property contains the
 addTaskButton() method.


 So firstly the addTaskButton(). This method returns a FloatingActionButton widget
 which contains two properties - onPressed that has displayTaskPopup(), and child,
 containing the icon widget.


 As for the displayTaskPopup(), in there we are showing the AlertBox() widget 
 from the showDialog() widget. showDialog() actually just implements the overlying 
 properties of an alertbox, like the exit animation on clicking outside the box, 
 dark overlay, etc.
            showDialog() takes in two parameters - context, that has the context 
 of the build() method, and builder, that takes in a function with BuildContext 
 parameter and returns the actual AlertBox() widget.
            AlertBox() widget has two main parameters - title, for the title of 
 alertbox and content, for the content of alertbox. We want to show an input field, 
 and so we used TextField widget. TextField widget takes in two parameters - 
 onSubmitted and onChanged. For onChanged, we are setting the values of the input 
 field inside the newTaskContent varialble (through using the parameter). For 
 onSubmitted, we are just adding the value of newTaskContent inside the box of 
 Hive. We check if it's null or not, and then create a new Task from the values, 
 and then add those inside the box, and finally update the state.


 Now comes the taskView() method, that's been returned inside the body of Scaffold.
 What we're doing here is that we are opening a box of Hive where we want to store
 our values. The thing is that this method actually returns a Future, and therefore
 the compiler will shift it to a different thread and then continue on with its
 tasks. But we don't want that as that will give error (accessing box without 
 opening it). And since this is a UI element (inside rendering), so we can't do 
 async/await.
            Therefore, what we're doing here is implementing the FutureBuilder()
 widget, which actually works with the future and depending on it's state, will 
 render appropriate values. It takes in two parameters - future, containing the
 futute that needs to be resolved, and builder, that will display the values. 
 Builder method takes in a function that has parameters - BuildContext and an 
 AsyncSnapshot. Snapshot actually has the current resolution of the future. If
 the snapshot has data within it, then we run the taskList(), otherwise we display
 the loading indicator.


 taksList() method actually renders the main content on the screen. It firstly 
 initializes the task variable with the contents of box from Hive. Then it uses
 the ListView.Builder() method to display all the things within that task variable.
            ListView() widget is used to render a scrollable list of items. The
            Builder() constructor is especially used if there are similar items
            to be displayed multiple times.
  It takes in two parameters - itemCount, for approximating the amount of scroll
  and itemBuilder, taking in a function of the items to displayed. This function
  has two parameters - BuildContext and an integer index. The function will be 
  called recursively for 0 <= index < itemcount.
  Inside that function, we are returning a ListTile widget, a prebuilt widget for
  this type of cases. Here we used 5 parameters - title (task to be performed), 
  subtitle (date of creation), trailing (icon at the end, in this case a checkbox),
  onTap (action to be done on tapping once), onLongPress (action to be done on 
  pressing).
            Logic in here is that, when creating the title, we apply style depending
            on the "done" property of our task. If its true, then we don't strike
            through it and display a blank checkbox. Otherwise if it's false, we
            apply a strikethrough, and create a done checkbox in it.
            On long pressing, we are deleting the current task from our box.
