package org.hucs;

public class App {
    public static void main(String[] args) {
        MainMenu mainMenu = new MainMenu();

        SettingsMenu settings = new SettingsMenu();
        settings.addSubMenu(1, new OptionMenu("Change Language"));
        settings.addSubMenu(2, new OptionMenu("Change Theme"));

        mainMenu.addSubMenu(1, settings);
        mainMenu.addSubMenu(2, new OptionMenu("Start Game"));
        mainMenu.addSubMenu(3, new OptionMenu("About"));
        mainMenu.addSubMenu(4, new OptionMenu("Launch a rocket", new RocketLaunch()));

        mainMenu.execute();
        System.out.println("Exiting...");
    }
}

