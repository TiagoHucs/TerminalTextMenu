package org.hucs;

public class Command implements ICommand {

    String text;

    public Command(String text){
        this.text = text;
    }

    @Override
    public void execute() {
        System.out.println(text);
    }
}
