/* ------------ Used in Apex Classes and Methods Live Session ------------ */

//Anatomy of a Class / Class Variables
public with sharing class Dog {
    
    public String name;
    public String breed;
    public Date birthDate;
    public Decimal weight;

    //Default Constructor
    public Dog() {

    }

    //Single Argument Constructor
    public Dog(String dogName) {
        name = dogName;
    }

    //Using This Keyword
    public Dog(String name, String breed) {
        this.name = name;
        this.breed = breed;
    }


    //No Argument Method
    public String greetDog(String greeting) {
        return greeting + ',' + name;
    } 

    //Calculate Age
    public Integer getAge() {
        return Integer.valueOf(
            birthDate.daysBetween(Date.today()) / 365
        );
    }

    //Passing Arguments by Value
    public String sayCommand(String command) {
        command = 'Roll Over'; //Override command passed in
        return command + ', ' + name;
    }

    //Passing Arguments by Reference
    public void matchOwnerName(Contact dogOwner) {
        dogOwner.FirstName = this.name; //Update name passed in
    }


    public static void run() {

        //Object Creation
        Dog myDog = new Dog();
        myDog.name = 'Spot';
        myDog.weight = 100.5;

        Dog yourDog = new Dog();
        myDog.name = 'Lola';
        myDog.weight = 80.5;


        //Object Creation with dogName Constructor
        Dog myDog2 = new Dog('Quigley');
        myDog2.breed = 'Labrador';

        Dog yourDog2 = new Dog('Spot');
        yourDog2.breed = 'Cocker Spaniel';


        //Greet Dog
        Dog myDog3 = new Dog('Buster');
        System.debug(myDog3.greetDog('Hello'));

        //Calculate Age
        Dog myDog4 = new Dog('Marley');
        myDog4.birthDate = Date.newInstance(2020, 5, 1);
        System.debug(myDog4.getAge());

        //Passing Arguments by Value
        Dog myDog5 = new Dog('Lassie');
        String command = 'Sit';
        System.debug('Value before method: ' + command);
        String createdCommand = myDog5.sayCommand(command);
        System.debug('Command: ' + createdCommand);
        System.debug('Value after method: ' + command);

        //Passing Arguments by Reference
        Dog myDog6 = new Dog('Toto');
        Contact dogOwner = new Contact(FirstName = 'Dorothy');
        System.debug('Name before method: ' + dogOwner.FirstName);
        myDog6.matchOwnerName(dogOwner);
        System.debug('Name after method: ' + dogOwner.FirstName);

    }


}