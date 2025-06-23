package org.hucs;

import java.util.Scanner;

public class OptionMenu implements Menu {
    private String name;
    private Command command;

    public OptionMenu(String name) {
        this.name = name;
    }

    public OptionMenu(String name, Command command) {
        this.name = name;
        this.command = command;
    }

    @Override
    public void show() {
        System.out.println("Selected: " + name);
    }

    @Override
    public void execute() {
        if(command != null){
            command.execute();
        } else {
            show();
        }
        System.out.println("Press Enter to return...");
        new Scanner(System.in).nextLine();
    }

    public String getTitle() {
        return name;
    }
}

